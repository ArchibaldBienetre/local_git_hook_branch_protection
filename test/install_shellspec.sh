#!/bin/bash

# strict mode
# https://web.archive.org/web/20250114155712/https://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

curl -fsSL https://git.io/shellspec > /tmp/shellspec_installer.sh
chmod +x /tmp/shellspec_installer.sh

# install options: https://github.com/shellspec/shellspec/blob/master/install.sh#L30
# Installing master: My bugfix from 2021 has not been released yet
/tmp/shellspec_installer.sh master -y
