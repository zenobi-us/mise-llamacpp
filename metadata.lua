-- metadata.lua
-- Plugin metadata and configuration
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#metadata-lua

PLUGIN = { -- luacheck: ignore
    -- Required: Tool name (lowercase, no spaces)
    name = "llamacpp",

    -- Required: Plugin version (not the tool version)
    version = "1.0.0",

    -- Required: Brief description of the tool
    description = "Manage versions of ggml-org/llama.cpp (prebuilt assets + source build fallback)",

    -- Required: Plugin author/maintainer
    author = "zenobi-us",

    -- Optional: Repository URL for plugin updates
    updateUrl = "https://github.com/zenobi-us/mise-llamacpp",

    -- Optional: Minimum mise runtime version required
    minRuntimeVersion = "0.2.0",

    -- Optional: Legacy version files this plugin can parse
    legacyFilenames = {
        ".llama-version",
        ".llama-cpp-version",
    }
}
