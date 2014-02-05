#!/bin/sh

BUILD_DIR="../ProjectC_build"
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_TYPE=Release
ENABLE_TESTS=ON
UNAME=`uname`

cd $SRC_DIR

set +x

mkdir -p $BUILD_DIR && \
cd $BUILD_DIR && \
echo "Running in $SRC_DIR :" && \
cmake -DProjectC_BUILD_TYPE=$BUILD_TYPE -DProjectC_ENABLE_TESTS=$ENABLE_TESTS $SRC_DIR && \
make && \ 
ctest

 
