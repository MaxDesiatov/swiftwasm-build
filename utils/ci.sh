#/bin/bash

set -ex

if [ ! -e swift ]; then
  git clone https://github.com/apple/swift.git
fi

SOURCE_PATH=$PWD
UTILS_PATH=$SOURCE_PATH/utils
if [[ "$(uname)" == "Linux" ]]; then
  DEPENDENCIES_SCRIPT=$UTILS_PATH/linux/install-dependencies.sh
else
  DEPENDENCIES_SCRIPT=$UTILS_PATH/macos/install-dependencies.sh
fi

BUILD_SCRIPT=$UTILS_PATH/build-toolchain.sh

$DEPENDENCIES_SCRIPT

export SCCACHE_CACHE_SIZE="50G"
export SCCACHE_DIR="$SOURCE_PATH/build-cache"

$BUILD_SCRIPT
