# - Try to find MySQL++ includes and client library
# Once done, this will define 
#  MySQL++_INCLUDE_DIRS, where to find mysql.h
#  MySQL++_LIBRARIES, the libraries needed to use MySQL.
#  MySQL++_FOUND, If false, do not try to use MySQL.
#
include(LibFindMacros)

#Dependencies
libfind_package(MySQL++ MySql REQUIRED)

#Use pkg-config to get hints bout paths
#no pkg-config for now

#Include dir
FIND_PATH(MySQL++_INCLUDE_DIR
	NAMES "mysql++.h"
	PATH_SUFFIXES "mysql++"
)

FIND_LIBRARY(MySQL++_LIBRARY
	  NAMES "mysqlpp"
)

# set the include dir variables and the libraries and let libfind_process do the rest
# NOTE : Singular variables for this library, plural for libraries this lib depends on.
set(MySQLpp_PROCESS_INCLUDES MySQL++_INCLUDE_DIR MySql_INCLUDE_DIRS )
set(MySQLpp_PROCESS_LIBS MySQL++_LIBRARY MySql_LIBRARIES)

#we change the name to MySQLpp here to be able to include it in header files, define directives, etc.
libfind_process(MySQLpp)


