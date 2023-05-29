#!/bin/bash

set -xeuo pipefail

latest_stable_release_tag=$(curl --silent "https://api.github.com/repos/ogham/exa/releases/latest" | jq -er .tag_name)
revision=$(curl --silent "https://api.github.com/repos/ogham/exa/commits/${latest_stable_release_tag}" | jq -er .sha)
version=${latest_stable_release_tag#"v"}
echo "latest stable version: ${version}, revision: ${revision}"

sed -ri \
    -e 's/^(ARG EXA_BRANCH=).*/\1'"\"${latest_stable_release_tag}\""'/' \
    -e 's/^(ARG EXA_VERSION=).*/\1'"\"${version}\""'/' \
    -e 's/^(ARG EXA_COMMIT=).*/\1'"\"${revision}\""'/' \
    "stable/Dockerfile"

git add stable/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated stable to version ${version}, revision: ${revision}"

set -e

version="master"
revision=$(curl --silent "https://api.github.com/repos/ogham/exa/commits/${version}" | jq -er .sha)
echo "latest edge version: ${version}, revision: ${revision}"

sed -ri \
    -e 's/^(ARG EXA_VERSION=).*/\1'"\"${version}\""'/' \
    -e 's/^(ARG EXA_COMMIT=).*/\1'"\"${revision}\""'/' \
    "edge/Dockerfile"

git add edge/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated edge to version ${version}, revision: ${revision}"
