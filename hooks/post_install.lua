local platform = require("platform")

function PLUGIN:PostInstall(ctx)
    local sdkInfo = ctx.sdkInfo[PLUGIN.name]
    local path = sdkInfo.path
    local preinstall_info = sdkInfo.preinstall_info or {}

    os.execute("mkdir -p " .. path .. "/bin")

    if preinstall_info.build_from_source then
        local os_name = platform.get_os()
        local build_dir = path .. "/build"
        
        os.execute("mkdir -p " .. build_dir)
        
        local cmake_cmd = "cd " .. build_dir .. " && cmake .."
        local result = os.execute(cmake_cmd)
        if result ~= 0 then
            error("CMake configuration failed. Ensure CMake and a C++ compiler are installed.")
        end
        
        local build_cmd = "cd " .. build_dir .. " && cmake --build . --config Release"
        result = os.execute(build_cmd)
        if result ~= 0 then
            error("Build failed. Check build logs for errors.")
        end
        
        local bin_pattern = build_dir .. "/bin/*"
        if os_name == "win" then
            bin_pattern = build_dir .. "/Release/*.exe"
        end
        
        os.execute("cp -r " .. bin_pattern .. " " .. path .. "/bin/ 2>/dev/null || true")
        
        if RUNTIME.osType ~= "Windows" then
            os.execute("chmod +x " .. path .. "/bin/*")
        end
    else
        local extracted_pattern = path .. "/llama-*-bin-*"
        local found_extracted = os.execute("ls -d " .. extracted_pattern .. " > /dev/null 2>&1") == 0
        
        if found_extracted then
            os.execute("cp -r " .. extracted_pattern .. "/* " .. path .. "/bin/")
        else
            local zip_pattern = path .. "/*.zip"
            local found_zip = os.execute("ls " .. zip_pattern .. " > /dev/null 2>&1") == 0
            
            if found_zip then
                os.execute("cd " .. path .. " && unzip -q '*.zip'")
                os.execute("cp -r " .. extracted_pattern .. "/* " .. path .. "/bin/")
            end
        end
        
        if RUNTIME.osType ~= "Windows" then
            os.execute("chmod +x " .. path .. "/bin/*")
        end
    end

    local test_binaries = {"llama-cli", "llama-server"}
    local test_passed = false
    
    for _, binary in ipairs(test_binaries) do
        local test_path = path .. "/bin/" .. binary
        if RUNTIME.osType == "Windows" then
            test_path = test_path .. ".exe"
        end
        
        local test_result = os.execute(test_path .. " --version > /dev/null 2>&1")
        if test_result == 0 then
            test_passed = true
            break
        end
    end
    
    if not test_passed then
        error("llama.cpp installation verification failed. No working binaries found.")
    end
    
    os.execute("rm -rf " .. path .. "/*.zip " .. path .. "/*.tar.gz " .. path .. "/llama-*-bin-* 2>/dev/null || true")
end
