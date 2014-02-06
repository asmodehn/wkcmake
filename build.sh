#!/bin/sh

MAIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $MAIN_DIR/ProjectC && ./build.sh ; cd $MAIN_DIR