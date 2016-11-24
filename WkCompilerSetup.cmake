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

#
# Compiler Specific rules
# All modifications for Flags should be here
# These macros exists to use more pedantic rules to build software. Thus improving the quality of working code
#

#debug
message ( STATUS "== Loading WkCompilerSetup.cmake ... ")

if ( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6 )
	message ( FATAL_ERROR " CMAKE MINIMUM BACKWARD COMPATIBILITY REQUIRED : 2.6 !" )
endif( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6 )

# Macros to redefine default options for build type

# Usage : WkSetCFlags( "-new -flags" )
macro(WkSetCFlags)
	SET(${PROJECT_NAME}_C_FLAGS "${ARGN}" CACHE STRING "${PROJECT_NAME} Flags for C Compiler." )
	MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_C_FLAGS )
endmacro(WkSetCFlags )

# Usage : WkAddCFlags( "-new -flags" )
macro(WkAddCFlags)
	IF ( ${PROJECT_NAME}_C_FLAGS )
		STRING(FIND "${${PROJECT_NAME}_C_FLAGS}" "${ARGN}" already_stored)
		IF(${already_stored} LESS 0)
			SET(${PROJECT_NAME}_C_FLAGS "${${PROJECT_NAME}_C_FLAGS} ${ARGN}" CACHE STRING "${PROJECT_NAME} Flags for C Compiler." FORCE)
		ENDIF()
	ELSE ( ${PROJECT_NAME}_C_FLAGS )
		SET(${PROJECT_NAME}_C_FLAGS "${ARGN}" CACHE STRING "${PROJECT_NAME} Flags for C Compiler." FORCE)
	ENDIF ( ${PROJECT_NAME}_C_FLAGS )
endmacro(WkAddCFlags)		

# Usage : WkAddCDefinitions( [Debug|Release] [newdef1] [newdef2] )
macro(WkAddCDefinitions Build)
	IF ( ${PROJECT_NAME}_C_DEFINITIONS_DEBUG AND ${Build} STREQUAL Debug )
		foreach(newdef ${ARGN})
			#message(STATUS "LIST(FIND ${${PROJECT_NAME}_C_DEFINITIONS_DEBUG} ${newdef} already_stored)")
			LIST(FIND ${PROJECT_NAME}_C_DEFINITIONS_DEBUG ${newdef} already_stored)
			#message(STATUS ${already_stored})
			IF(${already_stored} LESS 0)
				LIST(APPEND ${PROJECT_NAME}_C_DEFINITIONS_DEBUG "${newdef}")
			ENDIF()
		endforeach()
	ELSEIF ( ${PROJECT_NAME}_C_DEFINITIONS_RELEASE AND ${Build} STREQUAL Release )
		foreach(newdef ${ARGN})
			LIST(FIND ${PROJECT_NAME}_C_DEFINITIONS_RELEASE ${newdef} already_stored)
			IF(${already_stored} LESS 0)
				LIST(APPEND ${PROJECT_NAME}_C_DEFINITIONS_RELEASE "${newdef}")
			ENDIF()
		endforeach()
	ELSE()
		IF( ${Build} STREQUAL Debug )
			LIST(APPEND ${PROJECT_NAME}_C_DEFINITIONS_DEBUG "${ARGN}")
		ELSEIF ( ${Build} STREQUAL Release)
			LIST(APPEND ${PROJECT_NAME}_C_DEFINITIONS_RELEASE "${ARGN}")
		ELSE()
			message(WARNING " ${Build} is not a valid build type.")
		ENDIF()
	ENDIF ()
endmacro(WkAddCDefinitions Build)

# Usage : WkRmDefaultCFlags( "FLAG_TO_MODIFY -new -flags" )
macro(WkRmFlags FLAG)
	IF ( ${FLAG} )
		#explode string as list
		set(CURRENT_C_ARGS ${${FLAG}})
		separate_arguments(CURRENT_C_ARGS)
		# remove items from list
		LIST(REMOVE_ITEM CURRENT_C_ARGS ${ARGN})
		
		#rewrite all arguments as string
		set(NEW_FLAGS "")
		foreach(f ${CURRENT_C_ARGS})
			set(NEW_FLAGS "${NEW_FLAGS}${f} " )
		endforeach(f)
		set(${FLAG} ${NEW_FLAGS} CACHE STRING "" FORCE)
	ELSE ( ${FLAG} )
		message(${FLAG} " not set!")
	ENDIF ( ${FLAG} )
		
endmacro(WkRmFlags)	

# Usage : WkSetCXXFlags( "-new -flags" )
macro(WkSetCXXFlags)
	SET(${PROJECT_NAME}_CXX_FLAGS "${ARGN}" CACHE STRING "${PROJECT_NAME} Flags for C++ Compiler.")
	MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_CXX_FLAGS )
endmacro(WkSetCXXFlags)

# Usage : WkAddCXXFlags( "-new -flags" )
macro(WkAddCXXFlags)
	IF ( ${PROJECT_NAME}_CXX_FLAGS )
		STRING(FIND "${${PROJECT_NAME}_CXX_FLAGS}" "${ARGN}" already_stored)
		IF( ${already_stored} LESS 0)
			SET(${PROJECT_NAME}_CXX_FLAGS "${${PROJECT_NAME}_CXX_FLAGS} ${ARGN}" CACHE STRING "${PROJECT_NAME} Flags for C++ Compiler." FORCE)
		ENDIF()
	ELSE( ${PROJECT_NAME}_CXX_FLAGS )
		SET(${PROJECT_NAME}_CXX_FLAGS "${ARGN}" CACHE STRING "${PROJECT_NAME} Flags for C++ Compiler." FORCE)
	ENDIF ( ${PROJECT_NAME}_CXX_FLAGS )
endmacro(WkAddCXXFlags)

macro(WkAddDefaultCXXFlagsDebug)
	STRING(FIND CMAKE_CXX_FLAGS_DEBUG ${ARGN} already_stored)
	IF( ${already_stored} LESS 0)
		SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${ARGN}" CACHE STRING "CMAKE Flags for C++ Compiler." FORCE)
	ENDIF()
endmacro(WkAddDefaultCXXFlagsDebug)

# Usage : WkAddCXXDefinitions( [Debug|Release] [newdef1] [newdef2] )
macro(WkAddCXXDefinitions Build)
	IF ( ${PROJECT_NAME}_CXX_DEFINITIONS_DEBUG AND ${Build} STREQUAL Debug )
		foreach( newdef ${ARGN} )
			LIST(FIND ${PROJECT_NAME}_CXX_DEFINITIONS_DEBUG ${newdef} already_stored)
			IF( ${already_stored} LESS 0)
				LIST( APPEND ${PROJECT_NAME}_CXX_DEFINITIONS_DEBUG "${newdef}")
			ENDIF()
		endforeach()
	ELSEIF (${PROJECT_NAME}_CXX_DEFINITIONS_RELEASE AND ${Build} STREQUAL Release )
		foreach ( newdef ${ARGN} )
			LIST(FIND ${PROJECT_NAME}_CXX_DEFINITIONS_RELEASE ${newdef} already_stored)
			IF( ${already_stored} LESS 0)
				LIST(APPEND ${PROJECT_NAME}_CXX_DEFINITIONS_RELEASE "${newdef}")
			ENDIF()
		endforeach()
	ELSE()
		IF( ${Build} STREQUAL Debug )
			LIST(APPEND ${PROJECT_NAME}_CXX_DEFINITIONS_DEBUG "${ARGN}")
		ELSEIF ( ${Build} STREQUAL Release)
			LIST(APPEND ${PROJECT_NAME}_CXX_DEFINITIONS_RELEASE "${ARGN}")
		ELSE()
			message(WARNING " ${Build} is not a valid build type.")
		ENDIF()
	ENDIF ()
endmacro(WkAddCXXDefinitions Build)

#TODO : Change usage: All | Debug | Release might not alway be obvious to use...
# Usage : WkSetExeLinkerFlags( Build [flags] )
macro(WkSetExeLinkerFlags Build)
	IF (${Build} STREQUAL All )
		SET(${PROJECT_NAME}_EXE_LINKER_FLAGS "${ARGN}" CACHE STRING "${PROJECT_NAME} Flags used by the linker.")
		MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_EXE_LINKER_FLAGS )
	ELSEIF (${Build} STREQUAL Debug )
		SET(${PROJECT_NAME}_EXE_LINKER_FLAGS_DEBUG "${ARGN}" CACHE STRING " ${PROJECT_NAME} Flags used by the linker during debug builds.")
		MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_EXE_LINKER_FLAGS_DEBUG )
	ELSEIF (${Build} STREQUAL Release )
		SET(${PROJECT_NAME}_EXE_LINKER_FLAGS_RELEASE "${ARGN}" CACHE STRING " ${PROJECT_NAME} Flags used by the linker during release builds.")
		MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_EXE_LINKER_FLAGS_RELEASE )
	ENDIF (${Build} STREQUAL All )
endmacro(WkSetExeLinkerFlags )

# Usage : WkSetSharedLinkerFlags(  Build [flags] )
macro(WkSetSharedLinkerFlags Build)
	IF (${Build} STREQUAL All )
		SET(${PROJECT_NAME}_SHARED_LINKER_FLAGS "${ARGN}" CACHE STRING "${PROJECT_NAME} Flags used by the linker during the creation of dll's.")
		MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_SHARED_LINKER_FLAGS )
	ELSEIF (${Build} STREQUAL Debug )
		SET(${PROJECT_NAME}_SHARED_LINKER_FLAGS_DEBUG "${ARGN}" CACHE STRING " ${PROJECT_NAME} Flags used by the linker during debug builds.")
		MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_SHARED_LINKER_FLAGS_DEBUG )
	ELSEIF (${Build} STREQUAL Release )
		SET(${PROJECT_NAME}_SHARED_LINKER_FLAGS_RELEASE "${ARGN}" CACHE STRING " ${PROJECT_NAME} Flags used by the linker during release builds.")
		MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_SHARED_LINKER_FLAGS_RELEASE )	
	ENDIF (${Build} STREQUAL All )
endmacro(WkSetSharedLinkerFlags )

# Usage : WkSetModuleLinkerFlags( Build [flags] )
macro(WkSetModuleLinkerFlags Build)
	IF (${Build} STREQUAL All )
		SET(${PROJECT_NAME}_MODULE_LINKER_FLAGS "${ARGN}" CACHE STRING "${PROJECT_NAME} Flags used by the linker during the creation of modules.")
		MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_MODULE_LINKER_FLAGS )
	ELSEIF (${Build} STREQUAL Debug )
		SET(${PROJECT_NAME}_MODULE_LINKER_FLAGS_DEBUG "${ARGN}" CACHE STRING " ${PROJECT_NAME} Flags used by the linker during debug builds.")
		MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_MODULE_LINKER_FLAGS_DEBUG )
	ELSEIF (${Build} STREQUAL Release )
		SET(${PROJECT_NAME}_MODULE_LINKER_FLAGS_RELEASE "${ARGN}" CACHE STRING " ${PROJECT_NAME} Flags used by the linker during release builds.")
		MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_MODULE_LINKER_FLAGS_RELEASE )
	ENDIF (${Build} STREQUAL All )
endmacro(WkSetModuleLinkerFlags )
  
# Usage : WkDisableFlags ( Build )
#TODO : Remove. Sounds like a bad idea now...
macro ( WkDisableFlags Build )

IF(${Build} STREQUAL Debug)
	SET(CMAKE_C_DEFINITIONS_DEBUG CACHE INTERNAL "Internal CMake C flags for Debug mode do not edit" FORCE)
	SET(CMAKE_CXX_DEFINITIONS_DEBUG CACHE INTERNAL "Internal CMake C++ flags for Debug mode do not edit" FORCE)
	SET(CMAKE_EXE_LINKER_FLAGS_DEBUG CACHE INTERNAL "Internal CMake linker flags for Debug mode do not edit" FORCE)
	SET(CMAKE_SHARED_LINKER_FLAGS_DEBUG CACHE INTERNAL "Internal CMake linker flags for Debug mode do not edit" FORCE)
	SET(CMAKE_MODULE_LINKER_FLAGS_DEBUG CACHE INTERNAL "Internal CMake linker flags for Debug mode do not edit" FORCE)
ELSEIF(${Build} STREQUAL Release)
	SET(CMAKE_C_DEFINITIONS_RELEASE CACHE INTERNAL "Internal CMake C flags for Release mode do not edit" FORCE)
	SET(CMAKE_CXX_DEFINITIONS_RELEASE CACHE INTERNAL "Internal CMake C++ flags for Release mode do not edit" FORCE)
	SET(CMAKE_EXE_LINKER_FLAGS_RELEASE CACHE INTERNAL "Internal CMake linker flags for Release mode do not edit" FORCE)
	SET(CMAKE_SHARED_LINKER_FLAGS_RELEASE CACHE INTERNAL "Internal CMake linker flags for Release mode do not edit" FORCE)
	SET(CMAKE_MODULE_LINKER_FLAGS_RELEASE CACHE INTERNAL "Internal CMake linker flags for Release mode do not edit" FORCE)
ELSEIF(${Build} STREQUAL RelWithDebInfo)
	SET(CMAKE_C_DEFINITIONS_RELWITHDEBINFO CACHE INTERNAL "Internal CMake C flags for Release with Debug Info mode do not edit" FORCE)
	SET(CMAKE_CXX_DEFINITIONS_RELWITHDEBINFO CACHE INTERNAL "Internal CMake C++ flags for Release with Debug Info mode do not edit" FORCE)
	SET(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO CACHE INTERNAL "Internal CMake linker flags for Release with Debug Info mode do not edit" FORCE)
	SET(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO CACHE INTERNAL "Internal CMake linker flags for Release with Debug Info mode do not edit" FORCE)
	SET(CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO CACHE INTERNAL "Internal CMake linker flags for Release with Debug Info mode do not edit" FORCE)
ELSEIF(${Build} STREQUAL MinSizeRel)
	SET(CMAKE_C_DEFINITIONS_MINSIZEREL CACHE INTERNAL "Internal CMake C flags for Release minsize mode do not edit" FORCE)
	SET(CMAKE_CXX_DEFINITIONS_MINSIZEREL CACHE INTERNAL "Internal CMake C++ flags for Release minsize mode do not edit" FORCE)
	SET(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL CACHE INTERNAL "Internal CMake linker flags for Release minsize mode do not edit" FORCE)
	SET(CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL CACHE INTERNAL "Internal CMake linker flags for Release minsize mode do not edit" FORCE)
	SET(CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL CACHE INTERNAL "Internal CMake linker flags for Release minsize mode do not edit" FORCE)
ENDIF(${Build} STREQUAL Debug)

endmacro ( WkDisableFlags )
  
macro ( WkCompilerSetup )
    #TODO : setup only needed compiler settings, depending on loaded compilers

	#Default : Multiple-Configuration Generator ( MSVC )
	#Forcing configuration at build time
	SET(CMAKE_CONFIGURATION_TYPES "Debug;Release;" CACHE INTERNAL "Semicolon separated list of supported configuration types in your Build Environment. Do not edit." )
	#message ( "CMAKE_CONFIGURATION_TYPES : ${CMAKE_CONFIGURATION_TYPES} ")
	
	# However special case for Single-Configuration Generator ( make ... )
	if ( NOT MSVC )
		SET(${PROJECT_NAME}_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build, options are: ${CMAKE_CONFIGURATION_TYPES}." )
		
		#Checking if a the required build type is available in configurations list...
		IF( ${PROJECT_NAME}_BUILD_TYPE )
			string ( REGEX MATCH "${${PROJECT_NAME}_BUILD_TYPE}" BUILD_TYPE_MATCH ${CMAKE_CONFIGURATION_TYPES} )
			IF ( NOT BUILD_TYPE_MATCH )
				message ( " ${${PROJECT_NAME}_BUILD_TYPE} is not a possible build type ! Defaulting to Debug . " )
				SET(${PROJECT_NAME}_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build, options are: ${CMAKE_CONFIGURATION_TYPES}." FORCE )
			ENDIF ( NOT BUILD_TYPE_MATCH )
		ELSE( ${PROJECT_NAME}_BUILD_TYPE )
			message ( FATAL_ERROR " ${PROJECT_NAME}_BUILD_TYPE is not defined ! Defaulting to Debug. " )
			SET(${PROJECT_NAME}_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build, options are: ${CMAKE_CONFIGURATION_TYPES}." FORCE )
		ENDIF( ${PROJECT_NAME}_BUILD_TYPE )

		#Forcing configuration at generation time
		SET(CMAKE_BUILD_TYPE "${${PROJECT_NAME}_BUILD_TYPE}" CACHE INTERNAL "Internal CMake Build Type. Do not edit." )
		#message ( "CMAKE_BUILD_TYPE : ${CMAKE_BUILD_TYPE} ")

	endif( NOT MSVC )
	
	
	
	IF(MSVC)
	
		MESSAGE( STATUS "Visual Studio Compiler detected. Adjusting C++ flags...")
		WkSetCFlags ( "" )
		WkSetCXXFlags ( "/wd4100 /wd4290 /wd4512" )
		WkSetExeLinkerFlags ( All "" )
		WkSetSharedLinkerFlags ( All "" )
		WkSetModuleLinkerFlags ( All "" )
		
		WkSetExeLinkerFlags( Debug )
		WkSetSharedLinkerFlags( Debug )
		WkSetModuleLinkerFlags( Debug )
			
		WkSetExeLinkerFlags( Release )
		WkSetSharedLinkerFlags( Release )
		WkSetModuleLinkerFlags( Release )
		
	ELSEIF(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
		
		MESSAGE( STATUS "GNU Compiler detected.")
		
		#IF ( COMMAND gprof )
			SET(${PROJECT_NAME}_PROFILE OFF CACHE BOOL "On to generate profiling information to use with gprof.")
			SET(PROFILE_FLAG)	
			IF(${PROJECT_NAME}_PROFILE)
				SET(PROFILE_FLAG -pg)
			ENDIF(${PROJECT_NAME}_PROFILE)
		#ENDIF ( COMMAND gprof )

		WkSetCFlags ( "${PROFILE_FLAG} -Wall " )
		WkAddCDefinitions ( Debug "_DEBUG" )
		WkAddCDefinitions ( Release "" )
		WkSetCXXFlags ( "${PROFILE_FLAG} -Wall -Wabi " )
		WkAddCXXDefinitions ( Debug "_DEBUG" )
		WkAddCXXDefinitions ( Release "" )

		IF (MSYS)
			WkSetExeLinkerFlags( All -Wl,--warn-once )
			WkSetSharedLinkerFlags( All -Wl,--warn-once )
			WkSetModuleLinkerFlags( All -Wl,--warn-once )
		ELSE (MSYS)
			WkSetExeLinkerFlags( All -Wl,--warn-unresolved-symbols )
			WkSetSharedLinkerFlags( All -Wl,--warn-unresolved-symbols )
			WkSetModuleLinkerFlags( All -Wl,--warn-unresolved-symbols )
		ENDIF (MSYS)

		WkSetExeLinkerFlags( Debug )
		WkSetSharedLinkerFlags( Debug )
		WkSetModuleLinkerFlags( Debug )
			
		WkSetExeLinkerFlags( Release )
		WkSetSharedLinkerFlags( Release )
		WkSetModuleLinkerFlags( Release )
		
	ENDIF(MSVC)

#per build mode section
	IF (CMAKE_BUILD_TYPE STREQUAL Debug)
		IF(MSVC)			
			SET(CMAKE_CXX_WARNING_LEVEL 4)
		ENDIF(MSVC)
		IF(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
			IF(CMAKE_COMPILER_IS_GNUCC)
			ENDIF(CMAKE_COMPILER_IS_GNUCC)
			IF(CMAKE_COMPILER_IS_GNUCXX)
			ENDIF(CMAKE_COMPILER_IS_GNUCXX)			
		ENDIF(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
	ELSEIF (CMAKE_BUILD_TYPE STREQUAL Release)
		IF(MSVC)
			SET(CMAKE_CXX_WARNING_LEVEL 2)
		ENDIF(MSVC)
		IF(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
			IF(CMAKE_COMPILER_IS_GNUCC)
			ENDIF(CMAKE_COMPILER_IS_GNUCC)
			IF(CMAKE_COMPILER_IS_GNUCXX)
			ENDIF(CMAKE_COMPILER_IS_GNUCXX)			
		ENDIF(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
	ENDIF (CMAKE_BUILD_TYPE STREQUAL Debug)

endmacro ( WkCompilerSetup )


