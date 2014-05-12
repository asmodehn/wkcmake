# 
# Copyright (c) 2009, Asmodehn's Corp.
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

if ( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.8.3 )
	message ( FATAL_ERROR " CMAKE MINIMUM BACKWARD COMPATIBILITY REQUIRED : 2.8.3 !" )
endif( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.8.3 )

message ( STATUS "== Loading WkCMake.cmake from ${CMAKE_CURRENT_LIST_DIR}... ")

set ( WKCMAKE_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE PATH "WkCMake Scripts path" )
mark_as_advanced ( WKCMAKE_DIR )

macro(WkCMakeInit)
    if (NOT WKCMAKE_INIT_DONE) #to protect against add_subdirectory(). Only top WkCMake loads and inits.

    	# regroup original CMAKE_MODULE_PATH and WkCmake Module path in order for the find_package to look inside both locations
    	set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${WKCMAKE_DIR}/Modules/")
	
        #including other useful files
	    include ( "${WKCMAKE_DIR}/WkBuild.cmake" RESULT_VARIABLE WKCMAKEBUILD_FOUND )
    	IF ( NOT WKCMAKEBUILD_FOUND )
    		message ( FATAL_ERROR "${WKCMAKE_DIR}/WkBuild.cmake Not Found !!!" )
    	ENDIF ( NOT WKCMAKEBUILD_FOUND )
    	include ( "${WKCMAKE_DIR}/WkDepends.cmake" RESULT_VARIABLE WKCMAKEDEPENDS_FOUND )
    	IF ( NOT WKCMAKEDEPENDS_FOUND )
    		message ( FATAL_ERROR "${WKCMAKE_DIR}/WkDepends.cmake Not Found !!!" )
    	ENDIF ( NOT WKCMAKEDEPENDS_FOUND )
    	include ( "${WKCMAKE_DIR}/WkTest.cmake" RESULT_VARIABLE WKCMAKETEST_FOUND )
    	IF ( NOT WKCMAKETEST_FOUND )
    		message ( FATAL_ERROR "${WKCMAKE_DIR}/WkTest.cmake Not Found !!!" )
    	ENDIF ( NOT WKCMAKETEST_FOUND )
    	include ( "${WKCMAKE_DIR}/WkDoc.cmake" RESULT_VARIABLE WKCMAKEDOC_FOUND )
    	IF ( NOT WKCMAKEDOC_FOUND )
    		message ( FATAL_ERROR "${WKCMAKE_DIR}/WkDoc.cmake Not Found !!!" )
    	ENDIF ( NOT WKCMAKEDOC_FOUND )
    	include ( "${WKCMAKE_DIR}/WkSubversion.cmake" RESULT_VARIABLE WKCMAKESVN_FOUND )
    	IF ( NOT WKCMAKESVN_FOUND )
    		message ( FATAL_ERROR "${WKCMAKE_DIR}/WkSubversion.cmake Not Found !!!" )
    	ENDIF ( NOT WKCMAKESVN_FOUND )
    	include ( "${WKCMAKE_DIR}/WkInstall.cmake" RESULT_VARIABLE WKCMAKEINSTALL_FOUND )
	    IF ( NOT WKCMAKEINSTALL_FOUND )
    		message ( FATAL_ERROR "${WKCMAKE_DIR}/WkInstall.cmake Not Found !!!" )
    	ENDIF ( NOT WKCMAKEINSTALL_FOUND )
	    include ( "${WKCMAKE_DIR}/WkPack.cmake" RESULT_VARIABLE WKCMAKEPACK_FOUND )
    	IF ( NOT WKCMAKEPACK_FOUND )
    		message ( FATAL_ERROR "${WKCMAKE_DIR}/WkPack.cmake Not Found !!!" )
    	ENDIF ( NOT WKCMAKEPACK_FOUND )
	
	    set(WKCMAKE_INIT_DONE true)
	    
	endif(NOT WKCMAKE_INIT_DONE)
endmacro(WkCMakeInit)

macro(WkCMakeDir dir)
    WkCMakeInit()
endmacro(WkCMakeDir dir)

macro(WkModulesDir dir)
    if (NOT WKCMAKE_MODULES_INIT_DONE) #to protect against add_subdirectory()
	    set ( WKCMAKE_MODULES_DIR ${dir} CACHE PATH "Modules directory for package autodetection by WkCMake" FORCE )
    	#TODO : detect if absolute or relative...
    	set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/${WKCMAKE_MODULES_DIR}")
    	mark_as_advanced ( WKCMAKE_MODULES_DIR )
	    set(WKCMAKE_MODULES_INIT_DONE true)
	    
	endif(NOT WKCMAKE_MODULES_INIT_DONE)
endmacro(WkModulesDir dir)


