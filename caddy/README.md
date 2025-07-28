# Caddyfile Documentation Generator v1.0.8

Generate Markdown documentation from a Caddyfile configuration. This script parses your Caddyfile, extracts global options and site blocks, and outputs a well-formatted Markdown file documenting your setup.

## Features

- Parses global options block (excluding commented lines)
- Extracts sites and their reverse proxy targets
- Outputs a Markdown table linking site domains
- Supports an optional Markdown header file to prepend to output
- Configurable input and output file paths
- Debug mode for detailed logging
- MIT licensed

## Usage

```bash
./caddy-documentation.sh [CADDYFILE] [OUTPUT_FILE] [HEADER_FILE]
```

### Arguments

CADDYFILE (optional): Path to your Caddyfile (default: ./Caddyfile)
OUTPUT_FILE (optional): Markdown output filename (default: caddy-documentation.md)
HEADER_FILE (optional): Markdown file to prepend as a header (default: templates/header.md if exists)


### Options

```bash
--help
```

### Examples

```bash
./caddy-documentation.sh
```

Specify custom input and output files:

```bash
./caddy-documentation.sh /path/to/Caddyfile docs.md
```

Include a custom header file:

```bash
./caddy-documentation.sh ./Caddyfile docs.md templates/custom_header.md
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.