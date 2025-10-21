function PLUGIN:ParseLegacyFile(ctx)
    local filePath = ctx.filePath
    
    local file = io.open(filePath, "r")
    if not file then
        return nil
    end
    
    local content = file:read("*all")
    file:close()
    
    if not content or content == "" then
        return nil
    end
    
    local version = content:match("^%s*(.-)%s*$")
    
    if not version or version == "" then
        return nil
    end
    
    return {
        version = version,
    }
end
