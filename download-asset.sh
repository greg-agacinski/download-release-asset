#!/bin/bash

set -e
set -o pipefail

# Ensure that the GITHUB_TOKEN secret is included
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

if [[ -z "$OUTPUT_FILE" ]]; then
    OUTPUT_FILE=$FILE
fi

AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

function gh_curl() {
  curl -H "${AUTH_HEADER}" \
       -H "Accept: application/vnd.github.v3.raw" \
       $@
}

if [ "$VERSION" = "latest" ]; then
  # Github should return the latest release first.
  parser=".[0].assets | map(select(.name == \"$FILE\"))[0].id"
else
  parser=". | map(select(.tag_name == \"$VERSION\"))[0].assets | map(select(.name == \"$FILE\"))[0].id"
fi;

asset_id=`gh_curl -s https://api.github.com/repos/$REPO/releases | jq "$parser"`
if [ "$asset_id" = "null" ]; then
  echo "ERROR: version not found $VERSION"
  exit 1
fi;

ASSET_URL="https://api.github.com/repos/${REPO}/releases/assets/${asset_id}"

curl \
  -L \
  -H "${AUTH_HEADER}" \
  -H "Accept:application/octet-stream" \
  -o "${OUTPUT_FILE}" \
  "${ASSET_URL}"
