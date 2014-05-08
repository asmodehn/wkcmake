#!/bin/sh

BUILD_DIR="build"
SRC_DIR="$( cd "$( dirname "${0}" )" && pwd )"
BUILD_TYPE=Release
#not used here
#ENABLE_TESTS=ON
UNAME=`uname`

cd "$SRC_DIR"

set +x

echo "Building binary depend ../ProjectC"
cd "../ProjectC" && sh build.sh
cd "$SRC_DIR"

echo "Source depend will be built with the current project"

#we pass ProjectB_SRC_DIR to work around problems with cmake and space in folders, while using backward compatible wkbuild command.

mkdir -p "$BUILD_DIR" && \
cd "$BUILD_DIR" && \
echo "Running in $SRC_DIR :" && \
cmake -DProjectB_BUILD_TYPE=$BUILD_TYPE -DProjectB_SRC_DIR="Custom Src" -DProjectC_DIR="../ProjectC/build" $SRC_DIR && \
make && \
./ProjectB > /dev/null
 
