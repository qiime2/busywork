#!/bin/bash

set -e -v

# Architectures are seperate directories, so repodata.json conflicts aren't a
# problem.
cp -r build-darwin/* builds
cp -r build-linux/* builds
