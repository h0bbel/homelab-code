#!/bin/bash

# ==============================================================================
# Framework Script
# Description: A template Bash script with markdown output, modular header,
#              placeholder parsing, and user-defined fields
# License: MIT
# Version: 1.0.0
# ==============================================================================

# -- Metadata --
SCRIPT_NAME="framework.sh"
SCRIPT_VERSION="1.0.0"
SCRIPT_AUTHOR="Your Name"
SCRIPT_LICENSE="MIT"

# -- Configuration --
HEADER_DIR="./templates"
HEADER_FILE="header.md"
OUTPUT_FILE="./output.md"
DEBUG=false
declare -a CUSTOM_VARS

# -- Helpers --
print_usage() {
  echo "Usage: $SCRIPT_NAME [-h header_dir] [-o output_file] [-D name=value] [-d] [-v]"
  echo
  echo "Options:"
  echo "  -h <dir>        Specify header directory (default: $HEADER_DIR)"
  echo "  -o <file>       Specify markdown output file (default: $OUTPUT_FILE)"
  echo "  -D name=value   Define a custom placeholder variable (e.g. -D project=MyApp)"
  echo "  -d              Enable debug mode"
  echo "  -v              Show script version"
}

log_debug() {
  [ "$DEBUG" = true ] && echo "[DEBUG] $*" >&2
}

print_version() {
  echo "$SCRIPT_NAME version $SCRIPT_VERSION"
}

# Replace placeholders in a file using built-in and user-defined values
replace_placeholders() {
  local infile="$1"
  local sed_expr=""

  # Built-in substitutions
  sed_expr="${sed_expr};s/{date}/$(date -u +%Y-%m-%dT%H:%M:%SZ)/g"
  sed_expr="${sed_expr};s/{version}/$SCRIPT_VERSION/g"
  sed_expr="${sed_expr};s/{script}/$SCRIPT_NAME/g"
  sed_expr="${sed_expr};s/{author}/$SCRIPT_AUTHOR/g"

  # Custom -D variables
  for entry in "${CUSTOM_VARS[@]}"; do
    key="${entry%%=*}"
    val="${entry#*=}"
    val_escaped=$(printf '%s' "$val" | sed 's/[&/\]/\\&/g')  # Escape sed special chars
    sed_expr="${sed_expr};s/{$key}/$val_escaped/g"
  done

  # Apply sed substitutions (remove leading semicolon)
  sed -e "${sed_expr#;}" "$infile"
}

# -- CLI Argument Parsing --
while getopts "h:o:D:dv" opt; do
  case "$opt" in
    h) HEADER_DIR="$OPTARG" ;;
    o) OUTPUT_FILE="$OPTARG" ;;
    D) CUSTOM_VARS+=("$OPTARG") ;;
    d) DEBUG=true ;;
    v) print_version; exit 0 ;;
    *) print_usage; exit 1 ;;
  esac
done

# -- Markdown Output Initialization --
OUTPUT_DIR="$(dirname "$OUTPUT_FILE")"
mkdir -p "$OUTPUT_DIR"
> "$OUTPUT_FILE"

# -- Include and Process Header --
HEADER_PATH="$HEADER_DIR/$HEADER_FILE"
if [ -f "$HEADER_PATH" ]; then
  log_debug "Parsing header from $HEADER_PATH"
  replace_placeholders "$HEADER_PATH" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
else
  log_debug "No header found at $HEADER_PATH"
fi

# -- Main Content Generation (Example) --
{
  echo "## Generated Content"
  echo
  echo "- Script Name: \`$SCRIPT_NAME\`"
  echo "- Version: \`$SCRIPT_VERSION\`"
  echo "- Timestamp: \`$(date -u)\`"
} >> "$OUTPUT_FILE"

log_debug "Markdown written to $OUTPUT_FILE"
