#!/bin/sh

ROOT_DIR=`realpath \`dirname $0\`/..`

# Clone repo
cd $ROOT_DIR
mkdir -p sources
cd sources
[ ! -d "./QvPlugin-SSR" ] && git clone https://github.com/Qv2ray/QvPlugin-SSR.git --branch v3.0.0 --recursive --depth 1

# Build
cd $ROOT_DIR
rm -rf dists/QvPlugin-SSR
mkdir -p dists/QvPlugin-SSR
cd dists/QvPlugin-SSR

# Setup envs
export QTDIR=`realpath ~/Qt/6.3.1/macos`
export PATH="$QTDIR:$PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"

# First build
cmake \
  -DCMAKE_BUILD_TYPE=Release \
	-DQVPLUGIN_USE_QT6=ON \
	../../sources/QvPlugin-SSR
cmake --build . --parallel $(sysctl -n hw.logicalcpu)
