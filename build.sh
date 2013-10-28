#!/bin/sh

BUILD_DIR="../LuaJIT_build"
## always get the directory containing this script
SRC_DIR="$( cd "$( dirname "$0" )" && pwd )"
echo "Source Directory detected : " $SRC_DIR

BUILD_TYPE=Release
ENABLE_TESTS=ON

set +x

mkdir -p $BUILD_DIR && \
cd $BUILD_DIR

echo "Running in `pwd` :"
cmake -DLuaJITtest_BUILD_TYPE=$BUILD_TYPE -DLuaJITtest_ENABLE_TESTS=$ENABLE_TESTS $SRC_DIR

make

ctest

 
