#!/bin/bash

# This installer works on Ubuntu 22.04 LTS
# As for Ubuntu 24.04 LTS, KCov is no longer available via apt-get. It can be built from sources, though:
#

# strict mode
# https://web.archive.org/web/20250114155712/https://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

sudo apt-get update

# This used to work on Ubuntu 22.04;
# it fails on 24.04, but is available as a GitHub action: https://github.com/marketplace/actions/action-kcov
sudo apt-get install kcov
