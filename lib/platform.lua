-- lib/platform.lua
-- Platform detection helpers for llama.cpp releases

local M = {}

function M.get_arch()
    local arch = RUNTIME.archType
    if arch == "amd64" then
        return "x64"
    elseif arch == "386" then
        return "x86"
    elseif arch == "arm64" then
        return "arm64"
    elseif arch == "s390x" then
        return "s390x"
    else
        return arch
    end
end

function M.get_os()
    local os = RUNTIME.osType
    if os == "Windows" then
        return "win"
    elseif os == "Darwin" then
        return "macos"
    else
        return "ubuntu"
    end
end

function M.get_platform()
    return M.get_os() .. "-" .. M.get_arch()
end

return M
