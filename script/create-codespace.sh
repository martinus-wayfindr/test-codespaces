#!/usr/bin/env bash

set -euo pipefail

REPO="$1"
BRANCH="$2"
TOKEN="$3"
MACHINE="${4:-standardLinux32gb}"

echo "Creating codespace for:"
echo "Repo: $REPO"
echo "Branch: $BRANCH"
echo "Machine: $MACHINE"

API_URL="https://api.github.com/repos/${REPO}/codespaces"

response=$(curl -sS -w "%{http_code}" -o response.json -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "${API_URL}" \
  -d "{
    \"ref\": \"${BRANCH}\",
    \"machine\": \"${MACHINE}\"
  }")

echo "HTTP Status: $response"
cat response.json

if [ "$response" -ge 400 ]; then
  echo "Codespace creation failed"
  exit 1
fi

echo "Codespace created successfully"
