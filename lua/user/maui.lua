--
-- helper functions
--

function string.starts(String, Start)
   return string.sub(String, 1, string.len(Start)) == Start
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
  local command = 'dotnet build ' .. project .. ' -t:Run -f net6.0-ios -p:_DeviceName=:v2:udid=' .. device_id
  vim.cmd('split | terminal')
  vim.cmd(':call jobsend(b:terminal_job_id, "' .. command .. '\\n")')
  vim.cmd(':set nonumber')
  vim.cmd(':exe "normal G"')
end

function MauiBuildAndroid(Opts)
  local _,_, project = string.find(Opts.args, "-p%s([^%s]*)")
  local command = 'dotnet build ' .. project .. ' -t:Run -f net6.0-android && adb logcat'
  vim.cmd('split | terminal')
  vim.cmd(':call jobsend(b:terminal_job_id, "' .. command .. '\\n")')
  vim.cmd(':set nonumber')
  vim.cmd(':exe "normal G"')
end

function MauiClean()
  local command = 'dotnet clean'
  vim.cmd('split | terminal')
  vim.cmd(':call jobsend(b:terminal_job_id, "' .. command .. '\\n")')
  vim.cmd(':set nonumber')
  vim.cmd(':exe "normal G"')
end

function MauiRestoreNuget()
  local command = 'dotnet restore'
  vim.cmd('split | terminal')
  vim.cmd(':call jobsend(b:terminal_job_id, "' .. command .. '\\n")')
  vim.cmd(':set nonumber')
  vim.cmd(':exe "normal G"')
end

function MauiExit()
  vim.cmd(':exe "normal Q"')
  vim.cmd(':q')
end

function PmxBuildiOS(Opts)
  local command = nil
  local _,_,_, device_name = string.find(Opts.args, "(-d)%s'([^']*)'")
  local _,_, configuration = string.find(Opts.args, "-c%s([^%s]*)")
  local device_id = get_device_id(device_name)

  if configuration == 'Debug-iOS-Simulator' then
   command = 'msbuild /t:Build /p:Configuration=Debug-iOS-Simulator && /Library/Frameworks/Xamarin.iOS.framework/Versions/Current/bin/mlaunch --launchsim=PressMatrix.UI.iOS/bin/iPhoneSimulator/Debug/PressMatrix.UI.iOS.app --device::v2:udid=' .. device_id
  elseif configuration == 'Debug-iOS-Tests-Simulator' then
   command = 'msbuild /t:Build /p:Configuration=Debug-iOS-Tests-Simulator && /Library/Frameworks/Xamarin.iOS.framework/Versions/Current/bin/mlaunch --launchsim=PressMatrix.UI.TestHarness.iOS/bin/iPhoneSimulator/Debug/PressMatrix.UI.TestHarness.iOS.app --device::v2:udid=' .. device_id
  end

  vim.cmd('split | terminal')
  vim.cmd(':call jobsend(b:terminal_job_id, "' .. command .. '\\n")')
  vim.cmd(':set nonumber')
  vim.cmd(':exe "normal G"')
end

function PmxBuildAndroid()
  local command = 'msbuild /t:Build /p:AndroidBuildApplicationPackage=true /p:Configuration=Debug-Android && adb install PressMatrix.UI.Droid/bin/Debug/com.pressmatrix.development-Signed.apk && adb shell monkey -p com.pressmatrix.development 1 && adb logcat'
  vim.cmd('split | terminal')
  vim.cmd(':call jobsend(b:terminal_job_id, "' .. command .. '\\n")')
  vim.cmd(':set nonumber')
  vim.cmd(':exe "normal G"')
end

function MsBuildUpdateAndroidResources()
  local command = 'msbuild /t:UpdateAndroidResources'
  vim.cmd('split | terminal')
  vim.cmd(':call jobsend(b:terminal_job_id, "' .. command .. '\\n")')
  vim.cmd(':set nonumber')
  vim.cmd(':exe "normal G"')
end

function MsBuildClean()
  local command = 'msbuild /t:Clean'
  vim.cmd('split | terminal')
  vim.cmd(':call jobsend(b:terminal_job_id, "' .. command .. '\\n")')
  vim.cmd(':set nonumber')
  vim.cmd(':exe "normal G"')
end

function MsBuildRestoreNuget()
  local command = 'nuget restore'
  vim.cmd('split | terminal')
  vim.cmd(':call jobsend(b:terminal_job_id, "' .. command .. '\\n")')
  vim.cmd(':set nonumber')
  vim.cmd(':exe "normal G"')
end

--
-- completions
--

local function maui_ios_completions(ArgLead, _,_)
  if string.starts(ArgLead, '-d') then
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
  if string.starts(ArgLead, '-p') then
    return {
      "-p sample/Playground/Playground.csproj",
      "-p tests/Plugin.Firebase.IntegrationTests/Plugin.Firebase.IntegrationTests.csproj"
    }
  end
end

local function pmx_ios_completions(ArgLead, _,_)
  if string.starts(ArgLead, '-d') then
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

--
-- user commands --
--

vim.api.nvim_create_user_command("MauiBuildiOS", MauiBuildiOS, { nargs='?', complete=maui_ios_completions })
vim.api.nvim_create_user_command("MauiBuildAndroid", MauiBuildAndroid, { nargs='?', complete=maui_android_completions })
vim.api.nvim_create_user_command("MauiClean", MauiClean, {})
vim.api.nvim_create_user_command("MauiRestoreNuget", MauiRestoreNuget, {})
vim.api.nvim_create_user_command("MauiExit", MauiExit, {})
vim.api.nvim_create_user_command("PmxBuildiOS", PmxBuildiOS, { nargs='?', complete=pmx_ios_completions })
vim.api.nvim_create_user_command("PmxBuildAndroid", PmxBuildAndroid, {})
vim.api.nvim_create_user_command("MsBuildUpdateAndroidResources", MsBuildUpdateAndroidResources, {})
vim.api.nvim_create_user_command("MsBuildClean", MsBuildClean, {})
vim.api.nvim_create_user_command("MsBuildRestoreNuget", MsBuildRestoreNuget, {})
