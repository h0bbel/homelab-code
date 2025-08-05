#!/bin/bash
# Portainer Unused Images Script v1.2.2
# Copyright (c) 2025 Christian Mohn
# Licensed under the MIT License (https://opensource.org/licenses/MIT)

set -euo pipefail

SCRIPT_NAME=$(basename "$0")
SCRIPT_VERSION="1.2.2"
ENV_FILE=".env"
OUTPUT_FILE="portainer-unused-images.md"
HEADER_TEMPLATE="templates/header.md"

DELETE_UNUSED=false

usage() {
  echo "Usage: $SCRIPT_NAME [--delete-unused]"
  echo "  --delete-unused    Delete all unused images after reporting them (asks for confirmation)"
  exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --delete-unused) DELETE_UNUSED=true; shift ;;
    *) usage ;;
  esac
done

echo "$SCRIPT_NAME v$SCRIPT_VERSION"
echo "Loading environment variables from $ENV_FILE"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Environment file $ENV_FILE not found."
  exit 1
fi

# shellcheck disable=SC1091
source "$ENV_FILE"

: "${PORTAINER_URL:?Need to set PORTAINER_URL in $ENV_FILE}"
: "${USERNAME:?Need to set USERNAME in $ENV_FILE}"
: "${PASSWORD:?Need to set PASSWORD in $ENV_FILE}"

CUSTOM_HEADER=""
if [[ -f "$HEADER_TEMPLATE" ]]; then
  echo "Loading custom header file $HEADER_TEMPLATE"
  CUSTOM_HEADER=$(cat "$HEADER_TEMPLATE")
else
  echo "No custom header file found."
fi

echo "Authenticating with Portainer..."

auth_response=$(curl -sS -X POST \
  -H "Content-Type: application/json" \
  -d "{\"Username\":\"$USERNAME\",\"Password\":\"$PASSWORD\"}" \
  "$PORTAINER_URL/api/auth")

jwt=$(echo "$auth_response" | jq -r '.jwt // empty')

if [[ -z "$jwt" ]]; then
  echo "Authentication failed. Response was invalid JSON or missing JWT token:"
  echo "$auth_response"
  exit 1
fi

echo "Authenticated successfully."

echo "Fetching endpoints..."

endpoints_response=$(curl -sS -H "Authorization: Bearer $jwt" "$PORTAINER_URL/api/endpoints")

endpoint_ids=($(echo "$endpoints_response" | jq -r '.[].Id'))
endpoint_names=($(echo "$endpoints_response" | jq -r '.[].Name'))

if [[ ${#endpoint_ids[@]} -eq 0 ]]; then
  echo "No endpoints found in Portainer."
  exit 1
fi

{
  echo "# Portainer Unused Images Report"
  echo
  echo "Report generated on $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
  echo
  if [[ -n "$CUSTOM_HEADER" ]]; then
    echo "$CUSTOM_HEADER"
    echo
  fi

  for i in "${!endpoint_ids[@]}"; do
    endpoint_id="${endpoint_ids[i]}"
    endpoint_name="${endpoint_names[i]}"

    echo "Processing environment: $endpoint_name (ID: $endpoint_id)"

    images_json=$(curl -sS -H "Authorization: Bearer $jwt" "$PORTAINER_URL/api/endpoints/$endpoint_id/docker/images/json")
    containers_json=$(curl -sS -H "Authorization: Bearer $jwt" "$PORTAINER_URL/api/endpoints/$endpoint_id/docker/containers/json?all=1")

    used_image_ids=$(echo "$containers_json" | jq -r '.[].ImageID' | sort | uniq)

    unused_images=$(echo "$images_json" | jq --argjson used "$(echo "$used_image_ids" | jq -R -s -c 'split("\n")[:-1]')" '
      map(
        select(
          (.RepoTags != null) and
          (.RepoTags | index("<none>:<none>") | not) and
          (.Id as $id | ($used | index($id) | not))
        )
      )
    ')

    unused_count=$(echo "$unused_images" | jq 'length')

    if (( unused_count == 0 )); then
      echo "No unused images found for environment $endpoint_name."
      echo
      continue
    fi

    echo "## Environment: $endpoint_name"
    echo
    echo "| Image ID | Repository:Tag | Created | Size |"
    echo "|----------|----------------|---------|------|"

    echo "$unused_images" | jq -r '
      .[] | [
        (.Id | sub("^sha256:"; "") | .[0:12]),
        (.RepoTags | join(", ")),
        (.Created | tonumber | strftime("%Y-%m-%d %H:%M:%S UTC")),
        (.Size / 1024 / 1024 | floor | tostring + " MB")
      ] | "| " + join(" | ") + " |"
    '

    echo

    if $DELETE_UNUSED; then
      echo "Deleting unused images for environment $endpoint_name..."

      image_ids_to_delete=($(echo "$unused_images" | jq -r '.[].Id'))
      for image_id in "${image_ids_to_delete[@]}"; do
        clean_id="${image_id#sha256:}"
        echo "Deleting image $clean_id..."
        delete_response=$(curl -sS -X DELETE -H "Authorization: Bearer $jwt" \
          "$PORTAINER_URL/api/endpoints/$endpoint_id/docker/images/$clean_id")
        echo "$delete_response"
      done

      echo "Deletion completed for environment $endpoint_name."
      echo
    fi
  done
} > "$OUTPUT_FILE"

echo "Unused image report saved to $OUTPUT_FILE"

if $DELETE_UNUSED; then
  echo "All unused images have been deleted."
fi
