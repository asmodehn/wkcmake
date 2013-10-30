# - This module looks for Cppcheck
# Cppcheck is a source code Analysis tool see http://cppcheck.sourceforge.net
# This code sets the following variables:
#  Cppcheck_EXECUTABLE     = The path to the cppcheck command.
#  Cppcheck_FOUND		 = Whether the cppcheck tool has been found


include(ParseArguments)

MESSAGE(STATUS "Looking for cppcheck...")

FIND_PROGRAM(WKCMAKE_Cppcheck_EXECUTABLE
  NAMES cppcheck
  PATHS "[HKEY_LOCAL_MACHINE\\Software\\Cppcheck;InstallationPath]"
  DOC "Cppcheck Source Code Analysis tool (http://cppcheck.sourceforge.net)"
)

IF (WKCMAKE_Cppcheck_EXECUTABLE)
  SET (WKCMAKE_Cppcheck_FOUND "YES")
  MESSAGE(STATUS "Looking for cppcheck... - found ${WKCMAKE_Cppcheck_EXECUTABLE}")
ELSE (WKCMAKE_Cppcheck_EXECUTABLE)
  IF (WKCMAKE_Cppcheck_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Looking for cppcheck... - NOT found")
  ELSE (WKCMAKE_Cppcheck_FIND_REQUIRED)
    MESSAGE(STATUS "Looking for cppcheck... - NOT found")
  ENDIF (WKCMAKE_Cppcheck_FIND_REQUIRED)
ENDIF (WKCMAKE_Cppcheck_EXECUTABLE)

MARK_AS_ADVANCED(
  WKCMAKE_Cppcheck_FOUND
  WKCMAKE_Cppcheck_EXECUTABLE
  )

#
# ADD_CPPCHECK_TARGET(cppcheck_new_target target_to_check filename_results)
#
MACRO (Add_WKCMAKE_Cppcheck_target cppcheck_new_target original_target filename_results)
	get_directory_property(WKCMAKE_Cppcheck_DEFINITIONS_dir ${CMAKE_SOURCE_DIRECTORY} COMPILE_DEFINITIONS)
	get_directory_property(WKCMAKE_Cppcheck_INCLUDES ${CMAKE_SOURCE_DIRECTORY} INCLUDE_DIRECTORIES)
	get_target_property(WKCMAKE_Cppcheck_DEFINITIONS_target ${original_target} COMPILE_DEFINITIONS)
	get_target_property(WKCMAKE_Cppcheck_SOURCES ${original_target} SOURCES)
	#aggregating definitions if needed
	if ( WKCMAKE_Cppcheck_DEFINITIONS_dir)
		set( WKCMAKE_Cppcheck_DEFINITIONS ${WKCMAKE_Cppcheck_DEFINITIONS_dir} )
	endif ( WKCMAKE_Cppcheck_DEFINITIONS_dir)
	if ( WKCMAKE_Cppcheck_DEFINITIONS_target)
		set( WKCMAKE_Cppcheck_DEFINITIONS ${WKCMAKE_Cppcheck_DEFINITIONS}${WKCMAKE_Cppcheck_DEFINITIONS_target} )
	endif ( WKCMAKE_Cppcheck_DEFINITIONS_target)

	#splitting variable content appropriately
	if ( WKCMAKE_Cppcheck_DEFINITIONS )
		WkCustomSplit( WKCMAKE_Cppcheck_DEFINITIONS " -D" WKCMAKE_Cppcheck_DEFINITIONS_Splitted )
		#message("DEFINITIONS : ${WKCMAKE_Cppcheck_DEFINITIONS_Splitted}")
	else ( WKCMAKE_Cppcheck_DEFINITIONS )
		message("CMake Cppcheck module couldnt detect any definitions, using default \"\"")
		set (WKCMAKE_Cppcheck_DEFINITIONS_Splitted "")
	endif ( WKCMAKE_Cppcheck_DEFINITIONS )
	if ( WKCMAKE_Cppcheck_INCLUDES )
		WkCustomSplit( WKCMAKE_Cppcheck_INCLUDES " -I" WKCMAKE_Cppcheck_INCLUDES_Splitted )
		#message("INCLUDES : ${WKCMAKE_Cppcheck_INCLUDES_Splitted}")
	else ( WKCMAKE_Cppcheck_INCLUDES )
		message("CMake Cppcheck module couldnt detect any includes, using default \"include\"")
		set (WKCMAKE_Cppcheck_INCLUDES_Splitted "include")
	endif ( WKCMAKE_Cppcheck_INCLUDES )
	if ( WKCMAKE_Cppcheck_SOURCES )
		WkCustomSplit( WKCMAKE_Cppcheck_SOURCES " " WKCMAKE_Cppcheck_SOURCES_Splitted )
		#message("SOURCES : ${WKCMAKE_Cppcheck_SOURCES_Splitted}")
	else ( WKCMAKE_Cppcheck_SOURCES )
		message("CMake Cppcheck module couldnt detect any sources, using default \"src\"")
		set (WKCMAKE_Cppcheck_SOURCES_Splitted "src")
	endif ( WKCMAKE_Cppcheck_SOURCES )
	
#combining all in one cppcheck command
	
	set(${PROJECT_NAME}_CODE_ANALYSIS_OPTIONS "-j4 --verbose" CACHE STRING "Analysis Options for Cppcheck")
	set ( cmdline " ${WKCMAKE_Cppcheck_EXECUTABLE} ${WKCMAKE_Cppcheck_DEFINITIONS_Splitted} ${WKCMAKE_Cppcheck_INCLUDES_Splitted} ${${PROJECT_NAME}_CODE_ANALYSIS_OPTIONS} --xml ${WKCMAKE_Cppcheck_SOURCES_Splitted} 2> ${PROJECT_BINARY_DIR}/${filename_results}" )
	#message ( "CMD : ${cmdline} " )
	ADD_CUSTOM_COMMAND(
		OUTPUT ${PROJECT_BINARY_DIR}/${filename_results}
		COMMAND sh -c ${cmdline}
		WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/
		COMMENT "Analysing code in ${PROJECT_SOURCE_DIR} with cppcheck ..."
		VERBATIM
	)
	ADD_CUSTOM_TARGET(${cppcheck_new_target} DEPENDS ${PROJECT_BINARY_DIR}/${filename_results})
ENDMACRO (Add_WKCMAKE_Cppcheck_target)
