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
message ( STATUS "== Loading WkDepends.cmake ..." )

if ( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6 )
	message ( FATAL_ERROR " CMAKE MINIMUM BACKWARD COMPATIBILITY REQUIRED : 2.6 !" )
endif( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6 )

# using useful Macros
include ( "${WKCMAKE_DIR}/WkUtils.cmake" )

#
# Find a dependency that :
# - has been built in an external WK hierarchy
# - has been build in an internal Wk hierarchy ( subdirectory - binary depends)
# - needs to be built in an internal Wk hierarchy ( subdirectory - source depends)
# => external source directory are not supported ( basic add_subdirectory from cmake doesnt support external source trees )
# Defines ${PROJECT_NAME_BINDEPENDS} containing all found binary dependencies
# Defines ${PROJECT_NAME_SRCDEPENDS} containing all found source dependencies
#
# NOTE : This will not download source packages when required ( only binary packages )
# For Source package, the user should use addExternalProject() - untested in wkcmake yet.
#
# WkDepends( dependency_name [QUIET / REQUIRED] )

macro (WkDepends package_name)
	
	#
	# First check if the package is a subdirectory
	#
	IF(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${package_name}" AND IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${package_name}")
		#message (STATUS "== ${package_name} subdirectory FOUND !")
		IF(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${package_name}/CMakeLists.txt")
		
			message (STATUS "== ${package_name}/CMakeLists.txt FOUND ! Adding into ${PROJECT_NAME}.")
			
			WkSrcDepends(${package_name})
			
		ELSE()
			#binary dependency ( by wkcmake )
			#TODO : support basic cmake dependency (*Export.txt files) ?
			file(GLOB files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "${package_name}/*Config.cmake")
			list(REMOVE_ITEM files "${package_name}/CPackSourceConfig.cmake" "${package_name}/CPackConfig.cmake")
			#message (STATUS "${files} FOUND !")
			foreach(file ${files})
				#get dependency name
				STRING(REGEX REPLACE "^.*/([A-Za-z0-9]+)Config.cmake" "\\1" pack_name "${file}")
				#set directory for it
				#message (STATUS "== ${pack_name} FOUND ! Adding dir into ${PROJECT_NAME}.")
				set (${pack_name}_DIR ${package_name})
				message (STATUS "== ${pack_name} FOUND ! Adding Binary Dependency into ${PROJECT_NAME}.")
				
				WkBinDepends(${pack_name})
				
			endforeach()				
		ENDIF()
	ELSE()
		# External dependency -> always binary
	
		WkBinDepends(${package_name})
	ENDIF()
		
endmacro (WkDepends package_name)

##
# Find a dependency that :
# - has been built in an external WK hierarchy
# - has been build in an internal Wk hierarchy ( subdirectory - binary depends)
# Defines ${PROJECT_NAME}_BINDEPENDS containing all found dependencies
# TODO : download binaries if package not found here.
# WkDepends( dependency_name [QUIET / REQUIRED] )
macro (WkBinDepends package_name)

		SetPackageVarName( package_var_name ${package_name} )
		#message ( "${package_name} -> ${package_var_name}" )

		#Here to avoid redefinition of library target if already found by a dependency using my dependency as well...
		if ( NOT ${package_var_name}_FOUND )
			#TODO : Fix if "REQUIRED" is passed to WkDepends
			find_package( ${package_name} ${ARGN} )
		endif ( NOT ${package_var_name}_FOUND )
		
		#
		#TODO: here we should use the external package/project command to download not found package ( only binary ! )
		#
		
		if ( ${package_var_name}_FOUND )

			### INCLUDE DIRS MUST BE HANDLED HERE, BEFORE COMPILATION ###	
			#hiding the original cmake Module variable, displaying the WkCMake later on
			mark_as_advanced ( FORCE ${package_var_name}_INCLUDE_DIR ) 

			# to handle cmake modules who dont have exactly the same standard as WkModules
			if ( NOT ${package_var_name}_INCLUDE_DIRS )
				set ( ${package_var_name}_INCLUDE_DIRS ${${package_var_name}_INCLUDE_DIR} CACHE PATH "${package_name} Headers directories")
			endif ( NOT ${package_var_name}_INCLUDE_DIRS )

			#dependencies headers ( need to be included after project's own headers )
			include_directories(${${package_var_name}_INCLUDE_DIRS})
			message ( STATUS "== Binary Dependency ${package_name} include : ${${package_var_name}_INCLUDE_DIRS} OK !")

			#to make sure it s visible in teh interface
			mark_as_advanced ( CLEAR ${package_var_name}_INCLUDE_DIRS ) 

			set ( WK_${PROJECT_NAME}_FOUND_${package_var_name} ON )
			#this is not necessary if WkPlatform does the job as it should
			#add_definitions(-D WK_${PROJECT_NAME}_FOUND_${package_var_name})

			message ( STATUS "== Binary Dependency ${package_name} : FOUND ! " )

			if ( DEFINED ${PROJECT_NAME}_BINDEPENDS )
				set ( ${PROJECT_NAME}_BINDEPENDS "${${PROJECT_NAME}_BINDEPENDS}" "${package_name}" )
			else()
				set ( ${PROJECT_NAME}_BINDEPENDS "${package_name}" )
			endif()
			
		else ( ${package_var_name}_FOUND )	
			message ( STATUS "== Binary Dependency ${package_name} : NOT FOUND ! " )
		endif ( ${package_var_name}_FOUND )
endmacro (WkBinDepends package_name)

##
# Find a dependency that :
# - needs to be built in an internal Wk hierarchy ( subdirectory - source depends)
# => external source directory are not supported ( basic add_subdirectory from cmake doesnt support external source trees )
# Defines ${PROJECT_NAME}_SRCDEPENDS containing all found source dependencies
# WkDepends( dependency_name [QUIET / REQUIRED] )
macro (WkSrcDepends dir_name)

		#TODO : Make sure the add_subdirectory does what it is supposed to
		# and that we dont add another different project...
		# => How to check for errors ?
		add_subdirectory(${dir_name} ${CMAKE_CURRENT_BINARY_DIR}/${dir_name})
		list(LENGTH ${CMAKE_PROJECT_NAME}_SRCDEPENDS dpdlsize)
		list ( GET ${CMAKE_PROJECT_NAME}_SRCDEPENDS dpdlsize-1 subprj_name )
		
		#defining ${subprj_name}_DIR as build directory.
		#We need it later to get location of libraries and other build results, to work in the same way as bin dependencies.
		set ( ${subprj_name}_DIR ${CMAKE_CURRENT_BINARY_DIR}/${dir_name} )
		
		if ( ${subprj_name}_INCLUDE_DIR )

			#dependencies headers ( need to be included after project's own headers )
			#Note : we use the include dir from source, not from the copy in binary dir.
			file( TO_CMAKE_PATH ${CMAKE_CURRENT_BINARY_DIR}/${dir_name}/${${subprj_name}_INCLUDE_DIR} subprj_include_path)
			file( TO_CMAKE_PATH ${CMAKE_CURRENT_BINARY_DIR}/${dir_name}/CMakeFiles subprj_include_wk_path)
			
			#To match a binary dependency variable names :
			set ( ${subprj_name}_INCLUDE_DIRS ${subprj_include_wk_path} ${subprj_include_path} CACHE PATH "${subprj_name} Headers directories")
			include_directories(${${subprj_name}_INCLUDE_DIRS})
			message ( STATUS "== Source Dependency ${subprj_name} include : ${${subprj_name}_INCLUDE_DIRS} OK !")

			set ( WK_${PROJECT_NAME}_FOUND_${subprj_name} ON )
			#this is not necessary if WkPlatform does the job as it should
			#add_definitions(-D WK_${PROJECT_NAME}_FOUND_${subprj_name})

			message ( STATUS "== Source Dependency ${subprj_name} : FOUND ! " )
			
		else ( ${subprj_name}_INCLUDE_DIR )	
			message ( STATUS "== Source Dependency ${subprj_name} : NOT FOUND ! " )
		endif ( ${subprj_name}_INCLUDE_DIR )
endmacro (WkSrcDepends dir_name)

#
# Joining Dependencies for build
# They will all be forwarded to client projects
#
macro(WkLinkBinDepends package_name)
	
	SetPackageVarName( package_var_name ${package_name} )
	#message ( "${package_name} -> ${package_var_name}" )

	if ( ${package_var_name}_FOUND )

		### LIBRARIES MUST BE HANDLED HERE, FOR LINKING ###
		#hiding the original cmake Module variable, displaying the WkCMake later on
		mark_as_advanced ( FORCE ${package_var_name}_LIBRARY ) 
		
		# to handle cmake module who dont have exactly the same standard as WkModules
		if ( NOT ${package_var_name}_LIBRARIES )
			set ( ${package_var_name}_LIBRARIES ${${package_var_name}_LIBRARY} CACHE FILEPATH "${package_name} Libraries ")
		endif ( NOT ${package_var_name}_LIBRARIES )

		target_link_libraries(${PROJECT_NAME} ${${package_var_name}_LIBRARIES})
		message ( STATUS "== Binary Dependency ${package_name} libs : ${${package_var_name}_LIBRARIES} OK !")

		#using fullpath libraries from here on
		
		
		
		
		mark_as_advanced ( CLEAR ${package_var_name}_LIBRARIES )
		
		# Once the project is built with it, the dependency becomes mandatory
		# However we need to propagate the location of Custom Wk-dependencies, to make it easier for later
		if ( ${package_name}_DIR )
			get_filename_component( ${package_name}_FDIR ${${package_name}_DIR} ABSOLUTE )
		endif ( ${package_name}_DIR )

		# we append to the config cmake script
		file( APPEND ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake "

### External Dependency ${package_name} ###
		")

		#If it s a custom Wk-dependency we need to use the Export from the dependency to be able to access built targets.
		if ( ${package_name}_DIR )
			#we need to add this to config and not export, as export will be erased by cmake during build configuration from cache.
			file( APPEND ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake "
			
#Propagating imported targets
if ( EXISTS \"${${package_name}_FDIR}/${package_name}Export.cmake\" )
	include( \"${${package_name}_FDIR}/${package_name}Export.cmake\" )
endif ( EXISTS \"${${package_name}_FDIR}/${package_name}Export.cmake\" )

			")
		endif ( ${package_name}_DIR )

		file( APPEND ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake "

# Include directory might be needed by upper project if ${PROJECT_NAME} doesnt totally encapsulate it.
# NB : It shouldnt hurt if the upper project also define it as its own dependency
set(${PROJECT_NAME}_INCLUDE_DIRS \"${${package_var_name}_INCLUDE_DIRS}\" \${${PROJECT_NAME}_INCLUDE_DIRS} )
set(${PROJECT_NAME}_LIBRARIES \${${PROJECT_NAME}_LIBRARIES} \"${${package_var_name}_LIBRARIES}\" )

		")
		
	else ( ${package_var_name}_FOUND )	
		message ( STATUS "== Binary Dependency ${package_name} : FAILED ! " )
	endif ( ${package_var_name}_FOUND )
	
endmacro(WkLinkBinDepends package_name)

#
# Joining Dependencies for build
# They will all be forwarded to client projects
#
macro(WkLinkSrcDepends subprj_name)
	
	if ( ${subprj_name}_LIBRARY )

		set ( ${subprj_name}_LIBRARIES ${${subprj_name}_LIBRARY} CACHE FILEPATH "${subprj_name} Libraries ")
			
		target_link_libraries(${PROJECT_NAME} ${${subprj_name}_LIBRARIES})
		message ( STATUS "== Source Dependency ${subprj_name} libs : ${${subprj_name}_LIBRARIES} OK !")
		
		# Once the project is built with it, the dependency becomes mandatory
		if ( ${subprj_name}_DIR )
			get_filename_component( ${subprj_name}_FDIR ${${subprj_name}_DIR} ABSOLUTE )
		endif ( ${subprj_name}_DIR )

		# we append to the config cmake script
		file( APPEND ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake "

### External Dependency ${subprj_name} ###
		")

		#If it s a custom Wk-dependency we need to use the Export from the dependency to be able to access built targets.
		if ( ${subprj_name}_DIR )
			#we need to add this to config and not export, as export will be erased by cmake during build configuration from cache.
			message(STATUS "Modifying ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Export.cmake about ${${subprj_name}_FDIR}/${subprj_name}Export.cmake" )
			file( APPEND ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake "
			
#Propagating imported targets
if ( EXISTS \"${${subprj_name}_FDIR}/${subprj_name}Export.cmake\" )
	include( \"${${subprj_name}_FDIR}/${subprj_name}Export.cmake\" )
endif ( EXISTS \"${${subprj_name}_FDIR}/${subprj_name}Export.cmake\" )

			")
		endif ( ${subprj_name}_DIR )

		file( APPEND ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake "

# Include directory might be needed by upper project if ${PROJECT_NAME} doesnt totally encapsulate it.
# NB : It shouldnt hurt if the upper project also define it as its own dependency
set(${PROJECT_NAME}_INCLUDE_DIRS \"${${subprj_name}_INCLUDE_DIRS}\" \${${PROJECT_NAME}_INCLUDE_DIRS} )
set(${PROJECT_NAME}_LIBRARIES \${${PROJECT_NAME}_LIBRARIES} \"${${subprj_name}_LIBRARIES}\" )

		")
		
	else ( ${subprj_name}_LIBRARY )	
		message ( STATUS "== Binary Dependency ${subprj_name} : FAILED ! " )
	endif ( ${subprj_name}_LIBRARY )
	
endmacro(WkLinkSrcDepends package_name)

