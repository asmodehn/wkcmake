#!/bin/sh

BUILD_DIR="build"
SRC_DIR="$( cd "$( dirname "${0}" )" && pwd )"
BUILD_TYPE=Release
ENABLE_TESTS=ON
UNAME=`uname`

cd "$SRC_DIR"

set +x


echo "Building binary depend ../ProjectC"
cd "../ProjectC" && sh build.sh
cd "$SRC_DIR"

echo "Building binary depend Custom Depend/ProjectDsub_bin"
cd "Custom Depend/ProjectDsub_bin" && sh build.sh
cd "$SRC_DIR"

echo "Source depend will be built with the current project"

mkdir -p "$BUILD_DIR" && \
cd "$BUILD_DIR" && \
echo "Running in $SRC_DIR :" && \
cmake -DProjectB_BUILD_TYPE=$BUILD_TYPE -DProjectB_ENABLE_TESTS=$ENABLE_TESTS -DProjectC_DIR="../ProjectC/build" $SRC_DIR && \
make && \
ctest

 
