#!/bin/bash

# --- Versioning ---
SCRIPT_VERSION="1.0.0"

# --- Load .env ---
if [[ -f .env ]]; then
  source .env
else
  echo "Missing .env file with PORTAINER_URL, USERNAME, and PASSWORD"
  exit 1
fi

# --- Show version and exit if requested ---
if [[ "$1" == "--version" || "$1" == "-v" ]]; then
  echo "Portainer Inventory Script Version: v$SCRIPT_VERSION"
  exit 0
fi

echo "Portainer Inventory Script v$SCRIPT_VERSION"

# --- Output settings ---
OUTPUT_FILE="portainer-inventory.md"
CURRENT_DATE=$(date '+%d/%m/%Y')

# --- Authenticate ---
echo "Authenticating with Portainer..."

AUTH_RESPONSE=$(curl -s -X POST "$PORTAINER_URL/auth" \
  -H "Content-Type: application/json" \
  -d "{\"Username\":\"$USERNAME\",\"Password\":\"$PASSWORD\"}")

TOKEN=$(echo "$AUTH_RESPONSE" | jq -r .jwt)

if [[ "$TOKEN" == "null" || -z "$TOKEN" ]]; then
  echo "Authentication failed:"
  echo "$AUTH_RESPONSE"
  exit 1
fi

echo "Authenticated."

# --- Get endpoints ---
echo "Fetching all endpoints..."

ENDPOINTS=$(curl -s -X GET "$PORTAINER_URL/endpoints" \
  -H "Authorization: Bearer $TOKEN")

# --- Get stacks ---
echo "Fetching all stacks..."

STACKS=$(curl -s -X GET "$PORTAINER_URL/stacks" \
  -H "Authorization: Bearer $TOKEN")

# --- Begin output ---
echo "# Portainer Inventory Report" > "$OUTPUT_FILE"
echo "Generated on ${CURRENT_DATE}" >> "$OUTPUT_FILE"
echo "Script version: v${SCRIPT_VERSION}" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# --- Iterate over endpoints ---
echo "$ENDPOINTS" | jq -c '.[]' | while read -r endpoint; do
  ENDPOINT_ID=$(echo "$endpoint" | jq -r .Id)
  ENDPOINT_NAME=$(echo "$endpoint" | jq -r .Name)

  echo "## Environment: $ENDPOINT_NAME (ID: $ENDPOINT_ID)" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"

  # Get containers for this endpoint
  CONTAINERS=$(curl -s -X GET \
    "$PORTAINER_URL/endpoints/$ENDPOINT_ID/docker/containers/json?all=true" \
    -H "Authorization: Bearer $TOKEN")

  # Get stacks for this endpoint
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
      if [[ "$STATE" == "running" ]]; then
        STATE_LABEL="Running"
      else
        STATE_LABEL="Stopped"
      fi

      CONTAINERS_MATCHING=$(echo "$CONTAINERS" | jq -c --arg state "$STATE" --arg stack "$STACK_NAME" '
        .[] |
        select(.Labels["com.docker.stack.namespace"] == $stack) |
        select((.State == $state) or ($state == "stopped" and .State != "running"))')

      if [[ -z "$CONTAINERS_MATCHING" ]]; then
        continue
      fi

      echo "#### $STATE_LABEL Containers" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      echo "| Name | Image | Status | Ports | Environment | ID |" >> "$OUTPUT_FILE"
      echo "|------|-------|--------|-------|-------------|----|" >> "$OUTPUT_FILE"

      echo "$CONTAINERS_MATCHING" | jq -c '.' | while read -r container; do
        NAME=$(echo "$container" | jq -r '.Names[0]' | sed 's|/||')
        IMAGE=$(echo "$container" | jq -r .Image)
        STATUS=$(echo "$container" | jq -r .State)
        ID=$(echo "$container" | jq -r .Id | cut -c1-12)
        PORTS=$(echo "$container" | jq -r '[.Ports[]? | "\(.PublicPort):\(.PrivatePort)/\(.Type)"] | join(", ")')
        [[ -z "$PORTS" || "$PORTS" == "-" ]] && PORTS="(none)"

        echo "| $NAME | $IMAGE | $STATUS | $PORTS | $ENDPOINT_NAME | $ID |" >> "$OUTPUT_FILE"
      done

      echo "" >> "$OUTPUT_FILE"
    done
  done

  # Orphan containers
  echo "## Orphan Containers (Not in Any Stack)" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"

  for STATE in "running" "stopped"; do
    if [[ "$STATE" == "running" ]]; then
      STATE_LABEL="Running"
    else
      STATE_LABEL="Stopped"
    fi

    CONTAINERS_MATCHING=$(echo "$CONTAINERS" | jq -c --arg state "$STATE" '
      .[] |
      select(.Labels["com.docker.stack.namespace"] == null) |
      select((.State == $state) or ($state == "stopped" and .State != "running"))')

    if [[ -z "$CONTAINERS_MATCHING" ]]; then
      continue
    fi

    echo "### $STATE_LABEL Containers" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "| Name | Image | Status | Ports | Environment | ID |" >> "$OUTPUT_FILE"
    echo "|------|-------|--------|-------|-------------|----|" >> "$OUTPUT_FILE"

    echo "$CONTAINERS_MATCHING" | jq -c '.' | while read -r container; do
      NAME=$(echo "$container" | jq -r '.Names[0]' | sed 's|/||')
      IMAGE=$(echo "$container" | jq -r .Image)
      STATUS=$(echo "$container" | jq -r .State)
      ID=$(echo "$container" | jq -r .Id | cut -c1-12)
      PORTS=$(echo "$container" | jq -r '[.Ports[]? | "\(.PublicPort):\(.PrivatePort)/\(.Type)"] | join(", ")')
      [[ -z "$PORTS" || "$PORTS" == "-" ]] && PORTS="(none)"

      echo "| $NAME | $IMAGE | $STATUS | $PORTS | $ENDPOINT_NAME | $ID |" >> "$OUTPUT_FILE"
    done

    echo "" >> "$OUTPUT_FILE"
  done

  echo "---" >> "$OUTPUT_FILE"
done

echo "✅ Markdown documentation saved to $OUTPUT_FILE"
