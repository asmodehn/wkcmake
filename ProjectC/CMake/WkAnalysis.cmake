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
message ( STATUS "== Loading WkAnalysis.cmake ... ")

if ( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.8 )
	message ( FATAL_ERROR " CMAKE MINIMUM BACKWARD COMPATIBILITY REQUIRED : 2.8 !" )
endif( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.8 )

macro( WKAnalysis )
	#code analysis by target introspection -> needs to be done after target definition ( as here )
	FIND_PACKAGE(WKCMAKE_Cppcheck REQUIRED)
	IF ( WKCMAKE_Cppcheck_FOUND)
		option ( ${PROJECT_NAME}_CODE_ANALYSIS "Enable Code Analysis" OFF)
		IF ( ${PROJECT_NAME}_CODE_ANALYSIS )
			Add_WKCMAKE_Cppcheck_target(${PROJECT_NAME}_cppcheck ${PROJECT_NAME} "${PROJECT_NAME}-cppcheck.xml")
		ENDIF ( ${PROJECT_NAME}_CODE_ANALYSIS )
	ENDIF ( WKCMAKE_Cppcheck_FOUND)


	#setting up dependencies between formatting and code analysis target
	if ( WKCMAKE_Cppcheck_FOUND AND ${PROJECT_NAME}_CODE_ANALYSIS )
		add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}_cppcheck)
	    	if( WKCMAKE_AStyle_FOUND AND ${PROJECT_NAME}_CODE_FORMAT )
    			add_dependencies(${PROJECT_NAME}_cppcheck ${PROJECT_NAME}_format)	    
        	endif( WKCMAKE_AStyle_FOUND AND ${PROJECT_NAME}_CODE_FORMAT )
	endif( WKCMAKE_Cppcheck_FOUND AND ${PROJECT_NAME}_CODE_ANALYSIS )


endmacro( WKAnalysis )
