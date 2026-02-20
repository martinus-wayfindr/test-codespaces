#!/usr/bin/env bash

set -euo pipefail

REPO="$1"
BRANCH="$2"
TOKEN="$3"
MACHINE="${4:-standardLinux32gb}"

if [ -z "$TOKEN" ]; then
  echo "ERROR: TOKEN is empty"
  exit 1
fi

echo "========================================"
echo "Creating codespace"
echo "Repository : $REPO"
echo "Branch     : $BRANCH"
echo "Machine    : $MACHINE"
echo "========================================"

API_URL="https://api.github.com/repos/${REPO}/codespaces"

HTTP_STATUS=$(curl -sS -o response.json -w "%{http_code}" \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "$API_URL" \
  -d @- <<EOF
{
  "ref": "${BRANCH}",
  "machine": "${MACHINE}"
}
EOF
)

echo "HTTP Status: $HTTP_STATUS"
echo "Response:"
cat response.json
echo ""

if [ "$HTTP_STATUS" -ge 400 ]; then
  echo "❌ Codespace creation failed"
  exit 1
fi

echo "✅ Codespace created successfully"
