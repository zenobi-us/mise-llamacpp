function PLUGIN:EnvKeys(ctx)
    local mainPath = ctx.path

    local env_vars = {
        {
            key = "LLAMACPP_HOME",
            value = mainPath,
        },
        {
            key = "PATH",
            value = mainPath .. "/bin",
        },
    }

    if RUNTIME.osType == "Darwin" then
        table.insert(env_vars, {
            key = "DYLD_LIBRARY_PATH",
            value = mainPath .. "/lib",
        })
    elseif RUNTIME.osType == "Linux" then
        table.insert(env_vars, {
            key = "LD_LIBRARY_PATH",
            value = mainPath .. "/lib",
        })
    end

    return env_vars
end
