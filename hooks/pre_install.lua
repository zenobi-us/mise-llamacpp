local http = require("http")
local json = require("json")
local platform = require("platform")

function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local build_id = version:match("^b(%d+)$")
    
    if not build_id then
        error("Invalid version format. Expected format: b1234 (e.g., b6811)")
    end

    local token = os.getenv("GITHUB_TOKEN") or os.getenv("MISE_GITHUB_TOKEN")
    local headers = {}
    if token then
        headers["Authorization"] = "Bearer " .. token
    end

    local release_url = "https://api.github.com/repos/ggml-org/llama.cpp/releases/tags/" .. version
    local resp, err = http.get({ url = release_url, headers = headers })
    if err ~= nil then
        error("Failed to fetch release info: " .. tostring(err))
    end
    if resp.status_code ~= 200 then
        error("GitHub API returned status " .. resp.status_code .. " for version " .. version)
    end

    local release = json.decode(resp.body)
    if not release or not release.assets then
        error("Invalid release data for version " .. version)
    end

    local os_name = platform.get_os()
    local arch = platform.get_arch()
    local variant = os.getenv("LLAMACPP_VARIANT") or "cpu"

    local pattern_parts = {
        "llama%-" .. build_id .. "%-bin%-",
        os_name,
        "%-"
    }
    
    if variant ~= "cpu" then
        table.insert(pattern_parts, variant .. "%-")
    end
    
    table.insert(pattern_parts, arch)
    local pattern = table.concat(pattern_parts)

    local selected_asset = nil
    local source_asset = nil
    
    for _, asset in ipairs(release.assets) do
        if asset.name:match(pattern) then
            selected_asset = asset
            break
        end
        if asset.name:match("^llama%-" .. build_id .. "%-source%.tar%.gz$") then
            source_asset = asset
        end
    end

    if selected_asset then
        return {
            version = version,
            url = selected_asset.browser_download_url,
            note = "Downloading prebuilt binary: " .. selected_asset.name
        }
    elseif source_asset then
        return {
            version = version,
            url = source_asset.browser_download_url,
            note = "No prebuilt binary found. Downloading source: " .. source_asset.name,
            build_from_source = true
        }
    else
        local tarball_url = "https://github.com/ggml-org/llama.cpp/archive/refs/tags/" .. version .. ".tar.gz"
        return {
            version = version,
            url = tarball_url,
            note = "No release assets found. Downloading repository tarball",
            build_from_source = true
        }
    end
end
