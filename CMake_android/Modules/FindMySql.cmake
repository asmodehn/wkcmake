# - Try to find MySQL includes and client library
# Once done, this will define 
#  MySql_INCLUDE_DIRS, where to find mysql.h
#  MySql_LIBRARIES, the libraries needed to use MySQL.
#  MySql_FOUND, If false, do not try to use MySQL.
#
include(LibFindMacros)

#Dependencies
#NONE

#Use pkg-config to get hints bout paths
#no pkg-config for now

#Use mysql-config to get hints about paths
find_program(MySql_CONFIG 
	NAMES mysql_config
)
    
if(MySql_CONFIG)
	message(STATUS "Using mysql-config: ${MySql_CONFIG}")
	# set INCLUDE_DIR
	exec_program(${MySql_CONFIG}
            ARGS --include
            OUTPUT_VARIABLE MY_TMP)

        string(REGEX REPLACE "-I([^ ]*)( .*)?" "\\1" MY_TMP "${MY_TMP}")

        set(MySql_CONFIG_INCLUDE_DIR ${MY_TMP} CACHE FILEPATH INTERNAL)

        # set LIBRARY_DIR
        exec_program(${MySql_CONFIG}
            ARGS --libs_r
            OUTPUT_VARIABLE MY_TMP)

        set(MySql_CONFIG_LIBRARIES "")

        string(REGEX MATCHALL "-l[^ ]*" MySql_LIB_LIST "${MY_TMP}")
        foreach(LIB ${MySql_LIB_LIST})
            string(REGEX REPLACE "[ ]*-l([^ ]*)" "\\1" LIB "${LIB}")
            list(APPEND MySql_CONFIG_LIBRARIES "${LIB}")
        endforeach(LIB ${MySql_LIBS})

        set(MySql_CONFIG_LIBRARY_PATH "")

        string(REGEX MATCHALL "-L[^ ]*" MySql_LIBDIR_LIST "${MY_TMP}")
        foreach(LIB ${MySql_LIBDIR_LIST})
            string(REGEX REPLACE "[ ]*-L([^ ]*)" "\\1" LIB "${LIB}")
            list(APPEND MySql_CONFIG_LIBRARY_PATH "${LIB}")
        endforeach(LIB ${MySql_LIBS})

else(MySql_CONFIG)
        set(MySql_CONFIG_LIBRARIES "")
        list(APPEND MySql_CONFIG_LIBRARIES "mysqlclient")
endif(MySql_CONFIG)

#Include dir
FIND_PATH(MySql_INCLUDE_DIR 
	NAMES mysql.h
	PATHS ${MySql_CONFIG_INCLUDE_DIR}
	PATH_SUFFIXES mysql
)

#Libraries
FIND_LIBRARY(MySql_LIBRARY
	NAMES ${MySql_CONFIG_LIBRARIES}
	PATHS ${MySql_CONFIG_LIBRARY_PATH}
	PATH_SUFFIXES mysql
)

# set the include dir variables and the libraries and let libfind_process do the rest
# NOTE : Singular variables for this library, plural for libraries this lib depends on.
set(MySql_PROCESS_INCLUDES MySql_INCLUDE_DIR )
set(MySql_PROCESS_LIBS MySql_LIBRARY )

libfind_process(MySql)







