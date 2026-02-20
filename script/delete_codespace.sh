#!/usr/bin/env bash

set -euo pipefail

REPO="$1"
BRANCH="$2"
TOKEN="$3"

echo "========================================"
echo "Deleting codespace for:"
echo "Repo   : $REPO"
echo "Branch : $BRANCH"
echo "========================================"

# List codespaces for this repo
CODESPACES=$(curl -s \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/${REPO}/codespaces")

# Extract codespace names matching branch
MATCHING=$(echo "$CODESPACES" | jq -r \
  --arg BRANCH "$BRANCH" \
  '.codespaces[] | select(.git_status.ref == $BRANCH) | .name')

if [ -z "$MATCHING" ]; then
  echo "No codespaces found for branch $BRANCH"
  exit 0
fi

for NAME in $MATCHING; do
  echo "Deleting codespace: $NAME"

  curl -s -X DELETE \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/user/codespaces/${NAME}"

  echo "Deleted $NAME"
done

echo "Cleanup complete"
