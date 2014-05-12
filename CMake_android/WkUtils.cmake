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

#debug
message( STATUS "== Loading WkUtils.cmake ... " )

MACRO(MERGE ALIST BLIST OUTPUT)
   SET(BTEMP "${BLIST}")
   FOREACH(A ${ALIST})
       SET(SORTED)
       SET(UNINSERTED 1)
       FOREACH(B ${BTEMP})
           IF(${UNINSERTED})
               IF(${A} STRLESS ${B})
                   SET(SORTED ${SORTED} ${A})
                   SET(UNINSERTED 0)
               ENDIF(${A} STRLESS ${B})
           ENDIF(${UNINSERTED})
           SET(SORTED ${SORTED} ${B})
       ENDFOREACH(B ${BLIST})
       IF(${UNINSERTED})
           SET(SORTED ${SORTED} ${A})
       ENDIF(${UNINSERTED})
       SET(BTEMP ${SORTED})
   ENDFOREACH(A ${ALIST})
   SET(${OUTPUT} ${BTEMP})
ENDMACRO(MERGE ALIST BLIST OUTPUT)

macro(WkWhitespaceSplit source WSsplitted)
#warning : WSsplitted is erased here 
	#message ( "WSsplitted: ${${WSsplitted}} ")
	#message ( "source: ${${source}} ")
	set ( WSsplitted "")
	foreach(arg ${${source}})
		#message ( "WSsplitted: ${${WSsplitted}} ")
		#message ( "arg: ${arg} " )
		set(${WSsplitted} "${${WSsplitted}} \"${arg}\"")
		#message ( "WSsplitted: ${${WSsplitted}} ")
	endforeach(arg ${${source}})
endmacro(WkWhitespaceSplit source WSsplitted)

macro(WkCustomSplit source delimiter Csplitted)
#warning : Csplitted is erased here 
	#message ( "Csplitted: ${${Csplitted}} ")
	#message ( "source: ${${source}} ")
	set ( Csplitted "")
	foreach(arg ${${source}})
		#message ( "Csplitted: ${${Csplitted}} ")
		#message ( "arg: ${arg} " )
		set(${Csplitted} "${${Csplitted}}${delimiter}\"${arg}\"")
		#message ( "Csplitted: ${${Csplitted}} ")
	endforeach(arg ${${source}})
endmacro(WkCustomSplit source delimiter Csplitted)

macro(SetPackageVarName varname pkgname)
#Sometime the variable name is differnet from the package name... annoying
	set ( ${varname} ${pkgname} )
	#handle special cases
	if ( ${${varname}} STREQUAL "SDL_image") 
		set ( ${varname} "SDLIMAGE")
	endif ( ${${varname}} STREQUAL "SDL_image") 	
	if ( ${${varname}} STREQUAL "SDL_mixer") 
		set ( ${varname} "SDLMIXER")
	endif ( ${${varname}} STREQUAL "SDL_mixer") 	
	if ( ${${varname}} STREQUAL "SDL_ttf") 
		set ( ${varname} "SDLTTF")
	endif ( ${${varname}} STREQUAL "SDL_ttf") 	
	if ( ${${varname}} STREQUAL "SDL_net") 
		set ( ${varname} "SDLNET")
	endif ( ${${varname}} STREQUAL "SDL_net") 	
	if ( ${${varname}} STREQUAL "OpenGL" )
		set ( ${varname} "OPENGL")
	endif ( ${${varname}} STREQUAL "OpenGL" )
	if ( ${${varname}} STREQUAL "Guichan" )
		set ( ${varname} "GUICHAN")
	endif ( ${${varname}} STREQUAL "Guichan" )
	if ( ${${varname}} STREQUAL "STLPort" )
		set ( ${varname} "STLPORT")
	endif ( ${${varname}} STREQUAL "STLPort" )
	# NB : MySql doesnt require renaming here as it is our own module and variable name and package name are the same
	if ( ${${varname}} STREQUAL "MySQL++" )
		set ( ${varname} "MySQLpp")
	endif ( ${${varname}} STREQUAL "MySQL++" )
	# NB : Bullet doesnt require renaming here as it is our own module and variable name and package name are the same
	# NB : LuaJIT doesnt require renaming here as it is our own module and variable name and package name are the same
	#etc.
	# add whats needed for the projects we support, waiting for a standard way in cmake modules...
	#

endmacro(SetPackageVarName varname pkgname)
