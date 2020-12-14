#!/bin/bash
set -e

ROOT="$(pwd)"

TEMP_GIT_DIR="$(mktemp -d)"
TEMP_TAR_DIR="$(pwd)"/artifacts

git clone --depth 1 --single-branch --branch ${WIKIBASE_BRANCH_NAME} "$ROOT/git_cache/Wikibase.git" "$TEMP_GIT_DIR/Wikibase"
git -C "$TEMP_GIT_DIR/Wikibase" submodule update

# remove git things from release package
rm "$TEMP_GIT_DIR/Wikibase/".git* -rfv

GZIP=-9 tar -C "$TEMP_GIT_DIR" -zcf "$TEMP_TAR_DIR"/Wikibase.tar.gz Wikibase

TARBALL_PATH="$TEMP_TAR_DIR/Wikibase.tar.gz"

if [ -n "$GITHUB_ENV" ]; then
    echo "TARBALL_PATH="$TARBALL_PATH"" >> $GITHUB_ENV
else
    export TARBALL_PATH
fi