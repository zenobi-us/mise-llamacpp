-- hooks/available.lua
-- Returns a list of available versions for llama.cpp
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#available-hook

local http = require("http")
local json = require("json")

local cache = { versions = nil, timestamp = nil }
local cache_ttl = 12 * 60 * 60

function PLUGIN:Available(ctx)
    local now = os.time()
    if cache.versions and cache.timestamp and (now - cache.timestamp) < cache_ttl then
        return cache.versions
    end

    local token = os.getenv("GITHUB_TOKEN") or os.getenv("MISE_GITHUB_TOKEN")
    local headers = {}
    if token then
        headers["Authorization"] = "Bearer " .. token
    end

    local url = "https://api.github.com/repos/ggml-org/llama.cpp/releases?per_page=100"
    local resp, err = http.get({ url = url, headers = headers })
    if err ~= nil then
        error("Failed to fetch releases: " .. tostring(err))
    end
    if resp.status_code ~= 200 then
        error("GitHub API returned status " .. resp.status_code)
    end

    local releases = json.decode(resp.body) or {}
    local result = {}
    for _, r in ipairs(releases) do
        table.insert(result, {
            version = r.tag_name,
            note = r.name or r.tag_name,
            published_at = r.published_at
        })
    end

    cache.versions = result
    cache.timestamp = now
    return result
end 
