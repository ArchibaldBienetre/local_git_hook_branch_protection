#!/bin/bash

# strict mode
# https://web.archive.org/web/20250114155712/https://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

sudo apt-get update

# This used to work on Ubuntu 22.04;
# it fails on 24.04, but is available as a GitHub action.
sudo apt-get install kcov
