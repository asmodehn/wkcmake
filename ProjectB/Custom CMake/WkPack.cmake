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
message ( STATUS "== Loading WkPack.cmake ..." )

if ( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6 )
	message ( FATAL_ERROR " CMAKE MINIMUM BACKWARD COMPATIBILITY REQUIRED : 2.6 !" )
endif( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6 )

#
# Defining package rules based on well known hierarchy
#

macro( WkPack )

INCLUDE(InstallRequiredSystemLibraries)

SET ( CPACK_PACKAGE_DESCRIPTION_SUMMARY "Test Package" )
SET(CPACK_PACKAGE_VENDOR "Asmodehn's Corp.")

#TODO : Later : Force existence of these 2 files
#( see GNU standard, etc. )
#SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/ReadMe.txt")
#SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/Copyright.txt")

#TODO : Gest version from CMake config / SVN Revision / etc. )
SET(CPACK_PACKAGE_VERSION_MAJOR "0")
SET(CPACK_PACKAGE_VERSION_MINOR "0")
SET(CPACK_PACKAGE_VERSION_PATCH "1")
#default install location on linux : /opt
SET(CPACK_PACKAGE_INSTALL_DIRECTORY "CMake ${CMAKE_VERSION_MAJOR}.${CMAKE_VERSION_MINOR}")

if (WIN32 AND NOT UNIX)
	SET( CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/Cmake\\\\InstallIcon.bmp")
	SET(CPACK_NSIS_INSTALLED_ICON_NAME "bin\\\\Target.exe")
	SET(CPACK_NSIS_DISPLAY_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY} My Prject")
	SET(CPACK_NSIS_HELP_LINK "http://asmodehn.com")
	SET(CPACK_NSIS_URL_INFO_ABOUT "http://asmodehn.com")
	SET(CPACK_NSIS_CONTACT "alex@asmodehn.com")

endif (WIN32 AND NOT UNIX)

INCLUDE(CPack)

endmacro (WkPack )




