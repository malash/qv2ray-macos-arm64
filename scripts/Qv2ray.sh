#!/bin/sh

ROOT_DIR=`realpath \`dirname $0\`/..`

# Clone repo
cd $ROOT_DIR
mkdir -p sources
cd sources
[ ! -d "./Qv2ray" ] && git clone https://github.com/Qv2ray/Qv2ray.git --branch v2.7.0 --recursive --depth 1

# Build
cd $ROOT_DIR
rm -rf dists/Qv2ray
mkdir -p dists/Qv2ray
cd dists/Qv2ray

# Setup envs
export QTDIR=`realpath ~/Qt/6.3.1/macos`
export PATH="$QTDIR:$PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"

# First build
cmake \
  -DQV2RAY_QT6=ON \
	-DCMAKE_BUILD_TYPE=Release \
	../../sources/Qv2ray
cmake --build . --parallel $(sysctl -n hw.logicalcpu)

# Add missing plugins
mkdir qv2ray.app/Contents/Resources/plugins/
cp libQvPlugin-BuiltinProtocolSupport.so qv2ray.app/Contents/Resources/plugins/libQvPlugin-BuiltinProtocolSupport.so
cp libQvPlugin-BuiltinSubscriptionSupport.so qv2ray.app/Contents/Resources/plugins/libQvPlugin-BuiltinSubscriptionSupport.so

# Second build
cmake --build . --target clean
cmake --build . --parallel $(sysctl -n hw.logicalcpu)
