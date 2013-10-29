# 
# Copyright (c) 2009-2010, Asmodehn's Corp.
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
# Find a dependency built in an external WK hierarchy
# Defines ${PROJECT_NAME_DEPENDS} containing all found dependencies
#
# WkDepends( dependency_name [QUIET / REQUIRED] )

macro (WkDepends package_name)
	
	#
	# First check if the package is installed already , quietly
	#
	
	SetPackageVarName( package_var_name ${package_name} )
	#message ( "${package_name} -> ${package_var_name}" )

	#Here to avoid redefinition of library target if already found by a dependency using my dependency as well...
	if ( NOT ${package_var_name}_FOUND )
		#TODO : Fix if "REQUIRED" is passed to WkDepends
		find_package( ${package_name} ${ARGN} )
	endif ( NOT ${package_var_name}_FOUND )
	
	#
	#TODO: here we should use the external package/project command to download not found package
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

		#Simple if structure to avoid oddities when setting ${PROJECT_NAME}_DEPENDS for the first time
		if ( ${PROJECT_NAME}_DEPENDS)
			set ( ${PROJECT_NAME}_DEPENDS "${${PROJECT_NAME}_DEPENDS}" "${package_name}" ) 
		else ( ${PROJECT_NAME}_DEPENDS)
			set ( ${PROJECT_NAME}_DEPENDS "${package_name}" ) 
		endif ( ${PROJECT_NAME}_DEPENDS)
		
	else ( ${package_var_name}_FOUND )	
		message ( STATUS "== Binary Dependency ${package_name} : NOT FOUND ! " )
	endif ( ${package_var_name}_FOUND )

endmacro (WkDepends package_name)

#
# Joining Dependencies for build
# They will all be forwarded to client projects
#
macro(WkLinkDepends package_name)
	
	SetPackageVarName( package_var_name ${package_name} )
	#message ( "${package_name} -> ${package_var_name}" )

	if ( ${package_var_name}_FOUND )

		### LIBRARIES MUST BE HANDLED HERE, FOR LINKING ###
		#hiding the original cmake Module variable, displaying the WkCMake later on
		mark_as_advanced ( FORCE ${package_var_name}_LIBRARY ) 
		
		# to handle cmake moule who dont have exactly the same standard as WkModules
		if ( NOT ${package_var_name}_LIBRARIES )
			set ( ${package_var_name}_LIBRARIES ${${package_var_name}_LIBRARY} CACHE FILEPATH "${package_name} Libraries ")
		endif ( NOT ${package_var_name}_LIBRARIES )
		#todo : maybe we need a complete layer over that, Wk Modules handling Wk fetures such as run_libraries and correct variable name...

		target_link_libraries(${PROJECT_NAME} ${${package_var_name}_LIBRARIES})
		message ( STATUS "== Binary Dependency ${package_name} libs : ${${package_var_name}_LIBRARIES} OK !")

		mark_as_advanced ( CLEAR ${package_var_name}_LIBRARIES ) 
		
		IF ( WIN32 )
			message ( STATUS "== Binary Dependency ${package_name} runlibs : ${${package_var_name}_RUN_LIBRARIES} OK !")
			#if the find module also defines the runtime libraries ( Wk find module standard  NOT CMAKE itself !)
			# then we need to add the run libraries of the dependency to the current project myrun libraries
			#set( ${PROJECT_NAME}_RUN_LIBRARIES "${${PROJECT_NAME}_RUN_LIBRARIES}" "${${package_var_name}_RUN_LIBRARIES}" CACHE FILEPATH "blabla")
			#message( "Project run lib WkDepends : ${${PROJECT_NAME}_RUN_LIBRARIES} " )
			
			#TODO : here is the default case. We can assume if the variable RUN_LIBRARIES does not exist that
			# either there is no dll needed OR
			# the dll needed is delivered with the .lib file ( usual with windows dev environments, same as with SDL_* libs )
			# that could be implemented
			
		ENDIF ( WIN32 )
		
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
			file( APPEND ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Export.cmake "
			
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
if ( WIN32 )
	set(${PROJECT_NAME}_RUN_LIBRARIES \${${PROJECT_NAME}_RUN_LIBRARIES} \"${${package_var_name}_RUN_LIBRARIES}\" )
endif ( WIN32 )	

		")
		
	else ( ${package_var_name}_FOUND )	
		message ( STATUS "== Binary Dependency ${package_name} : FAILED ! " )
	endif ( ${package_var_name}_FOUND )
	
endmacro(WkLinkDepends package_name)

macro (WkCopyDepends depend target)
	SetPackageVarName( package_var_name ${depend} )
	#message ( "${depend} -> ${package_var_name}" )

	# we might have multiple libs in one dependency
	foreach ( libarg ${${depend}_RUN_LIBRARIES} ) 
		if ( NOT libarg )
			message ( SEND_ERROR "Error with dependency, needed to run ${target} : ${libarg}" )
		endif ( NOT libarg )
		ADD_CUSTOM_COMMAND( TARGET ${target} POST_BUILD COMMAND ${CMAKE_COMMAND} ARGS -E copy_if_different ${libarg} ${${target}_PATH} COMMENT "Copying ${libarg} to ${${target}_PATH}" )
	endforeach ( libarg ${${depend}_RUN_LIBRARIES} )
endmacro(WkCopyDepends )



