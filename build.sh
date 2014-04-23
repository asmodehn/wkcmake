#!/bin/sh

MAIN_DIR="$( cd "$( dirname "$0}" )" && pwd )"

cd $MAIN_DIR/ProjectC && ./build.sh ; cd $MAIN_DIR
cd $MAIN_DIR/ProjectCsub && ./build.sh ; cd $MAIN_DIR
cd $MAIN_DIR/ProjectB && ./build.sh ; cd $MAIN_DIR
