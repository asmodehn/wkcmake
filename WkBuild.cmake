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

if ( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6 )
	message ( FATAL_ERROR " CMAKE MINIMUM BACKWARD COMPATIBILITY REQUIRED : 2.6 !" )
endif( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6 )

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
	
	#To add this project as a source dependency to a master project
	if ( NOT ${PROJECT_NAME} STREQUAL ${CMAKE_PROJECT_NAME} )
		set (${CMAKE_PROJECT_NAME}_SRCDEPENDS ${${CMAKE_PROJECT_NAME}_SRCDEPENDS} ${PROJECT_NAME} CACHE STRING "List of Project Dependencies that needs to be built with the Main Project")
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
#
# Automatically called during WkBuild
#

macro ( WkGenConfig )
	CMAKE_POLICY(PUSH)
	CMAKE_POLICY(VERSION 2.6)

	#Exporting targets
	export(TARGETS ${PROJECT_NAME} FILE ${PROJECT_NAME}Export.cmake)
	
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
set(${PROJECT_NAME}_LIBRARY ${PROJECT_NAME} )
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

#WkBuild( EXECUTABLE | LIBRARY [ STATIC|SHARED|MODULE ]  )

macro (WkBuild project_type)
CMAKE_POLICY(PUSH)
CMAKE_POLICY(VERSION 2.6)

	if ( ${ARGC} GREATER 1 )
		set(${PROJECT_NAME}_load_type ${ARGV1} )
	endif ( ${ARGC} GREATER 1 )

    #Setting up project structure defaults for directories
    # Note that if these have been already defined with the same macros, the calls here wont have any effect ( wont changed cached value )
    WkIncludeDir("include")
	WkSrcDir("src")
	WkBinDir("bin")
	WkLibDir("lib")
	WkDataDir("data")
	
    #Doing compiler setup in Build step, because :
    # - it is related to target, not overall project ( even if environment is same for cmake, settings can be different for each target )
    # - custom build options may have been defined before ( and will be used instead of defaults )
	WkCompilerSetup()

    #adding usual BUILD_SHARED_LIBS option
    option(BUILD_SHARED_LIBS "Set this to ON to build shared libraries by default" off)

	if(${project_type} STREQUAL "LIBRARY")
		#handling default load type
		if ( NOT ${PROJECT_NAME}_load_type )
		    if( BUILD_SHARED_LIBS )
    		    set(${PROJECT_NAME}_load_type "SHARED")
    		else( BUILD_SHARED_LIBS )
        		set(${PROJECT_NAME}_load_type "STATIC")
        	endif( BUILD_SHARED_LIBS )
        endif ( NOT ${PROJECT_NAME}_load_type )
	endif(${project_type} STREQUAL "LIBRARY")

	message ( STATUS "== Configuring ${PROJECT_NAME} as ${project_type} ${${PROJECT_NAME}_load_type}" )	
		
	# testing type
	if (NOT ${project_type} STREQUAL "EXECUTABLE" AND NOT ${project_type} STREQUAL "LIBRARY" )
		message ( FATAL_ERROR " Project type ${project_type} is not valid. Project type can be either EXECUTABLE or LIBRARY")
	endif (NOT ${project_type} STREQUAL "EXECUTABLE" AND NOT ${project_type} STREQUAL "LIBRARY" )
	if ( ${project_type} STREQUAL "LIBRARY" 
					AND NOT ${${PROJECT_NAME}_load_type} STREQUAL "STATIC"
					AND NOT ${${PROJECT_NAME}_load_type} STREQUAL "SHARED"
					AND NOT ${${PROJECT_NAME}_load_type} STREQUAL "MODULE"
		)
		message ( FATAL_ERROR " Project Load type ${${PROJECT_NAME}_load_type} is not valid. Project Load type can be either STATIC, SHARED or MODULE")
	endif  ( ${project_type} STREQUAL "LIBRARY" 
					AND NOT ${${PROJECT_NAME}_load_type} STREQUAL "STATIC"
					AND NOT ${${PROJECT_NAME}_load_type} STREQUAL "SHARED"
					AND NOT ${${PROJECT_NAME}_load_type} STREQUAL "MODULE"
		)
		
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
		set(CHECK_MEM_LEAKS OFF CACHE BOOL "On to check memory with VLD (must be installed)")
		if(CHECK_MEM_LEAKS)
			add_definitions(-DVLD)
		endif(CHECK_MEM_LEAKS)
	endif (${${PROJECT_NAME}_BUILD_TYPE} STREQUAL Release)
	endif ( ${PROJECT_NAME}_BUILD_TYPE )

	#generating configured Header for detected packages
	WkPlatformConfigure()

	#Storing Main Include directory
	#set( ${PROJECT_NAME}_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}" CACHE PATH " Includes directories for ${PROJECT_NAME} blah ")
	
	#Defining target
	message ( STATUS "== Sources Files autodetection..." )	

	#VS workaround to display headers even if strictly not needed when building
	FILE(GLOB_RECURSE HEADERS RELATIVE "${PROJECT_SOURCE_DIR}" ${${PROJECT_NAME}_INCLUDE_DIR}/*.h ${${PROJECT_NAME}_INCLUDE_DIR}/*.hh ${${PROJECT_NAME}_INCLUDE_DIR}/*.hpp ${${PROJECT_NAME}_SRC_DIR}/*.h ${${PROJECT_NAME}_SRC_DIR}/*.hh ${${PROJECT_NAME}_SRC_DIR}/*.hpp)
	FILE(GLOB_RECURSE SOURCES RELATIVE "${PROJECT_SOURCE_DIR}" ${${PROJECT_NAME}_SRC_DIR}/*.c ${${PROJECT_NAME}_SRC_DIR}/*.cpp ${${PROJECT_NAME}_SRC_DIR}/*.cc)
	message ( STATUS "== Headers detected in ${${PROJECT_NAME}_INCLUDE_DIR} and ${${PROJECT_NAME}_SRC_DIR} : ${HEADERS}" )
	message ( STATUS "== Sources detected in ${${PROJECT_NAME}_SRC_DIR} : ${SOURCES}" )

	if ( NOT CMAKE_MODULE_PATH )
		set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" "${CMAKE_SOURCE_DIR}/${${PROJECT_NAME}_DIR}/Modules/")
	endif ( NOT CMAKE_MODULE_PATH )

	#TODO : automatic detectino on windows ( preinstalled with wkcmake... )
	FIND_PACKAGE(WKCMAKE_AStyle)
	IF ( WKCMAKE_AStyle_FOUND )
		option (${PROJECT_NAME}_CODE_FORMAT "Enable Code Formatting" OFF)
		IF ( ${PROJECT_NAME}_CODE_FORMAT )
			set(${PROJECT_NAME}_CODE_FORMAT_STYLE "ansi" CACHE STRING "Format Style for AStyle")
			#converting to system path ( needed because command line call later )
			set(HEADERS_NATIVE "")
			foreach (f ${HEADERS} )
				FILE(TO_NATIVE_PATH ${f} f_nat)
				SET(HEADERS_NATIVE ${HEADERS_NATIVE} ${f_nat})
			endforeach(f)
			SET(SOURCES_NATIVE "")
			foreach (f ${SOURCES} )
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
		ENDIF ( ${PROJECT_NAME}_CODE_FORMAT )
	ENDIF ( WKCMAKE_AStyle_FOUND )


	#Including configured headers (
	#	-binary_dir/CMakeFiles for the configured header, 
	#	-source_dir/include for the unmodified ones, 
	include_directories("${PROJECT_BINARY_DIR}/CMakeFiles" "${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}" )

	#internal headers ( non visible by outside project )
	include_directories("${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_SRC_DIR}")

	#TODO : find a simpler way than this complex merge...
	MERGE("${HEADERS}" "${SOURCES}" SOURCES)
	#MESSAGE ( STATUS "== ${PROJECT_NAME} Sources : ${SOURCES}" )
	
	AddPlatformCheckSrc( SOURCES )

	#
	# Handling my own build config
	#
	
	# to show we are using WkCMake to build ( can be #ifdef in header )
	add_definitions( -D WK_BUILD )

	if(${project_type} STREQUAL "LIBRARY")
		add_library(${PROJECT_NAME} ${${PROJECT_NAME}_load_type} ${SOURCES})
		#storing a variable for top project to be able to link it
		set(${PROJECT_NAME}_LIBRARY ${PROJECT_NAME} CACHE FILEPATH "${PROJECT_NAME} Library")
		if ( ${${PROJECT_NAME}_load_type} STREQUAL "SHARED" )
			set_target_properties(${PROJECT_NAME} PROPERTIES DEFINE_SYMBOL "WK_${PROJECT_NAME}_SHAREDLIB_BUILD")
		endif ( ${${PROJECT_NAME}_load_type} STREQUAL "SHARED" )
	elseif (${project_type} STREQUAL "EXECUTABLE")
		add_executable(${PROJECT_NAME} ${SOURCES})
		#We also need to copy run libraries on windows
		
	else ()
		message( FATAL_ERROR " Project Type can only be EXECUTABLE or LIBRARY " )
	endif()
	
	#setting target properties
	#Need to match WkCompilerSetup content
    if ( ${PROJECT_NAME}_C_COMPILER_LOADED )
        if ( ${PROJECT_NAME}_BUILD_TYPE STREQUAL "Debug" )
            set_target_properties( ${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "${${PROJECT_NAME}_C_FLAGS} ${${PROJECT_NAME}_C_FLAGS_DEBUG}" )
        elseif ( ${PROJECT_NAME}_BUILD_TYPE STREQUAL "Release" )
            set_target_properties( ${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "${${PROJECT_NAME}_C_FLAGS} ${${PROJECT_NAME}_C_FLAGS_RELEASE}" )
        endif()
    endif()
    if ( ${PROJECT_NAME}_CXX_COMPILER_LOADED )
        if ( ${PROJECT_NAME}_BUILD_TYPE STREQUAL "Debug" )
            set_target_properties( ${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "${${PROJECT_NAME}_CXX_FLAGS} ${${PROJECT_NAME}_CXX_FLAGS_DEBUG}" )
        elseif ( ${PROJECT_NAME}_BUILD_TYPE STREQUAL "Release" )
            set_target_properties( ${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "${${PROJECT_NAME}_CXX_FLAGS} ${${PROJECT_NAME}_CXX_FLAGS_RELEASE}" )
        endif()
    endif()
	get_target_property(${PROJECT_NAME}_TYPE ${PROJECT_NAME} TYPE)
	if ( ${PROJECT_NAME}_TYPE STREQUAL "SHARED_LIBRARY" )
        set_target_properties( ${PROJECT_NAME} PROPERTIES LINK_FLAGS "${${PROJECT_NAME}_SHARED_LINKER_FLAGS}" )
 	    if ( ${PROJECT_NAME}_BUILD_TYPE STREQUAL "Debug" )
     	    set_target_properties( ${PROJECT_NAME} PROPERTIES LINK_FLAGS_DEBUG "${${PROJECT_NAME}_SHARED_LINKER_FLAGS_DEBUG}" )
   	    elseif ( ${PROJECT_NAME}_BUILD_TYPE STREQUAL "Release" )
       	    set_target_properties( ${PROJECT_NAME} PROPERTIES LINK_FLAGS_RELEASE "${${PROJECT_NAME}_SHARED_LINKER_FLAGS_RELEASE}" )
        endif()
    elseif( ${PROJECT_NAME}_TYPE STREQUAL "MODULE_LIBRARY" )
   	    set_target_properties( ${PROJECT_NAME} PROPERTIES LINK_FLAGS "${${PROJECT_NAME}_MODULE_LINKER_FLAGS}" )
        if ( ${PROJECT_NAME}_BUILD_TYPE STREQUAL "Debug" )
     	    set_target_properties( ${PROJECT_NAME} PROPERTIES LINK_FLAGS_DEBUG "${${PROJECT_NAME}_MODULE_LINKER_FLAGS_DEBUG}" )
        elseif ( ${PROJECT_NAME}_BUILD_TYPE STREQUAL "Release" )
       	    set_target_properties( ${PROJECT_NAME} PROPERTIES LINK_FLAGS_RELEASE "${${PROJECT_NAME}_MODULE_LINKER_FLAGS_RELEASE}" )
        endif()
  	elseif( ${PROJECT_NAME}_TYPE STREQUAL "EXECUTABLE" )
  	    if ( ${PROJECT_NAME}_BUILD_TYPE STREQUAL "Debug" )
     	    set_target_properties( ${PROJECT_NAME} PROPERTIES LINK_FLAGS_DEBUG "${${PROJECT_NAME}_EXE_LINKER_FLAGS} ${${PROJECT_NAME}_EXE_LINKER_FLAGS_DEBUG}" )
        elseif ( ${PROJECT_NAME}_BUILD_TYPE STREQUAL "Release" )
      	    set_target_properties( ${PROJECT_NAME} PROPERTIES LINK_FLAGS_RELEASE "${${PROJECT_NAME}_EXE_LINKER_FLAGS} ${${PROJECT_NAME}_EXE_LINKER_FLAGS_RELEASE}" )
        endif()
  	endif()
  	
	#code analysis by target introspection -> needs to be done after target definition ( as here )
	FIND_PACKAGE(WKCMAKE_Cppcheck)
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
    else ( WKCMAKE_Cppcheck_FOUND AND ${PROJECT_NAME}_CODE_ANALYSIS )
    	if( WKCMAKE_AStyle_FOUND AND ${PROJECT_NAME}_CODE_FORMAT )
    		add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}_format)	    
        endif( WKCMAKE_AStyle_FOUND AND ${PROJECT_NAME}_CODE_FORMAT )
    endif( WKCMAKE_Cppcheck_FOUND AND ${PROJECT_NAME}_CODE_ANALYSIS )

	#
	# Defining where to put what has been built
	#
	
	SET(${CMAKE_PROJECT_NAME}_LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/${${CMAKE_PROJECT_NAME}_LIB_DIR} CACHE PATH "Ouput directory for ${Project} libraries." )
	mark_as_advanced(FORCE ${CMAKE_PROJECT_NAME}_LIBRARY_OUTPUT_PATH)
	SET(LIBRARY_OUTPUT_PATH "${${CMAKE_PROJECT_NAME}_LIBRARY_OUTPUT_PATH}" CACHE INTERNAL "Internal CMake libraries output directory. Do not edit." FORCE)
	
	SET(${CMAKE_PROJECT_NAME}_EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/${${CMAKE_PROJECT_NAME}_BIN_DIR} CACHE PATH "Ouput directory for ${Project} executables." )
	mark_as_advanced(FORCE ${CMAKE_PROJECT_NAME}_EXECUTABLE_OUTPUT_PATH)
	SET(EXECUTABLE_OUTPUT_PATH "${${CMAKE_PROJECT_NAME}_EXECUTABLE_OUTPUT_PATH}" CACHE INTERNAL "Internal CMake executables output directory. Do not edit." FORCE)

	#
	# Copying include directory if needed after build ( for  use by another project later )
	# for library (and modules ? )
	#
	
	if(${project_type} STREQUAL "LIBRARY") 
		ADD_CUSTOM_COMMAND( TARGET ${PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} ARGS -E copy_directory "${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}" "${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}" COMMENT "Copying ${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_INCLUDE_DIR} to ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}" )
		#trying to remove .svn directory... pb : what about other directories everywhere ?
		ADD_CUSTOM_COMMAND( TARGET ${PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} ARGS -E remove_directory "${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/.svn" COMMENT "Removing ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_INCLUDE_DIR}/.svn" )
	endif(${project_type} STREQUAL "LIBRARY") 
	
	#
	# Copying data directory after build ( fo use by project later )
	#
	ADD_CUSTOM_COMMAND( TARGET ${PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} ARGS -E copy_directory "${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_DATA_DIR}" "${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_DATA_DIR}" COMMENT "Copying ${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_DATA_DIR} to ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_DATA_DIR}" )

	#
	# Generating configuration cmake file
	#
	
	WkGenConfig( )
	
	#Linking source dependencies, and modifying config files
	foreach (sdep ${${PROJECT_NAME}_SRCDEPENDS} )
		WkLinkSrcDepends( ${sdep} )
	endforeach()
	
	#Linking binary dependencies, and modifying config files
	foreach (bdep ${${PROJECT_NAME}_BINDEPENDS} )
		WkLinkBinDepends( ${bdep} )
	endforeach()

	WkFinConfig()
		
CMAKE_POLICY(POP)
endmacro (WkBuild)

#Sets specific compile and link flags the build ( override default target flags from wkcmake )
#build_type can be either "Debug, "Release", or "All"
#WkBuildOptions ( build_type compile_flags [link_flags] )
macro (WkBuildOptions build_type compile_flags )
    WkTargetBuildOptions( "${PROJECT_NAME}" "${build_type}" "${compile_flags}" "${ARGV2}")
endmacro (WkBuildOptions)


#macro (WkBuild project_type [load_type])
#TODO for backward compat. must call :

#WkTarget generates a target for the current project.
#with same Language as Project and implicit dependency of main build target (to check if always doable)
macro (WkTarget target_name include_dir source_dir project_type [load_type])
CMAKE_POLICY(PUSH)
CMAKE_POLICY(VERSION 2.6)
#TODO
CMAKE_POLICY(POP)
endmacro(WkTarget)

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



