#!/bin/sh
# Copyright (c) Meta Platforms, Inc. and affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

RESET='\033[0m'
YELLOW='\033[1;33m'

REOPEN_XCODE=false

pgrep -f '/Applications/Xcode.*\.app/Contents/MacOS/Xcode' > /dev/null
# shellcheck disable=SC2181
if [ $? -eq 0 ]; then
    echo "⚠️  ${YELLOW}Closing Xcode!${RESET}"
    killall Xcode || true
    REOPEN_XCODE=true
fi

CWD=$(pwd)
XCODEGEN_BINARY="${CWD}/../tools/xcode/bin/xcodegen"

generateProject () {
    xcodegen generate
}

generateProject

if [ "$REOPEN_XCODE" = true ]; then
    echo "${YELLOW}Reopening HackerBook.xcodeproj${RESET}"
    open HackerBook.xcodeproj
fi
