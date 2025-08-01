#!/bin/bash

# MIT License
# Copyright (c) 2025 Christian Mohn
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software...
# [license truncated for brevity, keep full license in real script]

# --- Versioning ---
SCRIPT_VERSION="1.2.2"

# --- Show version and exit if requested ---
if [[ "$1" == "--version" || "$1" == "-v" ]]; then
  echo "Portainer Inventory Script Version: v$SCRIPT_VERSION"
  exit 0
fi

echo "Portainer Inventory Script v$SCRIPT_VERSION"

# --- Load environment variables ---
if [[ -f .env ]]; then
  echo "Loading environment variables from .env"
  source .env
else
  echo "Error: .env file not found. Please create one with the following variables:"
  echo "PORTAINER_URL, USERNAME, PASSWORD, USE_INSECURE_SSL"
  exit 1
fi

# --- Configuration ---
OUTPUT_FILE="portainer-inventory.md"
CURRENT_DATE=$(date '+%d/%m/%Y')
CURL_OPTS="-s"
[[ "$USE_INSECURE_SSL" == "true" ]] && CURL_OPTS="$CURL_OPTS -k"

# --- Authenticate ---
echo "Authenticating with Portainer..."
AUTH_RESPONSE=$(curl $CURL_OPTS -X POST "$PORTAINER_URL/auth" \
  -H "Content-Type: application/json" \
  -d "{\"Username\":\"$USERNAME\",\"Password\":\"$PASSWORD\"}")

TOKEN=$(echo "$AUTH_RESPONSE" | jq -r .jwt)
if [[ "$TOKEN" == "null" || -z "$TOKEN" ]]; then
  echo "Authentication failed:"
  echo "$AUTH_RESPONSE"
  exit 1
fi
echo "Authenticated successfully."

# --- Fetch endpoints and stacks ---
echo "Fetching all endpoints..."
ENDPOINTS=$(curl $CURL_OPTS -H "Authorization: Bearer $TOKEN" "$PORTAINER_URL/endpoints")

echo "Fetching all stacks..."
STACKS=$(curl $CURL_OPTS -H "Authorization: Bearer $TOKEN" "$PORTAINER_URL/stacks")

# --- Start output file ---
> "$OUTPUT_FILE"
HEADER_FILE="templates/header.md"
if [[ -f "$HEADER_FILE" ]]; then
  echo "Found header template: $HEADER_FILE"
  cat "$HEADER_FILE" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
else
  echo "No custom header file found."
fi

echo "# Portainer Inventory Report" >> "$OUTPUT_FILE"
echo "Generated on ${CURRENT_DATE}" >> "$OUTPUT_FILE"
echo "Script version: v${SCRIPT_VERSION}" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# --- Function to calculate uptime ---
format_uptime() {
  local started_at="$1"
  if [[ -z "$started_at" ]]; then
    echo "(unknown)"
    return
  fi
  local start_epoch now_epoch diff
  start_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${started_at:0:19}" +"%s" 2>/dev/null || date -d "${started_at}" +"%s")
  now_epoch=$(date +%s)
  diff=$((now_epoch - start_epoch))

  if (( diff < 60 )); then
    echo "${diff}s"
  elif (( diff < 3600 )); then
    echo "$((diff / 60))m"
  elif (( diff < 86400 )); then
    echo "$((diff / 3600))h $(( (diff % 3600) / 60 ))m"
  else
    echo "$((diff / 86400))d $(( (diff % 86400) / 3600 ))h"
  fi
}

# --- Process environments ---
echo "$ENDPOINTS" | jq -c '.[]' | while read -r endpoint; do
  ENDPOINT_ID=$(echo "$endpoint" | jq -r .Id)
  ENDPOINT_NAME=$(echo "$endpoint" | jq -r .Name)

  echo "Processing environment: $ENDPOINT_NAME (ID: $ENDPOINT_ID)"
  echo "## Environment: $ENDPOINT_NAME (ID: $ENDPOINT_ID)" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"

  CONTAINERS=$(curl $CURL_OPTS -H "Authorization: Bearer $TOKEN" \
    "$PORTAINER_URL/endpoints/$ENDPOINT_ID/docker/containers/json?all=true")

  STACKS_FOR_ENDPOINT=$(echo "$STACKS" | jq -c --argjson eid "$ENDPOINT_ID" '.[] | select(.EndpointID == $eid)')
  STACK_IDS=$(echo "$STACKS_FOR_ENDPOINT" | jq -r '.Id')

  if [[ -z "$STACK_IDS" ]]; then
    echo "_No stacks found for this environment._" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  fi

  for STACK_ID in $STACK_IDS; do
    STACK_JSON=$(echo "$STACKS_FOR_ENDPOINT" | jq -c "select(.Id == $STACK_ID)")
    STACK_NAME=$(echo "$STACK_JSON" | jq -r .Name)
    STACK_TYPE=$(echo "$STACK_JSON" | jq -r .Type)
    STACK_STATUS=$(echo "$STACK_JSON" | jq -r .Status)

    echo "### Stack: $STACK_NAME" >> "$OUTPUT_FILE"
    echo "- **ID:** $STACK_ID" >> "$OUTPUT_FILE"
    echo "- **Type:** $STACK_TYPE" >> "$OUTPUT_FILE"
    echo "- **Status:** $STACK_STATUS" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    for STATE in "running" "stopped"; do
      [[ "$STATE" == "running" ]] && LABEL="Running Containers" || LABEL="Stopped Containers"

      CONTAINERS_MATCHING=$(echo "$CONTAINERS" | jq -c --arg state "$STATE" --arg stack "$STACK_NAME" '
        .[] | select(.Labels["com.docker.stack.namespace"] == $stack) |
        select((.State == $state) or ($state == "stopped" and .State != "running"))')

      if [[ -z "$CONTAINERS_MATCHING" ]]; then
        continue
      fi

      echo "#### $LABEL" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      echo "| Name | Image | Status | Uptime | Ports | Environment | ID | Volumes | Networks |" >> "$OUTPUT_FILE"
      echo "|------|-------|--------|--------|-------|-------------|----|---------|----------|" >> "$OUTPUT_FILE"

      echo "$CONTAINERS_MATCHING" | jq -c '.' | while read -r container; do
        CONTAINER_ID=$(echo "$container" | jq -r .Id)
        NAME=$(echo "$container" | jq -r '.Names[0]' | sed 's|/||')
        IMAGE=$(echo "$container" | jq -r .Image)
        STATUS=$(echo "$container" | jq -r .State)
        ID_SHORT=$(echo "$CONTAINER_ID" | cut -c1-12)
        PORTS=$(echo "$container" | jq -r '[.Ports[]? | "\(.PublicPort):\(.PrivatePort)/\(.Type)"] | join(", ")')
        [[ -z "$PORTS" || "$PORTS" == "-" ]] && PORTS="(none)"

        DETAIL=$(curl $CURL_OPTS -H "Authorization: Bearer $TOKEN" \
          "$PORTAINER_URL/endpoints/$ENDPOINT_ID/docker/containers/$CONTAINER_ID/json")

        STARTED_AT=$(echo "$DETAIL" | jq -r '.State.StartedAt')
        UPTIME=$(format_uptime "$STARTED_AT")

        VOLUMES=$(echo "$DETAIL" | jq -r '[.Mounts[]? | .Destination] | join(", ")')
        [[ -z "$VOLUMES" ]] && VOLUMES="(none)"
        NETWORKS=$(echo "$DETAIL" | jq -r '.NetworkSettings.Networks | keys | join(", ")')
        [[ -z "$NETWORKS" ]] && NETWORKS="(none)"

        echo "| $NAME | $IMAGE | $STATUS | $UPTIME | $PORTS | $ENDPOINT_NAME | $ID_SHORT | $VOLUMES | $NETWORKS |" >> "$OUTPUT_FILE"
      done

      echo "" >> "$OUTPUT_FILE"
    done
  done

  echo "## Orphan Containers (Not in Any Stack)" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"

  for STATE in "running" "stopped"; do
    [[ "$STATE" == "running" ]] && LABEL="Running Containers" || LABEL="Stopped Containers"

    CONTAINERS_MATCHING=$(echo "$CONTAINERS" | jq -c --arg state "$STATE" '
      .[] | select(.Labels["com.docker.stack.namespace"] == null) |
      select((.State == $state) or ($state == "stopped" and .State != "running"))')

    if [[ -z "$CONTAINERS_MATCHING" ]]; then
      continue
    fi

    echo "### $LABEL" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "| Name | Image | Status | Uptime | Ports | Environment | ID | Volumes | Networks |" >> "$OUTPUT_FILE"
    echo "|------|-------|--------|--------|-------|-------------|----|---------|----------|" >> "$OUTPUT_FILE"

    echo "$CONTAINERS_MATCHING" | jq -c '.' | while read -r container; do
      CONTAINER_ID=$(echo "$container" | jq -r .Id)
      NAME=$(echo "$container" | jq -r '.Names[0]' | sed 's|/||')
      IMAGE=$(echo "$container" | jq -r .Image)
      STATUS=$(echo "$container" | jq -r .State)
      ID_SHORT=$(echo "$CONTAINER_ID" | cut -c1-12)
      PORTS=$(echo "$container" | jq -r '[.Ports[]? | "\(.PublicPort):\(.PrivatePort)/\(.Type)"] | join(", ")')
      [[ -z "$PORTS" || "$PORTS" == "-" ]] && PORTS="(none)"

      DETAIL=$(curl $CURL_OPTS -H "Authorization: Bearer $TOKEN" \
        "$PORTAINER_URL/endpoints/$ENDPOINT_ID/docker/containers/$CONTAINER_ID/json")

      STARTED_AT=$(echo "$DETAIL" | jq -r '.State.StartedAt')
      UPTIME=$(format_uptime "$STARTED_AT")

      VOLUMES=$(echo "$DETAIL" | jq -r '[.Mounts[]? | .Destination] | join(", ")')
      [[ -z "$VOLUMES" ]] && VOLUMES="(none)"
      NETWORKS=$(echo "$DETAIL" | jq -r '.NetworkSettings.Networks | keys | join(", ")')
      [[ -z "$NETWORKS" ]] && NETWORKS="(none)"

      echo "| $NAME | $IMAGE | $STATUS | $UPTIME | $PORTS | $ENDPOINT_NAME | $ID_SHORT | $VOLUMES | $NETWORKS |" >> "$OUTPUT_FILE"
    done

    echo "" >> "$OUTPUT_FILE"
  done

  echo "---" >> "$OUTPUT_FILE"
done

echo "✅ Inventory saved to $OUTPUT_FILE"
