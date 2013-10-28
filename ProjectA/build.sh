#!/bin/sh

BUILD_DIR="../ProjectA_build"
PB_DEP_BUILD_DIR="../ProjectB_build"
SRC_DIR=`pwd`
BUILD_TYPE=Release
ENABLE_TESTS=ON

set +x

mkdir -p $BUILD_DIR && \
cd $BUILD_DIR

echo "Running in `pwd` :"
cmake -DProjectB_DIR=$PB_DEP_BUILD_DIR -DProjectA_BUILD_TYPE=$BUILD_TYPE -DProjectA_ENABLE_TESTS=$ENABLE_TESTS $SRC_DIR

make

ctest

 
