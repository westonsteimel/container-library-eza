#!/bin/bash

set -xeuo pipefail

latest_stable_release_tag=$(curl --silent "https://api.github.com/repos/eza-community/eza/releases/latest" | jq -er .tag_name)
revision=$(curl --silent "https://api.github.com/repos/eza-community/eza/commits/${latest_stable_release_tag}" | jq -er .sha)
version=${latest_stable_release_tag#"v"}
echo "latest stable version: ${version}, revision: ${revision}"

sed -ri \
    -e 's/^(ARG EZA_BRANCH=).*/\1'"\"${latest_stable_release_tag}\""'/' \
    -e 's/^(ARG EZA_VERSION=).*/\1'"\"${version}\""'/' \
    -e 's/^(ARG EZA_COMMIT=).*/\1'"\"${revision}\""'/' \
    "stable/Dockerfile"

git add stable/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated stable to version ${version}, revision: ${revision}"

set -e

version="main"
revision=$(curl --silent "https://api.github.com/repos/eza-community/eza/commits/${version}" | jq -er .sha)
echo "latest edge version: ${version}, revision: ${revision}"

sed -ri \
    -e 's/^(ARG EZA_VERSION=).*/\1'"\"${version}\""'/' \
    -e 's/^(ARG EZA_COMMIT=).*/\1'"\"${revision}\""'/' \
    "edge/Dockerfile"

git add edge/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated edge to version ${version}, revision: ${revision}"
