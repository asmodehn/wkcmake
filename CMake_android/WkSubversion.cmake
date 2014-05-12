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


#TODO : Use SVN version to find > 1.1.0 : supports symbolic links :D
#TODO : Use CMake > 2.6 : find subversion has been added

if ( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6 )
	message ( FATAL_ERROR " CMAKE MINIMUM BACKWARD COMPATIBILITY REQUIRED : 2.6 !" )
endif( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6 )

#
# Common use of Cmake in Wk
#


macro (WkSvn)

find_package(Subversion)
if(Subversion_FOUND)
	message(STATUS "== Retrieving SVN repository information...")
	Subversion_WC_INFO(${PROJECT_SOURCE_DIR} ${PROJECT_NAME})
	#This requires connection to the server which might be annoying...
	#Subversion_WC_LOG(${PROJECT_SOURCE_DIR} ${PROJECT_NAME})
	#message("Last changed log is ${${PROJECT_NAME}_LAST_CHANGED_LOG}")
	# TODO : generate changelog...
	SET (${PROJECT_NAME}_SVN_REVISION ${${PROJECT_NAME}_WC_REVISION} CACHE STRING "The detected revision of the source repository" FORCE)
else(Subversion_FOUND)
	SET (${PROJECT_NAME}_SVN_REVISION "SVN-NOTFOUND" CACHE STRING "The detected revision of the source repository" FORCE)
endif(Subversion_FOUND)

endmacro (WkSvn)
