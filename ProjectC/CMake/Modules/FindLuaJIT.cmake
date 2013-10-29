# - Try to find LuaJIT 2.0
# Once done this will define
#
#  LuaJIT_FOUND - system has LuaJIT
#  LuaJIT_INCLUDE_DIRS - the LuaJIT include directory
#  LuaJIT_LIBRARIES - the libraries needed to use LuaJIT
#

include(LibFindMacros)

#Dependencies
#NONE

#Use pkg-config to get hints about paths
#No pkg-config for LuaJIT

#Include dir
find_path(LuaJIT_INCLUDE_DIR
	NAMES luajit.h
	PATH_SUFFIXES luajit-2.0
    )

#Library
find_library(LuaJIT_LIBRARY
    NAMES luajit-5.1 lua51
    )

#Set the include dir variables and teh libraries and let the libfind_process do the work.
#NOTE : Singuler variables for this library, plural for libraries this lib depends on.
set(LuaJIT_PROCESS_INCLUDES LuaJIT_INCLUDE_DIR)
set(LuaJIT_PROCESS_LIBS LuaJIT_LIBRARY)

libfind_process(LuaJIT)

