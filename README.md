# mise-llamacpp

A [mise](https://mise.jdx.dev) plugin for [llama.cpp](https://github.com/ggml-org/llama.cpp) - a C++ implementation for running LLMs locally.

## Features

- Install prebuilt binaries for Linux, macOS, and Windows
- Support for CPU, CUDA, Vulkan, HIP, SYCL, and OpenCL variants
- Automatic fallback to source builds when binaries aren't available
- Version caching to minimize GitHub API calls
- Legacy version file support (`.llama-version`, `.llama-cpp-version`)

## Installation

```bash
mise plugin install llamacpp https://github.com/zenobi-us/mise-llamacpp.git
```

## Usage

### Install a specific version

```bash
mise install llamacpp@b4479
```

### Install latest version

```bash
mise install llamacpp@latest
```

### Use in project

Add to `.mise.toml`:

```toml
[tools]
llamacpp = "b4479"
```

Or create a `.tool-versions` file:

```
llamacpp b4479
```

### Specify variant

Set the `LLAMACPP_VARIANT` environment variable to install a specific variant:

```bash
LLAMACPP_VARIANT=cuda mise install llamacpp@b4479
```

Available variants:
- `cpu` (default)
- `cuda` (NVIDIA GPU support)
- `vulkan` (Vulkan API support)
- `hip` (AMD GPU support)
- `sycl` (Intel GPU support)
- `opencl` (OpenCL support)

## Tools Included

- `llama-cli` - Command-line interface for text generation
- `llama-server` - HTTP server for inference
- `llama-bench` - Benchmarking tool
- `llama-perplexity` - Perplexity calculation
- `llama-quantize` - Model quantization
- Additional utilities

## Environment Variables

The plugin sets the following environment variables:

- `LLAMACPP_HOME` - Installation directory
- `PATH` - Adds `$LLAMACPP_HOME/bin` to PATH
- `LD_LIBRARY_PATH` (Linux) - Adds `$LLAMACPP_HOME/lib`
- `DYLD_LIBRARY_PATH` (macOS) - Adds `$LLAMACPP_HOME/lib`

## GitHub Token

To avoid GitHub API rate limits, set a token:

```bash
export GITHUB_TOKEN=ghp_your_token_here
# or
export MISE_GITHUB_TOKEN=ghp_your_token_here
```

## Building from Source

If no prebuilt binary is found for your platform/variant combination, the plugin will automatically:

1. Download the source tarball
2. Run CMake configuration
3. Build using `cmake --build .`
4. Install binaries to `$LLAMACPP_HOME/bin`

Requirements for source builds:
- CMake (3.14+)
- C++ compiler (GCC, Clang, MSVC)
- Platform-specific dependencies (CUDA toolkit, Vulkan SDK, etc.)

## Development

### Local Testing

```bash
mise plugin link --force llamacpp .
mise run test
```

### Linting

```bash
mise run lint
```

### Full CI Suite

```bash
mise run ci
```

## Documentation

- [llama.cpp repository](https://github.com/ggml-org/llama.cpp)
- [mise plugin development](https://mise.jdx.dev/tool-plugin-development.html)

## License

MIT
