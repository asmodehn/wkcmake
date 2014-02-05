# 
# Copyright (c) 2010, Asmodehn's Corp.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice, 
#	    this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#		notice, this list of conditions and the following disclaimer in the 
#	    documentation and/or other materials provided with the distribution.
#     * Neither the name of the Asmodehn's Corp. nor the names of its 
#	    contributors may be used to endorse or promote products derived
#	    from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
# THE POSSIBILITY OF SUCH DAMAGE.
#

#debug
message ( STATUS "== Loading WkPlatform.cmake ..." )

if ( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6 )
	message ( FATAL_ERROR " CMAKE MINIMUM BACKWARD COMPATIBILITY REQUIRED : 2.6 !" )
endif( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6 )

###########################################################################################
# Macro to Test current platform                                                          #
# This will set WK_${PROJECT_NAME}_PLATFORM to WIN32, APPLE, UNIX or Unknown in the code  #
###########################################################################################
macro(WkPlatformCheck)

set( WK_${PROJECT_NAME}_PROJECT_NAME ${PROJECT_NAME} CACHE INTERNAL "Build System for ${PROJECT_NAME}" FORCE )

if ( WIN32 )
# is TRUE on Windows, including CygWin 
 set( WK_${PROJECT_NAME}_PLATFORM "WIN32" )
 set( WK_${PROJECT_NAME}_PLATFORM_IS_WIN32 ON )
elseif ( APPLE )
# is TRUE on Apple systems. Note this does not imply the system is Mac OS X, only that __APPLE__ is #defined in C/C++ header files. Obtain more specific system information via CMAKE_SYSTEM_VERSION, i.e. IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin"), then it's Mac OS X. 
 set ( WK_${PROJECT_NAME}_PLATFORM "APPLE" )
 set ( WK_${PROJECT_NAME}_PLATFORM_IS_APPLE ON )
elseif ( UNIX )
# is TRUE on all UNIX-like OS's, including Apple OS X and CygWin 
 set( WK_${PROJECT_NAME}_PLATFORM "UNIX" )
 set( WK_${PROJECT_NAME}_PLATFORM_IS_UNIX ON )
else ()
 set( WK_${PROJECT_NAME}_PLATFORM "Unknown" )
endif()

set( WK_${PROJECT_NAME}_PLATFORM ${WK_${PROJECT_NAME}_PLATFORM} CACHE INTERNAL "Build Platform for ${PROJECT_NAME}" FORCE )
set( WK_${PROJECT_NAME}_PLATFORM_IS_WIN32 ${WK_${PROJECT_NAME}_PLATFORM_IS_WIN32} CACHE INTERNAL "Win32 Build Platform for ${PROJECT_NAME} ?" FORCE )
set( WK_${PROJECT_NAME}_PLATFORM_IS_APPLE ${WK_${PROJECT_NAME}_PLATFORM_IS_APPLE} CACHE INTERNAL "Apple Build Platform for ${PROJECT_NAME} ?" FORCE )
set( WK_${PROJECT_NAME}_PLATFORM_IS_UNIX ${WK_${PROJECT_NAME}_PLATFORM_IS_UNIX} CACHE INTERNAL "Unix Build Platform for ${PROJECT_NAME} ?" FORCE )

message ( STATUS "== Platform detected : ${WK_${PROJECT_NAME}_PLATFORM}" )

###################################################################
#Testing System in details ( cmake > 2.6 )                        #
###################################################################
if ( CMAKE_SYSTEM )
 set ( WK_${PROJECT_NAME}_SYSTEM "${CMAKE_SYSTEM}" )
endif ( CMAKE_SYSTEM )
if ( CMAKE_SYSTEM_NAME )
 set ( WK_${PROJECT_NAME}_SYSTEM_NAME "${CMAKE_SYSTEM_NAME}" )
endif ( CMAKE_SYSTEM_NAME)
if ( CMAKE_SYSTEM_VERSION )
 set ( WK_${PROJECT_NAME}_SYSTEM_VERSION "${CMAKE_SYSTEM_VERSION}" )
endif ( CMAKE_SYSTEM_VERSION )
if ( CMAKE_SYSTEM_PROCESSOR )
 set ( WK_${PROJECT_NAME}_SYSTEM_PROCESSOR "${CMAKE_SYSTEM_PROCESSOR}" )
endif ( CMAKE_SYSTEM_PROCESSOR )


#Additional Testing for common system
if( WK_${PROJECT_NAME}_SYSTEM_NAME} MATCHES "Darwin")
# Mac OS X system
 set( WK_${PROJECT_NAME}_SYSTEM_IS_MACOSX ON )
elseif ( WK_${PROJECT_NAME}_SYSTEM_NAME} MATCHES "Windows")
# Windows system
 set ( WK_${PROJECT_NAME}_SYSTEM_IS_WINDOWS ON )
elseif ( WK_${PROJECT_NAME}_SYSTEM_NAME} MATCHES "Linux")
# Linux system
 set ( WK_${PROJECT_NAME}_SYSTEM_IS_LINUX ON )
endif()

set( WK_${PROJECT_NAME}_SYSTEM ${WK_${PROJECT_NAME}_SYSTEM} CACHE INTERNAL "Build System for ${PROJECT_NAME}" FORCE )
set( WK_${PROJECT_NAME}_SYSTEM_NAME ${WK_${PROJECT_NAME}_SYSTEM_NAME} CACHE INTERNAL "Build System Name for ${PROJECT_NAME}" FORCE )
set( WK_${PROJECT_NAME}_SYSTEM_VERSION ${WK_${PROJECT_NAME}_SYSTEM_VERSION} CACHE INTERNAL "Build System Version for ${PROJECT_NAME}" FORCE )
set( WK_${PROJECT_NAME}_SYSTEM_PROCESSOR ${WK_${PROJECT_NAME}_SYSTEM_PROCESSOR} CACHE INTERNAL "Build system Processor for ${PROJECT_NAME}" FORCE )
set( WK_${PROJECT_NAME}_SYSTEM_IS_WINDOWS ${WK_${PROJECT_NAME}_SYSTEM_IS_WINDOWS} CACHE INTERNAL "Windows Build System for ${PROJECT_NAME} ?" FORCE )
set( WK_${PROJECT_NAME}_SYSTEM_IS_MACOSX ${WK_${PROJECT_NAME}_SYSTEM_IS_MACOSX} CACHE INTERNAL "MacOSX Build System for ${PROJECT_NAME} ?" FORCE )
set( WK_${PROJECT_NAME}_SYSTEM_IS_LINUX ${WK_${PROJECT_NAME}_SYSTEM_IS_LINUX} CACHE INTERNAL "Linux Build System for ${PROJECT_NAME} ?" FORCE )

message ( STATUS "== System detected : ${WK_${PROJECT_NAME}_SYSTEM}" )


############################################################################################################
# Testing curent Compiler                                                                                  #
# This will set                                                                                            #
# WK_${PROJECT_NAME}_COMPILER to MINGW, MSYS, CYGWIN, BORLAND, WATCOM, MSVC90, MSVC80, MSVC71, MSVC70      #
# WK_${PROJECT_NAME}_COMPILER_IS_MSVC if the compiler is a MS compiler                                     #
# WK_${PROJECT_NAME}_COMPILER_IS_GNUCC if the compiler is a variant of GCC                                 #
# WK_${PROJECT_NAME}_COMPILER_IS_GNUCXX if the compiler is a variant of G++                                #
############################################################################################################
if ( MINGW )
#    is TRUE when using the MinGW compiler in Windows 
 set ( WK_${PROJECT_NAME}_COMPILER "MINGW" )
elseif( MSYS )
#    is TRUE when using the MSYS developer environment in Windows 
 set ( WK_${PROJECT_NAME}_COMPILER "MSYS" )
elseif ( CYGWIN )
#    is TRUE on Windows when using the CygWin version of cmake 
 set ( WK_${PROJECT_NAME}_COMPILER  "CYGWIN" )
elseif ( BORLAND )
#    is TRUE on Windows when using a Borland compiler 
 set ( WK_${PROJECT_NAME}_COMPILER  "BORLAND" )
elseif( WATCOM )
#    is TRUE on Windows when using the Open Watcom compiler 
 set ( WK_${PROJECT_NAME}_COMPILER  "WATCOM" )
elseif ( MSVC90 )
#    Microsoft Visual 9
 set ( WK_${PROJECT_NAME}_COMPILER  "MSVC90" )
elseif ( MSVC80 )
#    Microsoft Visual 8
 set ( WK_${PROJECT_NAME}_COMPILER  "MSVC80" )
elseif ( MSVC71 )
#    Microsoft Visual 7.1
 set ( WK_${PROJECT_NAME}_COMPILER "MSVC71" )
elseif ( MSVC70 )
#    Microsoft Visual 7.0
 set ( WK_${PROJECT_NAME}_COMPILER  "MSVC70" )
elseif ( MSVC60 )
#    Microsoft Visual 6.0
 set ( WK_${PROJECT_NAME}_COMPILER  "MSVC60" )
else ()
# Others
 set ( WK_${PROJECT_NAME}_COMPILER  "Unknown" )
endif ()

if ( ${WK_${PROJECT_NAME}_COMPILER} MATCHES "MSVC" )
 set ( WK_${PROJECT_NAME}_COMPILER_IS_MSVC ON)
endif ( ${WK_${PROJECT_NAME}_COMPILER} MATCHES "MSVC" )

if ( CMAKE_COMPILER_IS_GNUCC )
#    is TRUE if the compiler is a variant of gcc 
 set ( WK_${PROJECT_NAME}_COMPILER_IS_GNUCC ON )
endif ( CMAKE_COMPILER_IS_GNUCC )

if ( CMAKE_COMPILER_IS_GNUCXX )
#    is TRUE if the compiler is a variant of g++ 
 set ( WK_${PROJECT_NAME}_COMPILER_IS_GNUCXX ON )
endif ( CMAKE_COMPILER_IS_GNUCXX )

set( WK_${PROJECT_NAME}_COMPILER ${WK_${PROJECT_NAME}_COMPILER} CACHE INTERNAL "Build Compiler for ${PROJECT_NAME}" FORCE )
set( WK_${PROJECT_NAME}_COMPILER_IS_MSVC ${WK_${PROJECT_NAME}_COMPILER_IS_MSVC} CACHE INTERNAL "MSVC Build Compiler for ${PROJECT_NAME} ?" FORCE )
set( WK_${PROJECT_NAME}_COMPILER_IS_GNUCC ${WK_${PROJECT_NAME}_COMPILER_IS_GNUCC} CACHE INTERNAL "GNU-C Build Compiler for ${PROJECT_NAME} ?" FORCE )
set( WK_${PROJECT_NAME}_COMPILER_IS_GNUCXX ${WK_${PROJECT_NAME}_COMPILER_IS_GNUCXX} CACHE INTERNAL "GNU-C++ Build Compiler for ${PROJECT_NAME} ?" FORCE )

message ( STATUS "== Compiler detected : ${WK_${PROJECT_NAME}_COMPILER}" )

########################################################
# Extensive tests on compilation environment           #
########################################################
INCLUDE (CheckIncludeFiles)
# usage: CHECK_INCLUDE_FILES (<header> <RESULT_VARIABLE> )

CHECK_INCLUDE_FILES (unistd.h WK_${PROJECT_NAME}_HAS_UNISTD_H)

endmacro(WkPlatformCheck)


########################################################
# Macro to apply the variables to config header        #
########################################################
macro(WkPlatformConfigure)
# configure the platform check component and copy it into the program sources.
# We can afford to do that because the platform check is simple.
# if it gets more complicated ( > 1 file), we need to make a custom library
# and make the link to the project optional.
	message ( STATUS "== Configuring WkPlatform : ${WKCMAKE_DIR}/WkPlatform.[h/c].config -> ${PROJECT_BINARY_DIR}/CMakeFiles/WkPlatform_${PROJECT_NAME}.[h/c]" )
	#message ( STATUS "== Platform : ${WK_${PROJECT_NAME}_PLATFORM}" )
	#message ( STATUS "== System : ${WK_${PROJECT_NAME}_SYSTEM}" )
	#message ( STATUS "== Compiler : ${WK_${PROJECT_NAME}_COMPILER}" )
	set ( CMAKEDEFINE "#cmakedefine")
	# This configure replaces all @PROJECT_NAME@ with the actual project name to make sure all defined macros are unique in the project tree
	configure_file(${WKCMAKE_DIR}/WkPlatform.h.config ${PROJECT_BINARY_DIR}/CMakeFiles/WkPlatform_${PROJECT_NAME}.h.in @ONLY)
	# This configure replaces all variables in the file with ${} with CMAKE ones, as usual in CMake...
	configure_file(${PROJECT_BINARY_DIR}/CMakeFiles/WkPlatform_${PROJECT_NAME}.h.in ${PROJECT_BINARY_DIR}/CMakeFiles/WkPlatform_${PROJECT_NAME}.h )
	configure_file(${WKCMAKE_DIR}/WkPlatform.c.config ${PROJECT_BINARY_DIR}/CMakeFiles/WkPlatform_${PROJECT_NAME}.c )
endmacro(WkPlatformConfigure)

macro(AddPlatformCheckSrc VAR )
	SET( ${VAR} "${${VAR}}" "CMakeFiles/WkPlatform_${PROJECT_NAME}.c")
endmacro(AddPlatformCheckSrc VAR )


