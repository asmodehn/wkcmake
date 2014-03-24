# 
# Copyright (c) 2014, Asmodehn's Corp.
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
message ( STATUS "== Loading WkFormat.cmake ... ")

if ( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.8 )
	message ( FATAL_ERROR " CMAKE MINIMUM BACKWARD COMPATIBILITY REQUIRED : 2.8 !" )
endif( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.8 )

include(ExternalProject)

macro( WKFormat )
	option (${PROJECT_NAME}_CODE_FORMAT "Enable Code Formatting" OFF)
	IF ( ${PROJECT_NAME}_CODE_FORMAT )

	# 1) Try to find system install
	FIND_PACKAGE(WKCMAKE_AStyle REQUIRED)
	#Already found : use it
	IF ( WKCMAKE_AStyle_FOUND )

			set(${PROJECT_NAME}_CODE_FORMAT_STYLE "ansi" CACHE STRING "Format Style for AStyle")
			#converting to system path ( needed because command line call later )
			set(HEADERS_NATIVE "")
			foreach (f ${${PROJECT_NAME}_HEADERS} )
				FILE(TO_NATIVE_PATH ${f} f_nat)
				SET(HEADERS_NATIVE ${HEADERS_NATIVE} ${f_nat})
			endforeach(f)
			SET(SOURCES_NATIVE "")
			foreach (f ${${PROJECT_NAME}_SOURCES} )
				FILE(TO_NATIVE_PATH ${f} f_nat)
				SET(SOURCES_NATIVE ${SOURCES_NATIVE} ${f_nat})
			endforeach(f)
			WkWhitespaceSplit( HEADERS_NATIVE HEADERS_PARAM_NATIVE )
			WkWhitespaceSplit( SOURCES_NATIVE SOURCES_PARAM_NATIVE )
			#message ( "Sources :  ${HEADERS_PARAM_NATIVE} ${SOURCES_PARAM_NATIVE}" )
			set ( cmdline " ${WKCMAKE_AStyle_EXECUTABLE} --style=${${PROJECT_NAME}_CODE_FORMAT_STYLE} ${HEADERS_PARAM_NATIVE} ${SOURCES_PARAM_NATIVE}" )
			#message ( "CMD : ${cmdline} " )
			#message ( "WORKING_DIR : ${PROJECT_SOURCE_DIR} " )
			IF ( WIN32 )
				ADD_CUSTOM_TARGET(${PROJECT_NAME}_format ALL cmd /c ${cmdline} WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}" VERBATIM )
			ELSE ( WIN32 )
				ADD_CUSTOM_TARGET(${PROJECT_NAME}_format ALL sh -c ${cmdline} WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}" VERBATIM )
			ENDIF ( WIN32 )
	ENDIF ( WKCMAKE_AStyle_FOUND )

    #setting up dependencies between formatting and code analysis target
	if ( NOT WKCMAKE_Cppcheck_FOUND OR ${PROJECT_NAME}_CODE_ANALYSIS )
    		if( WKCMAKE_AStyle_FOUND AND ${PROJECT_NAME}_CODE_FORMAT )
	    		add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}_format)	    
	        endif( WKCMAKE_AStyle_FOUND AND ${PROJECT_NAME}_CODE_FORMAT )
	endif ( NOT WKCMAKE_Cppcheck_FOUND OR ${PROJECT_NAME}_CODE_ANALYSIS )
	ENDIF ( ${PROJECT_NAME}_CODE_FORMAT )


endmacro( WKFormat )
