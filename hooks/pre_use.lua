local http = require("http")
local json = require("json")

function PLUGIN:PreUse(ctx)
    local version = ctx.version
    
    if version ~= "latest" then
        return {
            version = version,
        }
    end

    local token = os.getenv("GITHUB_TOKEN") or os.getenv("MISE_GITHUB_TOKEN")
    local headers = {}
    if token then
        headers["Authorization"] = "Bearer " .. token
    end

    local url = "https://api.github.com/repos/ggml-org/llama.cpp/releases/latest"
    local resp, err = http.get({ url = url, headers = headers })
    if err ~= nil then
        error("Failed to fetch latest release: " .. tostring(err))
    end
    if resp.status_code ~= 200 then
        error("GitHub API returned status " .. resp.status_code)
    end

    local release = json.decode(resp.body)
    if not release or not release.tag_name then
        error("Failed to parse latest release information")
    end

    return {
        version = release.tag_name,
    }
end
