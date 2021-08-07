#!/bin/bash

set -e

version=`curl --silent "https://api.github.com/repos/ogham/exa/releases/latest" | jq .tag_name | xargs`
revision=`curl --silent "https://api.github.com/repos/ogham/exa/commits/${version}" | jq .sha | xargs`
version=${version#"v"}
echo "latest stable version: ${version}, revision: ${revision}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    -e 's/^(ARG REVISION=).*/\1'"\"${revision}\""'/' \
    "stable/Dockerfile"

git add stable/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated stable to version ${version}, revision: ${revision}"

