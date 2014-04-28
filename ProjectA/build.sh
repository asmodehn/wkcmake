#!/bin/sh

BUILD_DIR="build"
SRC_DIR="$( cd "$( dirname "${0}" )" && pwd )"
BUILD_TYPE=Release
ENABLE_TESTS=ON
UNAME=`uname`

cd "$SRC_DIR"

set +x

echo "Building binary depend ../ProjectB"
cd "../ProjectB" && sh build.sh
cd "$SRC_DIR"

mkdir -p "$BUILD_DIR" && \
cd "$BUILD_DIR" && \
echo "Running in $SRC_DIR :" && \
cmake -DProjectA_BUILD_TYPE=$BUILD_TYPE -DProjectA_ENABLE_TESTS=$ENABLE_TESTS -DProjectB_DIR="../ProjectB/build" $SRC_DIR && \
make && \
ctest
