#!/bin/bash
#
# MIT License
#
# Copyright (c) 2025 Christian Mohn
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

set -euo pipefail

SCRIPT_VERSION="1.0.8"
DEBUG=${DEBUG:-false}

usage() {
  cat <<EOF
Usage: $0 [CADDYFILE] [OUTPUT_FILE] [HEADER_FILE]

Generate markdown documentation from a Caddyfile.

Arguments:
  CADDYFILE     Path to Caddyfile to parse (default: ./Caddyfile)
  OUTPUT_FILE   Markdown output file (default: caddy-documentation.md)
  HEADER_FILE   Optional header markdown file (default: templates/header.md if exists)

Options:
  --help        Show this help message and exit

Environment:
  DEBUG=true    Enable debug output

Example:
  $0 ./Caddyfile docs.md templates/header.md
EOF
}

if [[ "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

CADDYFILE_PATH="${1:-./Caddyfile}"
OUTPUT_FILE="${2:-caddy-documentation.md}"
HEADER_FILE_DEFAULT="templates/header.md"
HEADER_FILE="${3:-$HEADER_FILE_DEFAULT}"

debug() {
  if [[ "$DEBUG" == "true" ]]; then
    echo "DEBUG: $*"
  fi
}

global_options=""
site_domains=()
site_proxies=()

parse_caddyfile() {
  debug "Reading Caddyfile from '$CADDYFILE_PATH'"

  local inside_global=0
  local inside_site=0
  local current_domain=""
  local current_proxy=""

  while IFS= read -r line || [[ -n $line ]]; do
    debug "Line read: '$line'"

    # Trim leading/trailing whitespace
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"

    # Skip empty lines
    if [[ -z "$line" ]]; then
      continue
    fi

    # Global block start
    if [[ $line == "{" && $inside_global -eq 0 && $inside_site -eq 0 ]]; then
      debug "Global block start detected"
      inside_global=1
      continue
    fi

    # Global block end
    if [[ $line == "}" && $inside_global -eq 1 ]]; then
      debug "Global block end detected"
      inside_global=0
      continue
    fi

    # If inside global block, collect options (skip commented lines)
    if [[ $inside_global -eq 1 ]]; then
      if [[ ! $line =~ ^# ]]; then
        global_options+="$line
"
      else
        debug "Skipping commented line in global block: '$line'"
      fi
      continue
    fi

    # Site block start? Must be like http://domain or https://domain with '{'
    if [[ $line =~ ^(https?://[^[:space:]]+)[[:space:]]*\{$ ]]; then
      current_domain="${BASH_REMATCH[1]}"
      debug "Site detected: '$current_domain'"
      inside_site=1
      current_proxy=""
      continue
    fi

    # Site block end
    if [[ $line == "}" && $inside_site -eq 1 ]]; then
      debug "Site block end detected for domain '$current_domain'"
      site_domains+=("$current_domain")
      site_proxies+=("$current_proxy")
      inside_site=0
      current_domain=""
      current_proxy=""
      continue
    fi

    # Inside site block, look for reverse_proxy directive
    if [[ $inside_site -eq 1 ]]; then
      if [[ $line =~ ^reverse_proxy[[:space:]]+(.+)$ ]]; then
        current_proxy="${BASH_REMATCH[1]}"
        debug "Found reverse_proxy target: '$current_proxy'"
      fi
      continue
    fi

  done < "$CADDYFILE_PATH"
}

generate_markdown() {
  debug "Generating markdown output to '$OUTPUT_FILE'"

  {
    # Include header file if it exists
    if [[ -f "$HEADER_FILE" ]]; then
      debug "Including header file '$HEADER_FILE'"
      cat "$HEADER_FILE"
      echo
    else
      debug "Header file '$HEADER_FILE' not found or not specified, skipping"
    fi

    echo "# Caddyfile Documentation"
    echo
    echo "**Script version:** $SCRIPT_VERSION"
    echo

    echo "## Global Options"
    echo
    if [[ -n "$global_options" ]]; then
      echo '```'
      echo "$global_options"
      echo '```'
      echo
    else
      echo "_No global options defined._"
      echo
    fi

    echo "## Sites"
    echo
    echo "| Domain | Reverse Proxy Target |"
    echo "| ------ | -------------------- |"

    local i
    for i in "${!site_domains[@]}"; do
      local domain="${site_domains[$i]}"
      local proxy="${site_proxies[$i]}"

      # Remove scheme from domain for display
      local display_domain="${domain#http://}"
      display_domain="${display_domain#https://}"

      # Create markdown link with original scheme preserved
      local domain_md="[$display_domain]($domain)"

      if [[ -n $proxy ]]; then
        echo "| $domain_md | $proxy |"
      else
        echo "| $domain_md | - |"
      fi
    done

  } > "$OUTPUT_FILE"

  echo "Markdown documentation generated at '$OUTPUT_FILE'"
}

main() {
  debug "Starting script version $SCRIPT_VERSION"

  if [[ ! -f "$CADDYFILE_PATH" ]]; then
    echo "ERROR: Caddyfile not found at '$CADDYFILE_PATH'"
    exit 1
  fi

  parse_caddyfile

  debug "Global options parsed:"
  debug "$global_options"
  debug "Sites parsed:"
  debug "Domains: ${site_domains[*]}"
  debug "Proxies: ${site_proxies[*]}"

  generate_markdown
}

main "$@"
