#!/bin/sh

BUILD_DIR="../ProjectCsub_build"
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_TYPE=Release
ENABLE_TESTS=ON
UNAME=`uname`

cd $SRC_DIR

set +x

mkdir -p $BUILD_DIR && \
cd $BUILD_DIR && \
echo "Running in $SRC_DIR :" && \
cmake -DProjectCsub_BUILD_TYPE=$BUILD_TYPE -DProjectCsub_ENABLE_TESTS=$ENABLE_TESTS $SRC_DIR && \
make && \ 
ctest

 
