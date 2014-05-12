#!/bin/sh

BUILD_DIR="build"
SRC_DIR="$( cd "$( dirname "${0}" )" && pwd )"
BUILD_TYPE=Release
ENABLE_TESTS=ON
UNAME=`uname`

cd $SRC_DIR

set +x

mkdir -p $BUILD_DIR && \
cd $BUILD_DIR && \
echo "Running in $SRC_DIR :" && \
cmake -DAndroid_BUILD_TYPE=$BUILD_TYPE -DAndroid_ENABLE_TESTS=$ENABLE_TESTS -DCMAKE_TOOLCHAIN_FILE="CMake/Toolchains/android.toolchain.cmake" -DANDROID_STANDALONE_TOOLCHAIN="$SRC_DIR/NDKToolchain/arm-linux-androideabi-4.6" $SRC_DIR && \
make && \
ctest

 
