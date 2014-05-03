#!/bin/sh

MAIN_DIR="$( cd "$( dirname "${0}" )" && pwd )"

cd $MAIN_DIR/ProjectA && ./build.sh ; cd $MAIN_DIR
