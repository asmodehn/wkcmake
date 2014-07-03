# 
# Copyright (c) 2009-2014, Asmodehn's Corp.
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
message ( STATUS "== Loading WkBuild.cmake ..." )

if ( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.8 )
	message ( FATAL_ERROR " CMAKE MINIMUM BACKWARD COMPATIBILITY REQUIRED : 2.8 !" )
endif( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.8 )

#test to make sure necessary variables have been set.

if ( NOT WKCMAKE_DIR ) 
	message( FATAL_ERROR "You need to include WkCMake.cmake in your CMakeLists.txt, and call WkCMakeDir(<path_to WkCMake scripts> )" )
endif ( NOT WKCMAKE_DIR ) 

# using useful Macros
include ( "${WKCMAKE_DIR}/WkUtils.cmake" )

# To detect the Platform
include ( "${WKCMAKE_DIR}/WkPlatform.cmake")

#To setup the compiler
include ( "${WKCMAKE_DIR}/WkCompilerSetup.cmake" )


macro(WkIncludeDir dir)
	if (${PROJECT_NAME} STREQUAL "Project")
		message(FATAL_ERROR "WkIncludeDir() has to be called after WkProject()")
	else ()
		set ( ${PROJECT_NAME}_INCLUDE_DIR ${dir} CACHE PATH "Headers directory for autodetection by WkCMake for ${PROJECT_NAME}" )
		mark_as_advanced ( ${PROJECT_NAME}_INCLUDE_DIR )
	endif()
endmacro(WkIncludeDir dir)

macro(WkSrcDir dir)
	message (AUTHOR_WARNING "WkSrcDir is deprecated since multi target support has been added. You can now specify the source directory directly when calling WkLibraryBuild() or WkExecutableBuild().")
	if (${PROJECT_NAME} STREQUAL "Project")
		message(FATAL_ERROR "WkSrcDir has to be called after WkProject")
	else ()
		set ( ${PROJECT_NAME}_SRC_DIR ${dir} CACHE PATH "Sources directory for autodetection by WkCMake for ${PROJECT_NAME}" )
		mark_as_advanced ( ${PROJECT_NAME}_SRC_DIR )
	endif()
endmacro(WkSrcDir dir)

macro(WkBinDir dir)
	if (${PROJECT_NAME} STREQUAL "Project")
		message(FATAL_ERROR "WkBinDir needs to be called after WkProject")
	else ()
		set ( ${PROJECT_NAME}_BIN_DIR ${dir} CACHE PATH "Binary directory for WkCMake build products for ${PROJECT_NAME}" )
		mark_as_advanced ( ${PROJECT_NAME}_BIN_DIR )
	endif()
endmacro(WkBinDir dir)

macro(WkLibDir dir)
	if (${PROJECT_NAME} STREQUAL "Project")
		message(FATAL_ERROR "WkLibDir needs to be called after WkProject")
	else ()
		set ( ${PROJECT_NAME}_LIB_DIR ${dir} CACHE PATH "Library directory for WkCMake build products for ${PROJECT_NAME}" )
		mark_as_advanced ( ${PROJECT_NAME}_LIB_DIR )
	endif()
endmacro(WkLibDir dir)

macro(WkDataDir dir)
	if (${PROJECT_NAME} STREQUAL "Project")
		message(FATAL_ERROR "WkDataDir needs to be called after WkProject")
	else ()
		set ( ${PROJECT_NAME}_DATA_DIR ${dir} CACHE PATH "Data directory for WkCMake build products for ${PROJECT_NAME}" )
		mark_as_advanced ( ${PROJECT_NAME}_DATA_DIR )
	endif()
endmacro(WkDataDir dir)


macro(WkProject project_name_arg)
CMAKE_POLICY(PUSH)
CMAKE_POLICY(VERSION 2.6)
	project(${project_name_arg} ${ARGN})
	
	#if a version has been defined we put it in cache
	if ( ${PROJECT_NAME}_VERSION )
		set( ${PROJECT_NAME}_VERSION ${${PROJECT_NAME}_VERSION} CACHE STRING "Version for ${PROJECT_NAME}")
	endif ( ${PROJECT_NAME}_VERSION )
	
	#To add this project as a source dependency to a master project
	if ( NOT ${PROJECT_NAME} STREQUAL ${CMAKE_PROJECT_NAME} )
		set (${CMAKE_PROJECT_NAME}_SRCDEPENDS ${${CMAKE_PROJECT_NAME}_SRCDEPENDS} ${PROJECT_NAME} PARENT_SCOPE) 
		# NOT IN CACHE because it needs to change everytime. no change ( as with cache ) means error ( not a wkcmake dependency )
		# IN PARENT SCOPE, so a call to add_subdirectory can retrieve it
	endif()
	
	message(STATUS "= Configuring ${PROJECT_NAME}")
	#TODO : check what happens if we have hierarchy of subdirectories with wkcmake projects
	SET(${PROJECT_NAME}_CXX_COMPILER_LOADED "${CMAKE_CXX_COMPILER_LOADED}" CACHE INTERNAL "Whether C++ compiler has been loaded for the project or not" FORCE)
	#TODO : make sure this doesnt get the C of CXX
	SET(${PROJECT_NAME}_C_COMPILER_LOADED "${CMAKE_C_COMPILER_LOADED}" CACHE INTERNAL "Whether C compiler has been loaded for the project or not" FORCE)
		
	WkPlatformCheck()

	#TODO
	#Quick test to make sure we build in different directory
	#if ( ${PROJECT_SOURCE_DIR} STREQUAL ${PROJECT_BINARY_DIR} )
	#	SET(PROJECT_BINARY_DIR "${PROJECT_BINARY_DIR}/build" )
	#endif ( ${PROJECT_SOURCE_DIR} STREQUAL ${PROJECT_BINARY_DIR} )
CMAKE_POLICY(POP)
endmacro(WkProject PROJECT_NAME)



#
# Generate a config file for the project.
# GenConfig( target1 [ target2 [...]] )
# Automatically called during WkBuild
#

macro ( WkGenConfig target_name)
	CMAKE_POLICY(PUSH)
	CMAKE_POLICY(VERSION 2.6)

	#Exporting targets
	export(TARGETS ${target_name} ${ARGN} FILE ${PROJECT_NAME}Export.cmake)
	
	#Generating config file
	file( WRITE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake "### Config file for ${PROJECT_NAME} auto generated by WkCmake ###

### First section : Main target ###
IF(\${CMAKE_MAJOR_VERSION}.\${CMAKE_MINOR_VERSION} LESS 2.5)
   MESSAGE(FATAL_ERROR \"CMake >= 2.6.0 required\")
ENDIF(\${CMAKE_MAJOR_VERSION}.\${CMAKE_MINOR_VERSION} LESS 2.5)
CMAKE_POLICY(PUSH)
CMAKE_POLICY(VERSION 2.6)
	
get_filename_component(SELF_DIR \"\${CMAKE_CURRENT_LIST_FILE}\" PATH)
#all required target should be defined there... no need to specify all targets in ${PROJECT_NAME}_LIBRARIES, they will be linked automatically
include(\${SELF_DIR}/${PROJECT_NAME}Export.cmake)
get_filename_component(${PROJECT_NAME}_INCLUDE_DIR \"\${SELF_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/\" ABSOLUTE)
set(${PROJECT_NAME}_INCLUDE_DIRS \"\${SELF_DIR}/CMakeFiles\" )
	")
	
	file( APPEND ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake "
#however we still want to have ${PROJECT_NAME}_LIBRARIES available
set(${PROJECT_NAME}_LIBRARY ${${PROJECT_NAME}_LIBRARY} )
set(${PROJECT_NAME}_LIBRARIES \"\${${PROJECT_NAME}_LIBRARY}\")
	" )
	
	file( APPEND ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake "
set(${PROJECT_NAME}_FOUND TRUE)
	")	
	
	CMAKE_POLICY(POP)
endmacro ( WkGenConfig )

#
# WkFinConfig () finalizes the configuration file, by
# creating the necessary lines in the config file for detection by other projects.
#
macro(WkFinConfig )
	CMAKE_POLICY(PUSH)
	CMAKE_POLICY(VERSION 2.6)

	file( APPEND ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake "
#Includes for project after dependencies' includes
set(${PROJECT_NAME}_INCLUDE_DIRS \"\${${PROJECT_NAME}_INCLUDE_DIRS}\" \"\${${PROJECT_NAME}_INCLUDE_DIR}\" )

#Displaying detected dependencies in interface, and storing in cache
set(${PROJECT_NAME}_INCLUDE_DIRS \"\${${PROJECT_NAME}_INCLUDE_DIRS}\" CACHE PATH \"${PROJECT_NAME} Headers\" )
set(${PROJECT_NAME}_LIBRARIES \"\${${PROJECT_NAME}_LIBRARIES}\" CACHE FILEPATH \"${PROJECT_NAME} Libraries\")

CMAKE_POLICY(POP)
	
	")

	CMAKE_POLICY(POP)
endmacro(WkFinConfig )


#
# Configure and Build process based on well-known hierarchy
# You need include and src in your hierarchy at least for this to work correctly
#

#WkBuild( EXECUTABLE | LIBRARY [ STATIC|SHARED|MODULE ] [source_dir] )

macro (WkBuild project_type)
CMAKE_POLICY(PUSH)
CMAKE_POLICY(VERSION 2.6)

	message(AUTHOR_WARNING "WkBuild is deprecated. Please use WkLibraryBuild or WkExecutableBuild instead.")

	#To keep backward compatible default
	if (NOT ${PROJECT_NAME}_SRC_DIR)
		set(${PROJECT_NAME}_SRC_DIR "src" )
	endif (NOT ${PROJECT_NAME}_SRC_DIR)

	if ( ${project_type} STREQUAL EXECUTABLE )
		if ( ${ARGC} GREATER 1 AND EXISTS "${ARGV1}" AND IS_DIRECTORY "${ARGV1}" )
			if (${PROJECT_NAME}_SRC_DIR)
				message(WARNING "${ARGV1} will override ${${PROJECT_NAME}_SRC_DIR} as source directory for ${PROJECT_NAME}")
			endif(${PROJECT_NAME}_SRC_DIR)
			set(${PROJECT_NAME}_SRC_DIR ${ARGV1} )
		endif ( ${ARGC} GREATER 1 AND EXISTS "${ARGV1}" AND IS_DIRECTORY "${ARGV1}" )
		message(STATUS "Using Source directory : ${${PROJECT_NAME}_SRC_DIR} ")
		WkExecutableBuild(${PROJECT_NAME} ${${PROJECT_NAME}_SRC_DIR})
	elseif ( ${project_type} STREQUAL LIBRARY )
		if ( ${ARGC} GREATER 1 )
			if ( ${ARGV1} STREQUAL STATIC OR ${ARGV1} STREQUAL SHARED OR ${ARGV1} STREQUAL MODULE )
				set(${PROJECT_NAME}_load_type ${ARGV1} )
				if ( ${ARGC} GREATER 2)
					if( EXISTS "${ARGV2}" AND IS_DIRECTORY "${ARGV2}" )
						if (${PROJECT_NAME}_SRC_DIR)
							message(WARNING "${ARGV2} will override ${${PROJECT_NAME}_SRC_DIR} as source directory for ${PROJECT_NAME}")
						endif(${PROJECT_NAME}_SRC_DIR)
						set(${PROJECT_NAME}_SRC_DIR ${ARGV2} )
					endif( EXISTS "${ARGV2}" AND IS_DIRECTORY "${ARGV2}" )
				endif()
			elseif ( EXISTS "${ARGV1}" AND IS_DIRECTORY "${ARGV1}" )
				if (${PROJECT_NAME}_SRC_DIR)
					message(WARNING "${ARGV1} will override ${${PROJECT_NAME}_SRC_DIR} as source directory for ${PROJECT_NAME}")
				endif(${PROJECT_NAME}_SRC_DIR)
				set(${PROJECT_NAME}_SRC_DIR ${ARGV1} )
			endif ()
		endif ( ${ARGC} GREATER 1 )
		message(STATUS "Using Source directory : ${${PROJECT_NAME}_SRC_DIR} ")
		WkLibraryBuild(${PROJECT_NAME} ${${PROJECT_NAME}_load_type} ${${PROJECT_NAME}_SRC_DIR})
	else()
		message(FATAL_ERROR "WkBuild called with project_type = ${project_type}. It can be either EXECUTABLE or LIBRARY.")
	endif()

	WkExportConfig( ${PROJECT_NAME} )

CMAKE_POLICY(POP)
endmacro (WkBuild)

#WkLibraryBuild generates a library target for the current project.
#with same Language as Project and implicit dependency as the main build target
# and also with same doc, tests, etc.
# only source files and include directories are different
# WkLibraryBuild ( target_name [STATIC|SHARED|MODULE] source_dir )
macro (WkLibraryBuild target_name )
CMAKE_POLICY(PUSH)
CMAKE_POLICY(VERSION 2.6)

	#to be able to include() from another directory
	if ( NOT CMAKE_MODULE_PATH )
		set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" "${CMAKE_SOURCE_DIR}/${${PROJECT_NAME}_DIR}/Modules/")
	endif ( NOT CMAKE_MODULE_PATH )

	#adding WKCMAKE_SHARED_LIBS option
	option(WKCMAKE_SHARED_LIBS "Set this to ON to build shared libraries by default" off)

	#parsing extra arguments
	if ( ${ARGC} GREATER 1 )
		if ( NOT ${ARGV1} STREQUAL "STATIC"
		     AND NOT ${ARGV1} STREQUAL "SHARED"
		     AND NOT ${ARGV1} STREQUAL "MODULE"
		)
			#assuming it s the source dir
			set(${PROJECT_NAME}_${target_name}_SRC_DIR ${ARGV1} )
			if( WKCMAKE_SHARED_LIBS )
				set(${PROJECT_NAME}_${target_name}_load_type "SHARED")
			else( WKCMAKE_SHARED_LIBS )
				set(${PROJECT_NAME}_${target_name}_load_type "STATIC")
			endif( WKCMAKE_SHARED_LIBS )
		else()
			set(${PROJECT_NAME}_${target_name}_load_type ${ARGV1} )
			if ( ${ARGC} GREATER 2 )
				set(${PROJECT_NAME}_${target_name}_SRC_DIR ${ARGV2} )
			endif ( ${ARGC} GREATER 2 )
		endif()
	endif ( ${ARGC} GREATER 1 )

	message ( STATUS "== Configuring ${target_name} as LIBRARY ${${PROJECT_NAME}_${target_name}_load_type}" )	

	#Setting up project structure defaults for directories
	# Note that if these have been already defined with the same macros, the calls here wont have any effect ( wont changed cached value )
	WkIncludeDir("include")
	WkLibDir("lib")
	WkDataDir("data")

	#Doing compiler setup in Build step, because :
	# - it is related to target, not overall project ( even if environment is same for cmake, settings can be different for each target )
	# - custom build options may have been defined before ( and will be used instead of defaults )
	WkCompilerSetup()

	#configuration depending on build type
	WkBuildTypeConfig()

	#globbing source files
	message ( STATUS "== Gathering source files for ${PROJECT_NAME}_${target_name} in ${${PROJECT_NAME}_INCLUDE_DIR}/${target_name} and ${${PROJECT_NAME}_${target_name}_SRC_DIR}..." )
	
	FILE(GLOB_RECURSE ${PROJECT_NAME}_${target_name}_HEADERS RELATIVE "${PROJECT_SOURCE_DIR}"
		${${PROJECT_NAME}_INCLUDE_DIR}/${target_name}/*.h 
		${${PROJECT_NAME}_INCLUDE_DIR}/${target_name}/*.hh 
		${${PROJECT_NAME}_INCLUDE_DIR}/${target_name}/*.hpp 
		${${PROJECT_NAME}_${target_name}_SRC_DIR}/*.h 
		${${PROJECT_NAME}_${target_name}_SRC_DIR}/*.hh 
		${${PROJECT_NAME}_${target_name}_SRC_DIR}/*.hpp
	)
	#putting them in source groups. Very useful for VS.
	if(WIN32)
		foreach( header ${${PROJECT_NAME}_${target_name}_HEADERS} )
			get_filename_component(folder ${header} DIRECTORY)
			string(REPLACE "/" "\\" folder ${folder})
			SOURCE_GROUP("${folder}" FILES ${header})
		endforeach(header)
	endif(WIN32)
	
	FILE(GLOB_RECURSE ${PROJECT_NAME}_${target_name}_SOURCES RELATIVE "${PROJECT_SOURCE_DIR}"
		${${PROJECT_NAME}_${target_name}_SRC_DIR}/*.c
		${${PROJECT_NAME}_${target_name}_SRC_DIR}/*.cpp
		${${PROJECT_NAME}_${target_name}_SRC_DIR}/*.cc
	)
	#putting them in source groups. Very useful for VS.
	if(WIN32)
		foreach( source ${${PROJECT_NAME}_${target_name}_SOURCES} )
			get_filename_component(folder ${source} DIRECTORY)
			string(REPLACE "/" "\\" folder ${folder})
			SOURCE_GROUP("${folder}" FILES ${source})
		endforeach(source)
	endif(WIN32)
	
	message ( STATUS "== Headers detected in ${${PROJECT_NAME}_INCLUDE_DIR}/${target_name} and ${${PROJECT_NAME}_${target_name}_SRC_DIR} : ${${PROJECT_NAME}_${target_name}_HEADERS}" )
	message ( STATUS "== Sources detected in ${${PROJECT_NAME}_${target_name}_SRC_DIR} : ${${PROJECT_NAME}_${target_name}_SOURCES}" )

	# to show we are using WkCMake to build ( can be #ifdef in header )
	add_definitions( -D WK_BUILD )

	#Setting precompile header
	if(${PROJECT_NAME}_PCH)
		#hardcode precompiled header name
		#set variable when creating the option
		message ( STATUS "== Preparing ${target_name} for Precompiled header." )	
	    #GET_FILENAME_COMPONENT(PrecompiledBasename ${PrecompiledHeader} NAME_WE)
		#SET(PrecompiledBinary "${CMAKE_CURRENT_BINARY_DIR}/${PrecompiledBasename}.pch")
		SET(PrecompiledBinary "${CMAKE_CURRENT_BINARY_DIR}/stdafx.pch")
		SET(Sources ${${SourcesVar}})

		foreach(f ${${PROJECT_NAME}_${target_name}_SOURCES})
			string(FIND ${f} "stdafx.cpp" isPCH)
			string(FIND ${f} ".cpp" isUsingPCH)
			if(isPCH GREATER -1)
				SET_SOURCE_FILES_PROPERTIES(${f}
											PROPERTIES COMPILE_FLAGS "/Yc\"${PrecompiledHeader}\" /Fp\"${PrecompiledBinary}\""
													   OBJECT_OUTPUTS "${PrecompiledBinary}") 
			elseif(isUsingPCH GREATER -1)
				SET_SOURCE_FILES_PROPERTIES(${f}
											PROPERTIES COMPILE_FLAGS "/Yu\"${PrecompiledBinary}\" /FI\"${PrecompiledBinary}\" /Fp\"${PrecompiledBinary}\""
										   OBJECT_DEPENDS "${PrecompiledBinary}") 
			endif()
		endforeach(f)
	else()
		message ( STATUS "== Not using Precompiled header." )
	endif()
	
	#TODO : find a simpler way than this complex merge...
	MERGE("${${PROJECT_NAME}_${target_name}_HEADERS}" "${${PROJECT_NAME}_${target_name}_SOURCES}" ${PROJECT_NAME}_${target_name}_ALL_SOURCES)
	#MESSAGE ( STATUS "== ${target_name} Sources : ${${target_name}_ALL_SOURCES}" )
	
	AddPlatformCheckSrc(${PROJECT_NAME}_${target_name}_ALL_SOURCES)

	#Setting up AStyle target
	WkTargetFormat(${target_name} ${${PROJECT_NAME}_${target_name}_ALL_SOURCES})
	
	#internal headers ( non visible by outside project )
	include_directories("${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_${target_name}_SRC_DIR}")
	
	#Including configured headers (
	#	-binary_dir/CMakeFiles for the configured header, 
	#	-source_dir/include for the unmodified ones, 
	include_directories("${PROJECT_BINARY_DIR}/CMakeFiles" "${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}" )

	add_library(${target_name} ${${PROJECT_NAME}_${target_name}_load_type} ${${PROJECT_NAME}_${target_name}_ALL_SOURCES})

	#defining where to put what has been built
	SET(${PROJECT_NAME}_LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_LIB_DIR} CACHE PATH "Ouput directory for ${PROJECT_NAME} libraries." )
	mark_as_advanced(FORCE ${PROJECT_NAME}_LIBRARY_OUTPUT_PATH)
	SET(LIBRARY_OUTPUT_PATH "${${PROJECT_NAME}_LIBRARY_OUTPUT_PATH}" CACHE INTERNAL "Internal CMake libraries output directory. Do not edit." FORCE)
	
	# adding dependencies for cppcheck ( and format ) targets
	WkTargetCppCheck(${PROJECT_NAME})

	#storing a variable for top project to be able to link it
	if ( ${PROJECT_NAME}_LIBRARY AND NOT "${${PROJECT_NAME}_LIBRARY}" STREQUAL "")
		LIST(FIND ${PROJECT_NAME}_LIBRARY ${target_name} already_stored)
		IF( already_stored LESS 0)
			set(${PROJECT_NAME}_LIBRARY ${${PROJECT_NAME}_LIBRARY} ${target_name} CACHE FILEPATH "${PROJECT_NAME} ${target_name} Library" FORCE)
		ENDIF( already_stored LESS 0)
	else()
		set(${PROJECT_NAME}_LIBRARY "${target_name}" CACHE FILEPATH "${PROJECT_NAME} ${target_name} Library")
	endif()

	if ( EXISTS ${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/${target_name} )
		ADD_CUSTOM_COMMAND( 
			TARGET ${target_name}
			POST_BUILD COMMAND ${CMAKE_COMMAND} ARGS -E copy_directory
			"${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/${target_name}" "${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/${target_name}"
			COMMENT
			"Copying ${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/${target_name} to ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/${target_name}" 
		)
	else()
		message ( WARNING "Directory ${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/${target_name} NOT FOUND ! Headers for ${target_name} cannot be copied !" )
	endif()

	#generating configured Header for detected packages and lib export definition
	WkPlatformConfigure()
	
	WkTargetSetProperties (${target_name})

	#
	# Copying data directory during configure
	#
	if (EXISTS "${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_DATA_DIR}")
		file(COPY "${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_DATA_DIR}" DESTINATION "${PROJECT_BINARY_DIR}")
	endif()

CMAKE_POLICY(POP)
endmacro(WkLibraryBuild)

#WkLibraryBuild generates a library target for the current project.
#with same Language as Project and implicit dependency as the main build target
# and also with same doc, tests, etc.
# only source files and include directories are different
# WkExecutableBuild ( target_name source_dir )
macro (WkExecutableBuild target_name source_dir )
CMAKE_POLICY(PUSH)
CMAKE_POLICY(VERSION 2.6)

	#to be able to include() from another directory
	if ( NOT CMAKE_MODULE_PATH )
		set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" "${CMAKE_SOURCE_DIR}/${${PROJECT_NAME}_DIR}/Modules/")
	endif ( NOT CMAKE_MODULE_PATH )

	#parsing extra arguments
	set ( ${PROJECT_NAME}_${target_name}_SRC_DIR ${source_dir} CACHE PATH "Sources directory for ${PROJECT_NAME} ${target_name} " )

	#Setting up project structure defaults for directories
	# Note that if these have been already defined with the same macros, the calls here wont have any effect ( wont changed cached value )
	WkIncludeDir("include")
	WkBinDir("bin")
	WkDataDir("data")

	#Doing compiler setup in Build step, because :
	# - it is related to target, not overall project ( even if environment is same for cmake, settings can be different for each target )
	# - custom build options may have been defined before ( and will be used instead of defaults )
	WkCompilerSetup()

	#configuration depending on build type
	WkBuildTypeConfig()

	#globbing source files
	message ( STATUS "== Gathering source files for ${target_name} in ${${PROJECT_NAME}_INCLUDE_DIR}/${target_name} and ${${PROJECT_NAME}_INCLUDE_DIR} and ${${target_name}_SRC_DIR}..." )
	
	FILE(GLOB_RECURSE ${PROJECT_NAME}_${target_name}_HEADERS RELATIVE "${PROJECT_SOURCE_DIR}"
		${${PROJECT_NAME}_INCLUDE_DIR}/${target_name}/*.h 
		${${PROJECT_NAME}_INCLUDE_DIR}/${target_name}/*.hh 
		${${PROJECT_NAME}_INCLUDE_DIR}/${target_name}/*.hpp 
		${${PROJECT_NAME}_INCLUDE_DIR}/*.h 
		${${PROJECT_NAME}_INCLUDE_DIR}/*.hh 
		${${PROJECT_NAME}_INCLUDE_DIR}/*.hpp 
		${${PROJECT_NAME}_${target_name}_SRC_DIR}/*.h 
		${${PROJECT_NAME}_${target_name}_SRC_DIR}/*.hh 
		${${PROJECT_NAME}_${target_name}_SRC_DIR}/*.hpp
	)
	FILE(GLOB_RECURSE ${PROJECT_NAME}_${target_name}_SOURCES RELATIVE "${PROJECT_SOURCE_DIR}"
		${${PROJECT_NAME}_${target_name}_SRC_DIR}/*.c
		${${PROJECT_NAME}_${target_name}_SRC_DIR}/*.cpp
		${${PROJECT_NAME}_${target_name}_SRC_DIR}/*.cc
	)
	message ( STATUS "== Headers detected in ${${PROJECT_NAME}_INCLUDE_DIR}/${target_name} and ${${PROJECT_NAME}_${target_name}_SRC_DIR} : ${${PROJECT_NAME}_${target_name}_HEADERS}" )
	message ( STATUS "== Sources detected in ${${PROJECT_NAME}_${target_name}_SRC_DIR} : ${${PROJECT_NAME}_${target_name}_SOURCES}" )

	# to show we are using WkCMake to build ( can be #ifdef in header )
	add_definitions( -D WK_BUILD )

	#TODO : find a simpler way than this complex merge...
	MERGE("${${PROJECT_NAME}_${target_name}_HEADERS}" "${${PROJECT_NAME}_${target_name}_SOURCES}" ${PROJECT_NAME}_${target_name}_ALL_SOURCES)
	#MESSAGE ( STATUS "== ${PROJECT_NAME} Sources : ${SOURCES}" )
	
	AddPlatformCheckSrc(${PROJECT_NAME}_${target_name}_ALL_SOURCES)

	#Setting up AStyle target
	WkTargetFormat(${target_name} ${${PROJECT_NAME}_${target_name}_ALL_SOURCES})

	#internal headers ( non visible by outside project )
	include_directories("${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_${target_name}_SRC_DIR}")
	
	#Including configured headers (
	#	-binary_dir/CMakeFiles for the configured header, 
	#	-source_dir/include for the unmodified ones, 
	include_directories("${PROJECT_BINARY_DIR}/CMakeFiles" "${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}" )

	add_executable(${target_name} ${${PROJECT_NAME}_${target_name}_ALL_SOURCES})

	SET(${PROJECT_NAME}_RUNTIME_OUTPUT_PATH ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_BIN_DIR} CACHE PATH "Ouput directory for ${PROJECT_NAME} executables." )
	mark_as_advanced(FORCE ${PROJECT_NAME}_RUNTIME_OUTPUT_PATH)
	SET(RUNTIME_OUTPUT_PATH "${${PROJECT_NAME}_RUNTIME_OUTPUT_PATH}" CACHE INTERNAL "Internal CMake executables output directory. Do not edit." FORCE)

	# adding dependencies for cppcheck ( and format ) targets
	WkTargetCppCheck(${PROJECT_NAME})

	#This is not needed for executable, unless ENABLE_EXPORTS is set
	get_target_property(export_enabled ${target_name} ENABLE_EXPORTS)
	if ( export_enabled )
		#storing a variable for top project to be able to link it
		if ( ${PROJECT_NAME}_LIBRARY AND NOT "${${PROJECT_NAME}_LIBRARY}" STREQUAL "")
			LIST(FIND ${PROJECT_NAME}_LIBRARY ${target_name} already_stored)
			IF( already_stored LESS 0)
				set(${PROJECT_NAME}_LIBRARY ${${PROJECT_NAME}_LIBRARY} ${target_name} CACHE FILEPATH "${PROJECT_NAME} ${target_name} Library" FORCE)
			ENDIF( already_stored LESS 0)
		else()
			set(${PROJECT_NAME}_LIBRARY "${target_name}" CACHE FILEPATH "${PROJECT_NAME} ${target_name} Library")
		endif()
	endif()

	if ( EXISTS ${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/${target_name} )
		ADD_CUSTOM_COMMAND( 
			TARGET ${target_name}
			POST_BUILD COMMAND ${CMAKE_COMMAND} ARGS -E copy_directory
			"${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/${target_name}" "${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/${target_name}"
			COMMENT
			"Copying ${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/${target_name} to ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/${target_name}" 
		)
	else()
		message ( WARNING "Directory ${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/${target_name} NOT FOUND !" )
		message ( WARNING "Headers for ${target_name} cannot be copied !" )
	endif()

	WkTargetSetProperties (${target_name})

	#generating configured Header for detected packages and lib export definition
	WkPlatformConfigure()
	
	#
	# Copying data directory during configure
	#
	if (EXISTS "${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_DATA_DIR}")
		file(COPY "${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_DATA_DIR}" DESTINATION "${PROJECT_BINARY_DIR}")
	endif()

CMAKE_POLICY(POP)
endmacro(WkExecutableBuild)

macro (WkBuildTypeConfig)

	#Verbose Makefile if not release build. Making them internal not to confuse user by appearing with values used only for one project.
	if ( ${PROJECT_NAME}_BUILD_TYPE )
	if (${${PROJECT_NAME}_BUILD_TYPE} STREQUAL Release)
		set(CMAKE_VERBOSE_MAKEFILE OFF CACHE INTERNAL "Verbose build commands disabled for Release build." FORCE)
		set(CMAKE_USE_RELATIVE_PATHS OFF CACHE INTERNAL "Absolute paths used in makefiles and projects for Release build." FORCE)
	else (${${PROJECT_NAME}_BUILD_TYPE} STREQUAL Release)
		message( STATUS "== Non Release build detected : enabling verbose makefile" )
		# To get the actual commands used
		set(CMAKE_VERBOSE_MAKEFILE ON CACHE INTERNAL "Verbose build commands enabled for Non Release build." FORCE)
		#VLD
		set(WKCMAKE_CHECK_MEMORY OFF CACHE BOOL "On to check memory with VLD (must be installed)")
		if(WKCMAKE_CHECK_MEMORY)
			add_definitions(-DVLD)
		endif(WKCMAKE_CHECK_MEMORY)
	endif (${${PROJECT_NAME}_BUILD_TYPE} STREQUAL Release)
	endif ( ${PROJECT_NAME}_BUILD_TYPE )

endmacro (WkBuildTypeConfig)


macro (WkTargetSetProperties target_name )
	#setting target properties
	#Need to match WkCompilerSetup content
	#message(STATUS "${PROJECT_NAME}_C_COMPILER_LOADED ${${PROJECT_NAME}_C_COMPILER_LOADED}")
	if ( ${PROJECT_NAME}_C_COMPILER_LOADED )
		#putting value computed previously in cache
		#message(STATUS "${PROJECT_NAME}_C_DEFINITIONS_DEBUG ${${PROJECT_NAME}_C_DEFINITIONS_DEBUG}")
		SET(${PROJECT_NAME}_C_DEFINITIONS_DEBUG "${${PROJECT_NAME}_C_DEFINITIONS_DEBUG}" CACHE STRING " ${PROJECT_NAME} Flags used by the C compiler during debug builds." )
		MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_C_DEFINITIONS_DEBUG )
		SET(${PROJECT_NAME}_C_DEFINITIONS_RELEASE "${${PROJECT_NAME}_C_DEFINITIONS_RELEASE}" CACHE STRING " ${PROJECT_NAME} Flags used by the C compiler during release builds.")
		MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_C_DEFINITIONS_RELEASE )

		#setting target property
		set_target_properties( ${target_name} PROPERTIES COMPILE_FLAGS "${${PROJECT_NAME}_C_FLAGS}")
		#IF(WIN32)
		#	set_property( TARGET ${target_name} APPEND PROPERTY COMPILE_DEFINITIONS $<$<CONFIG:Debug>:${PROJECT_NAME}_C_DEFINITIONS_DEBUG> )
		#	set_property( TARGET ${target_name} APPEND PROPERTY COMPILE_DEFINITIONS $<$<CONFIG:Release>:${PROJECT_NAME}_C_DEFINITIONS_RELEASE> )
		#ELSE() #buggy cmake 3.0
			set_property( TARGET ${target_name} APPEND PROPERTY COMPILE_DEFINITIONS $<$<CONFIG:Debug>:${${PROJECT_NAME}_C_DEFINITIONS_DEBUG}> )
			set_property( TARGET ${target_name} APPEND PROPERTY COMPILE_DEFINITIONS $<$<CONFIG:Release>:${${PROJECT_NAME}_C_DEFINITIONS_RELEASE}> )
		#ENDIF()
	endif()
	#message(STATUS "${PROJECT_NAME}_CXX_COMPILER_LOADED ${${PROJECT_NAME}_CXX_COMPILER_LOADED}")
	if ( ${PROJECT_NAME}_CXX_COMPILER_LOADED )

		#putting value computed previously in cache
		#message(STATUS "${PROJECT_NAME}_CXX_DEFINITIONS_DEBUG ${${PROJECT_NAME}_CXX_DEFINITIONS_DEBUG}")
		SET(${PROJECT_NAME}_CXX_DEFINITIONS_DEBUG "${${PROJECT_NAME}_CXX_DEFINITIONS_DEBUG}" CACHE STRING " ${PROJECT_NAME} Flags used by the C++ compiler during debug builds.")
		MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_CXX_DEFINITIONS_DEBUG )
		SET(${PROJECT_NAME}_CXX_DEFINITIONS_RELEASE "${${PROJECT_NAME}_CXX_DEFINITIONS_RELEASE}" CACHE STRING " ${PROJECT_NAME} Flags used by the C++ compiler during release builds.")
		MARK_AS_ADVANCED(FORCE ${PROJECT_NAME}_CXX_DEFINITIONS_RELEASE )

		#setting target property
		set_target_properties( ${target_name} PROPERTIES COMPILE_FLAGS "${${PROJECT_NAME}_CXX_FLAGS}")
		#if (WIN32)
		#	set_property( TARGET ${target_name} APPEND PROPERTY COMPILE_DEFINITIONS $<$<CONFIG:Debug>:${PROJECT_NAME}_CXX_DEFINITIONS_DEBUG> )
		#	set_property( TARGET ${target_name} APPEND PROPERTY COMPILE_DEFINITIONS $<$<CONFIG:Release>:${PROJECT_NAME}_CXX_DEFINITIONS_RELEASE> )
		#else() # buggy cmake 3
			set_property( TARGET ${target_name} APPEND PROPERTY COMPILE_DEFINITIONS $<$<CONFIG:Debug>:${${PROJECT_NAME}_CXX_DEFINITIONS_DEBUG}> )
			set_property( TARGET ${target_name} APPEND PROPERTY COMPILE_DEFINITIONS $<$<CONFIG:Release>:${${PROJECT_NAME}_CXX_DEFINITIONS_RELEASE}> )
		#endif()
	endif()

	get_target_property(${PROJECT_NAME}_${target_name}_TYPE ${target_name} TYPE)
	if ( ${PROJECT_NAME}_${target_name}_TYPE STREQUAL "SHARED_LIBRARY" )
		set_target_properties( ${target_name} PROPERTIES LINK_FLAGS "${${PROJECT_NAME}_SHARED_LINKER_FLAGS}" )
		set_target_properties( ${target_name} PROPERTIES LINK_FLAGS_DEBUG "${${PROJECT_NAME}_SHARED_LINKER_FLAGS_DEBUG}" )
		set_target_properties( ${target_name} PROPERTIES LINK_FLAGS_RELEASE "${${PROJECT_NAME}_SHARED_LINKER_FLAGS_RELEASE}" )
	elseif( ${PROJECT_NAME}_${target_name}_TYPE STREQUAL "MODULE_LIBRARY" )
		set_target_properties( ${target_name} PROPERTIES LINK_FLAGS "${${PROJECT_NAME}_MODULE_LINKER_FLAGS}" )
		set_target_properties( ${target_name} PROPERTIES LINK_FLAGS_DEBUG "${${PROJECT_NAME}_MODULE_LINKER_FLAGS_DEBUG}" )
		set_target_properties( ${target_name} PROPERTIES LINK_FLAGS_RELEASE "${${PROJECT_NAME}_MODULE_LINKER_FLAGS_RELEASE}" )
	elseif( ${PROJECT_NAME}_${target_name}_TYPE STREQUAL "EXECUTABLE" )
		set_target_properties( ${target_name} PROPERTIES LINK_FLAGS "${${PROJECT_NAME}_EXE_LINKER_FLAGS}" )
		set_target_properties( ${target_name} PROPERTIES LINK_FLAGS_DEBUG "${${PROJECT_NAME}_EXE_LINKER_FLAGS} ${${PROJECT_NAME}_EXE_LINKER_FLAGS_DEBUG}" )
		set_target_properties( ${target_name} PROPERTIES LINK_FLAGS_RELEASE "${${PROJECT_NAME}_EXE_LINKER_FLAGS} ${${PROJECT_NAME}_EXE_LINKER_FLAGS_RELEASE}" )
	endif()
endmacro (WkTargetSetProperties )


#
# WkExportConfig ( target1 [ target2 [...]] )
#
macro (WkExportConfig target1 )

	#
	# Generating configuration cmake file
	#
	
	WkGenConfig( ${target1} ${ARGN} )
	
	foreach ( tgt ${target1};${ARGN})
		#Linking source dependencies, and modifying config files
		foreach (sdep ${${PROJECT_NAME}_SRCDEPENDS} )
			WkLinkSrcDepends( ${tgt} ${sdep} )
		endforeach()
	endforeach()

	foreach ( tgt ${target1};${ARGN})
		#Linking binary dependencies, and modifying config files
		foreach (bdep ${${PROJECT_NAME}_BINDEPENDS} )
			WkLinkBinDepends( ${tgt} ${bdep} )
		endforeach()
	endforeach()

	WkFinConfig()

endmacro (WkExportConfig)


#
# WkTargetFormat( target_name files)
#
macro (WkTargetFormat target_name )
	#TODO : automatic detectino on windows ( preinstalled with wkcmake... )
	FIND_PACKAGE(WKCMAKE_AStyle)
	IF ( WKCMAKE_AStyle_FOUND )
		option (${PROJECT_NAME}_${target_name}_CODE_FORMAT "Enable Code Formatting" OFF)
		IF ( ${PROJECT_NAME}_${target_name}_CODE_FORMAT )
			set(${PROJECT_NAME}_${target_name}_CODE_FORMAT_STYLE "ansi" CACHE STRING "Format Style for AStyle")
			#converting to system path ( needed because command line call later )
			set(FILES_NATIVE "")
			foreach (f ${ARGN} )
				FILE(TO_NATIVE_PATH ${f} f_nat)
				SET(FILES_NATIVE ${FILES_NATIVE} ${f_nat})
			endforeach(f)
			WkWhitespaceSplit( FILES_NATIVE FILES_PARAM_NATIVE )
			#message ( "Sources :  ${FILES_PARAM_NATIVE} ${FILES_PARAM_NATIVE}" )
			set ( cmdline " ${WKCMAKE_AStyle_EXECUTABLE} --style=${${PROJECT_NAME}_${target_name}_CODE_FORMAT_STYLE} ${FILES_PARAM_NATIVE}" )
			#message ( "CMD : ${cmdline} " )
			#message ( "WORKING_DIR : ${PROJECT_SOURCE_DIR} " )
			IF ( WIN32 )
				ADD_CUSTOM_TARGET(${PROJECT_NAME}_${target_name}_format ALL cmd /c ${cmdline} WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}" VERBATIM )
			ELSE ( WIN32 )
				ADD_CUSTOM_TARGET(${PROJECT_NAME}_${target_name}_format ALL sh -c ${cmdline} WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}" VERBATIM )
			ENDIF ( WIN32 )
		ENDIF ( ${PROJECT_NAME}_${target_name}_CODE_FORMAT )
	ENDIF ( WKCMAKE_AStyle_FOUND )
endmacro (WkTargetFormat)

#
# WkTargetCppCheck( target_name )
#
macro (WkTargetCppCheck target_name )

	#code analysis by target introspection -> needs to be done after target definition ( as here )
	FIND_PACKAGE(WKCMAKE_Cppcheck)
	IF ( WKCMAKE_Cppcheck_FOUND)
		option ( ${PROJECT_NAME}_${target_name}_CODE_ANALYSIS "Enable Code Analysis" OFF)
		IF ( ${PROJECT_NAME}_${target_name}_CODE_ANALYSIS )
			Add_WKCMAKE_Cppcheck_target(${target_name}_cppcheck ${target_name} "${PROJECT_NAME}-${target_name}-cppcheck.xml")
		ENDIF ( ${PROJECT_NAME}_${target_name}_CODE_ANALYSIS )
	ENDIF ( WKCMAKE_Cppcheck_FOUND)

	#setting up dependencies between formatting and code analysis target
	if ( WKCMAKE_Cppcheck_FOUND AND ${PROJECT_NAME}_${target_name}_CODE_ANALYSIS )
		add_dependencies(${target_name} ${target_name}_cppcheck)
		if( WKCMAKE_AStyle_FOUND AND ${PROJECT_NAME}_CODE_FORMAT )
			add_dependencies(${target_name}_cppcheck ${PROJECT_NAME}_format)	    
		endif( WKCMAKE_AStyle_FOUND AND ${PROJECT_NAME}_CODE_FORMAT )
	else ( WKCMAKE_Cppcheck_FOUND AND ${PROJECT_NAME}_${target_name}_CODE_ANALYSIS )
		if( WKCMAKE_AStyle_FOUND AND ${PROJECT_NAME}_CODE_FORMAT )
			add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}_format)	    
		endif( WKCMAKE_AStyle_FOUND AND ${PROJECT_NAME}_CODE_FORMAT )
	endif( WKCMAKE_Cppcheck_FOUND AND ${PROJECT_NAME}_${target_name}_CODE_ANALYSIS )


endmacro (WkTargetCppCheck)

#
# WkExtData( [ datafile1 [ datafile2 [ ... ] ] ] )
# Copy the external data ( not in WKCMAKE_DATA_DIR ) associated to the project from the path,
# to the binary_path, in the WKCMAKE_DATA_DIR directory
#
MACRO (WkExtData)

	foreach ( data ${ARGN} )
		FILE(TO_NATIVE_PATH "${data}" ${data}_NATIVE_SRC_PATH)
		FILE(TO_NATIVE_PATH "${PROJECT_BINARY_DIR}/${WKCMAKE_DATA_DIR}/${data}" ${data}_NATIVE_BLD_PATH)
		ADD_CUSTOM_COMMAND( TARGET ${PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy "${${data}_NATIVE_SRC_PATH}" "${${data}_NATIVE_BLD_PATH}" COMMENT "Copying ${${data}_NATIVE_SRC_PATH} to ${${data}_NATIVE_BLD_PATH}" VERBATIM)
	endforeach ( data ${ARGN} )
	
ENDMACRO (WkExtData data_path)

#
# WkExtDataDir( [ datadir1 [ datadir2 [ ... ] ] ] )
# Copy the external data directory ( not in WKCMAKE_DATA_DIR ) associated to the project from the path,
# to the binary_path, in the WKCMAKE_DATA_DIR directory
#
MACRO (WkExtDataDir)

	foreach ( datadir ${ARGN} )
		ADD_CUSTOM_COMMAND( TARGET ${PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} ARGS -E copy_directory ${datadir} ${PROJECT_BINARY_DIR}/${WKCMAKE_DATA_DIR}/${datadir} COMMENT "Copying ${datadir} to ${PROJECT_BINARY_DIR}/${WKCMAKE_DATA_DIR}/${datadir}" )
	endforeach ( datadir ${ARGN} )
	
ENDMACRO (WkExtDataDir data_path)



