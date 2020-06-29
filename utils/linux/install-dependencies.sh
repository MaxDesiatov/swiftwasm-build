#/bin/bash

set -ex

sudo apt update
sudo apt install -y \
  git ninja-build clang python python-six \
  uuid-dev libicu-dev icu-devtools libbsd-dev \
  libedit-dev libxml2-dev libsqlite3-dev swig \
  libpython-dev libncurses5-dev pkg-config \
  libblocksruntime-dev libcurl4-openssl-dev \
  systemtap-sdt-dev tzdata rsync wget llvm zip unzip
sudo apt clean

SOURCE_PATH="$( cd "$(dirname $0)/../../../.." && pwd )" 
SWIFT_PATH=$SOURCE_PATH/swift
cd $SWIFT_PATH

./utils/update-checkout --clone --scheme wasm --skip-repository swift

cd $SOURCE_PATH

if [ -z $(which cmake) ]; then
  wget -O install_cmake.sh "https://github.com/Kitware/CMake/releases/download/v3.17.2/cmake-3.17.2-Linux-x86_64.sh"
  chmod +x install_cmake.sh
  sudo mkdir -p /opt/cmake
  sudo ./install_cmake.sh --skip-license --prefix=/opt/cmake
  sudo ln -sf /opt/cmake/bin/* /usr/local/bin
fi

cmake --version

# Install sccache

if [ -z $(which sccache) ]; then
  sudo mkdir /opt/sccache && cd /opt/sccache
  wget -O - "https://github.com/mozilla/sccache/releases/download/0.2.13/sccache-0.2.13-x86_64-unknown-linux-musl.tar.gz" | \
    sudo tar xz --strip-components 1
  sudo ln -sf /opt/sccache/sccache /usr/local/bin
fi
