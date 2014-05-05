# 
# Copyright (c) 2009-2011, Asmodehn's Corp.
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
# Defining test rules based on a well known hierarchy
# You need at least the test subdirectory in you hierarchy for this to work.
# One source file can be used for a set of tests.
#

#debug
message ( STATUS "== Loading WkTest.cmake ..." )

if ( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6.3 )
	message ( FATAL_ERROR " CMAKE MINIMUM BACKWARD COMPATIBILITY REQUIRED : 2.6.3 !" )
endif( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.6.3 )


#
# Defining where Test should be found on WkTestBuild call.
#
macro(WkTestDir dir)
	if (${PROJECT_NAME} STREQUAL "Project")
		message(FATAL_ERROR "WkTestDir needs to be called after WkProject")
	else ()
		set ( ${PROJECT_NAME}_TEST_DIR ${dir} CACHE PATH "Test directory for ${PROJECT_NAME}" )    
		mark_as_advanced ( ${PROJECT_NAME}_TEST_DIR )
	endif()
endmacro(WkTestDir dir)

#
# Defining where data used by tests should be found vs the source.
#
macro(WkTestDataDir dir)
	if (${PROJECT_NAME} STREQUAL "Project")
		message(FATAL_ERROR "WkTestDataDir needs to be called after WkProject")
	else ()
		set ( ${PROJECT_NAME}_TEST_DATA_DIR ${dir} CACHE PATH "Data directory for ${PROJECT_NAME} source tests with root at ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_TEST_DIR}" )
		mark_as_advanced ( ${PROJECT_NAME}_TEST_DATA_DIR )
	endif()
endmacro(WkTestDataDir dir)

#
#WkTestBuild( test_name [test_source [...] ] )
#

MACRO(WkTestBuild test_name)
    
    #Defining default folders for tests
    # Note that if these have been already defined with the same macros, the calls here wont have any effect ( wont changed cached value )
    # Default: "test" w root at ${PROJECT_SOURCE_DIR} 
	WkTestDir("test")
	
	# Default: "data" w root at ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_TEST_DIR}
	WkTestDataDir("data")
		
	option(${PROJECT_NAME}_ENABLE_TESTS "Wether or not you want the project to include the tests and enable automatic testing for ${PROJECT_NAME}" OFF)

	IF(${PROJECT_NAME}_ENABLE_TESTS)
		ENABLE_TESTING()
		
		#copying data for tests
		IF(EXISTS "${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR}" AND IS_DIRECTORY "${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR}")
		    #message(STATUS "adding copy command for ${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR}")
		    ADD_CUSTOM_COMMAND( TARGET ${PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_directory 
			    "${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR}"
			    "${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR}"
			    COMMENT
			    "Copying ${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR} to ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR}"
			    VERBATIM)
        ENDIF()
		
		IF ( ${ARGC} EQUAL 1 )
			FILE(GLOB testsource RELATIVE ${PROJECT_SOURCE_DIR} ${${PROJECT_NAME}_TEST_DIR}/${test_name}.c ${${PROJECT_NAME}_TEST_DIR}/${test_name}.cc ${${PROJECT_NAME}_TEST_DIR}/${test_name}.cpp )
			MESSAGE ( STATUS "== Detected ${test_name} Source : ${testsource}" )
		ELSE ( ${ARGC} EQUAL 1 )
			set( testsource "" )
			#To make sure the sources file exists
			foreach( testsrc ${ARGN} )
				set ( testsrc ${${PROJECT_NAME}_TEST_DIR}/${testsrc} )
				IF (NOT EXISTS ${PROJECT_SOURCE_DIR}/${testsrc})
					MESSAGE ( FATAL_ERROR "${testsrc} Not Found !" )
				ELSE ( NOT EXISTS ${PROJECT_SOURCE_DIR}/${testsrc})
					SET (testsource ${testsource} ${testsrc})
				ENDIF (NOT EXISTS ${PROJECT_SOURCE_DIR}/${testsrc})
			endforeach( testsrc ${ARGN} )
			MESSAGE ( STATUS "== Detected ${test_name} Source : ${testsource}" )
		ENDIF ( ${ARGC} EQUAL 1 )

		IF (testsource)

			#Format test source code if formatting project
			IF ( ${PROJECT_NAME}_CODE_FORMAT )
				WkWhitespaceSplit( testsource testsource_spc )
				#message ( "Sources :  ${testsource_spc}" )
				set ( cmdline " ${WKCMAKE_AStyle_EXECUTABLE} --style=${${PROJECT_NAME}_CODE_FORMAT_STYLE} ${testsource_spc}" )
				#message ( "CMD : ${cmdline} " )
				ADD_CUSTOM_TARGET(${PROJECT_NAME}_${test_name}_format ALL sh -c ${cmdline} WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}" VERBATIM )
			ENDIF ( ${PROJECT_NAME}_CODE_FORMAT )


			#Create output directories
			IF ( NOT EXISTS ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_TEST_DIR} )
				FILE ( MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_TEST_DIR} )
			ENDIF ( NOT EXISTS ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_TEST_DIR} )
		
			#Set where test executables should be found
			SET(${PROJECT_NAME}_TESTS_OUTPUT_PATH ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_TEST_DIR} CACHE PATH "Ouput directory for ${Project} tests.")
			mark_as_advanced(FORCE ${PROJECT_NAME}_TESTS_OUTPUT_PATH)
			SET(EXECUTABLE_OUTPUT_PATH "${${PROJECT_NAME}_TESTS_OUTPUT_PATH}" CACHE INTERNAL "Internal CMake executables output directory. Do not edit." FORCE)
		
			#build
			ADD_EXECUTABLE(${test_name} ${testsource} )
			TARGET_LINK_LIBRARIES(${test_name} ${PROJECT_NAME})
			ADD_DEPENDENCIES(${test_name} ${PROJECT_NAME})
			
			#Analyse test if analysing project
			# done by target introspection -> needs to be declared after target definition
			IF ( ${PROJECT_NAME}_CODE_ANALYSIS )
				Add_WKCMAKE_Cppcheck_target(${PROJECT_NAME}_${test_name}_analysis ${PROJECT_NAME}_${test_name} "${${PROJECT_NAME}_TEST_DIR}/${test_name}-cppcheck.xml")
			ENDIF ( ${PROJECT_NAME}_CODE_ANALYSIS )

			#We need to move project libraries and dependencies to the test target location after build.
			#We need to do that everytime to make sure we have the latest version
			
			if ( ${${PROJECT_NAME}_TYPE} STREQUAL "SHARED_LIBRARY" OR ${${PROJECT_NAME}_TYPE} STREQUAL "MODULE_LIBRARY")
				ADD_CUSTOM_COMMAND( TARGET ${test_name} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:${PROJECT_NAME}>" "$<TARGET_FILE_DIR:${test_name}>"
														COMMENT "Copying $<TARGET_FILE:${PROJECT_NAME}> to $<TARGET_FILE_DIR:${test_name}>"
														VERBATIM )
			endif ( ${${PROJECT_NAME}_TYPE} STREQUAL "SHARED_LIBRARY" OR ${${PROJECT_NAME}_TYPE} STREQUAL "MODULE_LIBRARY")
			
			message ( STATUS "== Detected binary dependencies for ${test_name} : ${${PROJECT_NAME}_BINDEPENDS}" )
			message ( STATUS "== Detected source dependencies for ${test_name} : ${${PROJECT_NAME}_SRCDEPENDS}" )
			#if win32, moving all dependencies' run libraries
			if ( WIN32 )
				#needed for each run library dependency as well
				foreach ( depend ${${PROJECT_NAME}_BINDEPENDS} )
					foreach ( subdepend ${${depend}_LIBRARIES} )
						ADD_CUSTOM_COMMAND( TARGET ${test_name} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:${subdepend}>" "$<TARGET_FILE_DIR:${test_name}>" COMMENT "Copying $<TARGET_FILE:${subdepend}> to $<TARGET_FILE_DIR:${test_name}>" )
					endforeach ( subdepend ${${depend}_LIBRARIES} )
				endforeach ( depend ${${PROJECT_NAME}_BINDEPENDS} )
				foreach ( depend ${${PROJECT_NAME}_SRCDEPENDS} )
					foreach ( subdepend ${${depend}_LIBRARIES} )
						ADD_CUSTOM_COMMAND( TARGET ${test_name} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:${subdepend}>" "$<TARGET_FILE_DIR:${test_name}>" COMMENT "Copying $<TARGET_FILE:${subdepend}> to $<TARGET_FILE_DIR:${test_name}>" )
					endforeach ( subdepend ${${depend}_LIBRARIES} )
				endforeach ( depend ${${PROJECT_NAME}_SRCDEPENDS} )
			endif ( WIN32 )
			
		ENDIF (testsource)
	ENDIF(${PROJECT_NAME}_ENABLE_TESTS)

ENDMACRO(WkTestBuild test_name)



#
# WkTestData( test_name [ datafile1 [ datafile2 [ ... ] ] ] )
# Copy the data associated to test from the test directory in the source_path,
# to the binary_path, at the root
#
MACRO (WkTestData test_name )

	foreach ( test_data ${ARGN} )
		
		# warning : tests are run from the project root...
		#FILE(TO_NATIVE_PATH ${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR}/${test_data} ${test_data}_NATIVE_SRC_PATH)
		#FILE(TO_NATIVE_PATH ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR}/${test_data} ${test_data}_NATIVE_BLD_PATH)
		#ADD_CUSTOM_COMMAND( TARGET ${test_name} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy "${${test_data}_NATIVE_SRC_PATH}" "${${test_data}_NATIVE_BLD_PATH}" COMMENT "Copying ${${test_data}_NATIVE_SRC_PATH} to ${${test_data}_NATIVE_BLD_PATH}" VERBATIM)
		ADD_CUSTOM_COMMAND( TARGET ${test_name} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy 
			"${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR}/${test_data}"
			"${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR}/${test_data}"
			COMMENT
			"Copying ${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR}/${test_data} to ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR}/${test_data}"
			VERBATIM)

		#message ("test data src: ${PROJECT_SOURCE_DIR}/${${PROJECT_NAME}_TEST_DIR}/${${PROJECT_NAME}_TEST_DATA_DIR}/${test_data}")
		#message ("test data dest: ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_TEST_DATA_BUILD_DIR}/${test_data}")
	
	endforeach ( test_data ${ARGN} )
	
ENDMACRO (WkTestData data_path)

#
# Calls the same test executable multiple times, eachtime with 1 argument
#
# WkTestRun( test_display test_name [ arguments [...] ] )
#

MACRO(WkTestRun test_display test_name )

	IF(${PROJECT_NAME}_ENABLE_TESTS)
		ENABLE_TESTING()
		ADD_TEST(${test_display} ${PROJECT_BINARY_DIR}/${${PROJECT_NAME}_TEST_DIR}/${test_name} ${ARGN})
	ENDIF(${PROJECT_NAME}_ENABLE_TESTS)

ENDMACRO(WkTestRun)

