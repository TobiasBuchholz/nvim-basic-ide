--
-- setup
--

vim.notify = require("notify")

--
-- helper functions
--

function string.starts(String, Start)
   return string.sub(String, 1, string.len(Start)) == Start
end

local function send_terminal_command(Command)
  vim.cmd(":TermExec cmd='" .. Command .. "'")
end

local function get_device_id(device_name)
  local handle = io.popen("xcrun simctl list | egrep -vwE 'com' | egrep -m1 -i '" .. device_name .." \\(' | egrep -vwE 'unavailable' | sed -e 's/iPad Pro (12.9-inch) (4th generation)//' |cut -d '(' -f2 | cut -d ')' -f1")
  if handle then
    return string.gsub(handle:read("*a"), "%s+", "")
  end
end

--
-- command functions
--

function MauiBuildiOS(Opts)
  local _,_,_, device_name = string.find(Opts.args, "(-d)%s'([^']*)'")
  local _,_, project = string.find(Opts.args, "-p%s([^%s]*)")
  local device_id = get_device_id(device_name)
  send_terminal_command('dotnet build ' .. project .. ' -t:Run -f net6.0-ios -p:_DeviceName=:v2:udid=' .. device_id)
end

function MauiBuildAndroid(Opts)
  local _,_, project = string.find(Opts.args, "-p%s([^%s]*)")
  send_terminal_command('dotnet build ' .. project .. ' -t:Run -f net6.0-android && adb logcat')
end

function MauiClean()
  send_terminal_command('dotnet clean')
end

function MauiDeleteBinAndObjFolders()
  os.execute('find . -type d -name bin -prune -exec rm -rf {} \\;')
  os.execute('find . -type d -name obj -prune -exec rm -rf {} \\;')
  vim.notify('All bin and obj folders successfully deleted!', 'info', { title = 'maui.lua' })
end

function MauiRestoreNuget()
  send_terminal_command('dotnet restore')
end

function MauiCreateFirebaseNugetPackage(Opts)
  local _,_, project_name = string.find(Opts.args, "-p%s([^%s]*)")
  send_terminal_command('dotnet restore')
  send_terminal_command('rm -r src/' .. project_name .. '/bin')
  send_terminal_command('rm -r src/' .. project_name .. '/obj')
  send_terminal_command('dotnet restore')
  send_terminal_command('dotnet clean')
  send_terminal_command('dotnet build src/' .. project_name .. '/' .. project_name .. '.csproj -c Release')
  send_terminal_command('dotnet pack src/' .. project_name .. '/' .. project_name .. '.csproj -c Release -o nupkgs/')
  vim.notify('Nuget package created successfully!', 'info', { title = 'maui.lua' })
end

function MauiCreateAllFirebaseNugetPackages()
  MauiDeleteBinAndObjFolders()
  send_terminal_command('rm -r nupkgs/')
  send_terminal_command('dotnet restore')
  send_terminal_command('dotnet clean')
  send_terminal_command('dotnet build src/Analytics/Analytics.csproj -c Release')
  send_terminal_command('dotnet build src/Auth/Auth.csproj -c Release')
  send_terminal_command('dotnet build src/Auth.Facebook/Auth.Facebook.csproj -c Release')
  send_terminal_command('dotnet build src/Bundled/Bundled.csproj -c Release')
  send_terminal_command('dotnet build src/CloudMessaging/CloudMessaging.csproj -c Release')
  send_terminal_command('dotnet build src/Core/Core.csproj -c Release')
  send_terminal_command('dotnet build src/Crashlytics/Crashlytics.csproj -c Release')
  send_terminal_command('dotnet build src/DynamicLinks/DynamicLinks.csproj -c Release')
  send_terminal_command('dotnet build src/Firestore/Firestore.csproj -c Release')
  send_terminal_command('dotnet build src/Functions/Functions.csproj -c Release')
  send_terminal_command('dotnet build src/RemoteConfig/RemoteConfig.csproj -c Release')
  send_terminal_command('dotnet build src/Storage/Storage.csproj -c Release')
  send_terminal_command('dotnet pack src/Analytics/Analytics.csproj -c Release -o nupkgs/')
  send_terminal_command('dotnet pack src/Auth/Auth.csproj -c Release -o nupkgs/')
  send_terminal_command('dotnet pack src/Auth.Facebook/Auth.Facebook.csproj -c Release -o nupkgs/')
  send_terminal_command('dotnet pack src/Bundled/Bundled.csproj -c Release -o nupkgs/')
  send_terminal_command('dotnet pack src/CloudMessaging/CloudMessaging.csproj -c Release -o nupkgs/')
  send_terminal_command('dotnet pack src/Core/Core.csproj -c Release -o nupkgs/')
  send_terminal_command('dotnet pack src/Crashlytics/Crashlytics.csproj -c Release -o nupkgs/')
  send_terminal_command('dotnet pack src/DynamicLinks/DynamicLinks.csproj -c Release -o nupkgs/')
  send_terminal_command('dotnet pack src/Firestore/Firestore.csproj -c Release -o nupkgs/')
  send_terminal_command('dotnet pack src/Functions/Functions.csproj -c Release -o nupkgs/')
  send_terminal_command('dotnet pack src/RemoteConfig/RemoteConfig.csproj -c Release -o nupkgs/')
  send_terminal_command('dotnet pack src/Storage/Storage.csproj -c Release -o nupkgs/')
end

function PmxBuildiOS(Opts)
  local _,_,_, device_name = string.find(Opts.args, "(-d)%s'([^']*)'")
  local _,_, configuration = string.find(Opts.args, "-c%s([^%s]*)")
  local device_id = get_device_id(device_name)

  if configuration == 'Debug-iOS-Simulator' then
   send_terminal_command('msbuild /t:Build /p:Configuration=Debug-iOS-Simulator && /Library/Frameworks/Xamarin.iOS.framework/Versions/Current/bin/mlaunch --launchsim=PressMatrix.UI.iOS/bin/iPhoneSimulator/Debug/PressMatrix.UI.iOS.app --device::v2:udid=' .. device_id)
  elseif configuration == 'Debug-iOS-Tests-Simulator' then
   send_terminal_command('msbuild /t:Build /p:Configuration=Debug-iOS-Tests-Simulator && /Library/Frameworks/Xamarin.iOS.framework/Versions/Current/bin/mlaunch --launchsim=PressMatrix.UI.TestHarness.iOS/bin/iPhoneSimulator/Debug/PressMatrix.UI.TestHarness.iOS.app --device::v2:udid=' .. device_id)
  end
end

function PmxBuildAndroid()
  send_terminal_command('msbuild /t:Build /p:AndroidBuildApplicationPackage=true /p:Configuration=Debug-Android && adb install PressMatrix.UI.Droid/bin/Debug/com.pressmatrix.development-Signed.apk && adb shell monkey -p com.pressmatrix.development 1 && adb logcat')
end

function MsBuildUpdateAndroidResources()
  send_terminal_command('msbuild /t:UpdateAndroidResources')
end

function MsBuildClean()
  send_terminal_command('msbuild /t:Clean')
end

function MsBuildRestoreNuget()
  send_terminal_command('nuget restore')
end

--
-- completions
--

local function maui_ios_completions(ArgLead, _,_)
  if ArgLead == '' then
    return { "-d", "-p" }
  elseif string.starts(ArgLead, '-d') then
    return {
      "-d 'iPhone 14'",
      "-d 'iPhone 8'",
      "-d 'iPad Pro \\(12.9-inch\\) \\(4th generation\\)'",
    }
  elseif string.starts(ArgLead, '-p') then
    return {
      "-p sample/Playground/Playground.csproj",
      "-p tests/Plugin.Firebase.IntegrationTests/Plugin.Firebase.IntegrationTests.csproj"
    }
  end
end

local function maui_android_completions(ArgLead, _,_)
  if ArgLead == '' then
    return { "-p" }
  elseif string.starts(ArgLead, '-p') then
    return {
      "-p sample/Playground/Playground.csproj",
      "-p tests/Plugin.Firebase.IntegrationTests/Plugin.Firebase.IntegrationTests.csproj"
    }
  end
end

local function pmx_ios_completions(ArgLead, _,_)
  if ArgLead == '' then
    return { "-d", "-c" }
  elseif string.starts(ArgLead, '-d') then
    return {
      "-d 'iPhone 14'",
      "-d 'iPhone 8'",
      "-d 'iPad Pro \\(12.9-inch\\) \\(4th generation\\)'",
    }
  elseif string.starts(ArgLead, '-c') then
    return {
      "-c Debug-iOS-Simulator",
      "-c Debug-iOS-Tests-Simulator"
    }
  end
end

local function firebase_nuget_package_completions(ArgLead, _,_)
  if ArgLead == '' then
    return { "-p" }
  elseif string.starts(ArgLead, '-p') then
    return {
      "-p Analytics",
      "-p Auth",
      "-p Auth.Facebook",
      "-p Bundled",
      "-p CloudMessaging",
      "-p Core",
      "-p Crashlytics",
      "-p DynamicLinks",
      "-p Firestore",
      "-p Functions",
      "-p RemoteConfig",
      "-p Storage"
    }
  end
end

--
-- user commands --
--

vim.api.nvim_create_user_command("MauiBuildiOS", MauiBuildiOS, { nargs='+', complete=maui_ios_completions })
vim.api.nvim_create_user_command("MauiBuildAndroid", MauiBuildAndroid, { nargs=1, complete=maui_android_completions })
vim.api.nvim_create_user_command("MauiClean", MauiClean, {})
vim.api.nvim_create_user_command("MauiDeleteBinAndObjFolders", MauiDeleteBinAndObjFolders, {})
vim.api.nvim_create_user_command("MauiRestoreNuget", MauiRestoreNuget, {})
vim.api.nvim_create_user_command("MauiCreateFirebaseNugetPackage", MauiCreateFirebaseNugetPackage, { nargs='+', complete=firebase_nuget_package_completions })
vim.api.nvim_create_user_command("MauiCreateAllFirebaseNugetPackages", MauiCreateAllFirebaseNugetPackages, {})
vim.api.nvim_create_user_command("PmxBuildiOS", PmxBuildiOS, { nargs='?', complete=pmx_ios_completions })
vim.api.nvim_create_user_command("PmxBuildAndroid", PmxBuildAndroid, {})
vim.api.nvim_create_user_command("MsBuildUpdateAndroidResources", MsBuildUpdateAndroidResources, {})
vim.api.nvim_create_user_command("MsBuildClean", MsBuildClean, {})
vim.api.nvim_create_user_command("MsBuildRestoreNuget", MsBuildRestoreNuget, {})
