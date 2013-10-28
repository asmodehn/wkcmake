#!/bin/sh

BUILD_DIR="../ProjectB_build"
PC_DEP_BUILD_DIR="../ProjectC_build"
SRC_DIR=`pwd`
BUILD_TYPE=Release
ENABLE_TESTS=ON

set +x

mkdir -p $BUILD_DIR && \
cd $BUILD_DIR

echo "Running in `pwd` :"
cmake -DProjectC_DIR=$PC_DEP_BUILD_DIR -DProjectB_BUILD_TYPE=$BUILD_TYPE -DProjectB_ENABLE_TESTS=$ENABLE_TESTS $SRC_DIR

make

ctest

 
