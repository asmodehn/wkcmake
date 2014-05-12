@echo off
setlocal

set BUILD_DIR="win64"
set SRC_DIR="%CD%"

set ORI_DIR=%CD%

rem TODO : find NDK directory by getting ouput of "where ndkbuild"

rem TODO : find a way to build a custom toolchain on windows, with sh scripts...
