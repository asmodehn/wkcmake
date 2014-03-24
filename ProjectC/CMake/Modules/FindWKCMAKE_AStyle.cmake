# - This module looks for AStyle
# AStyle is a source code formatting tool see http://astyle.sourceforge.net
# This code sets the following variables:
#  AStyle_EXECUTABLE     = The path to the astyle command.
#  AStyle_FOUND		 = Whether the astyle tool has been found

MESSAGE(STATUS "Looking for astyle...")

#Downloading in Source directory by default ( part of tools used for this build, not part of this build )
SET(AStyle_path "${WKCMAKE_DIR}/AStyle")

FIND_PROGRAM(WKCMAKE_AStyle_EXECUTABLE
  NAMES astyle AStyle.exe
  PATHS "${AStyle_path}/bin"
#  PATHS "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\doxygen_is1;Inno Setup: App Path]/bin"
#  /Applications/Doxygen.app/Contents/Resources
#  /Applications/Doxygen.app/Contents/MacOS
  DOC "AStyle Source Code Formatting tool adapted for WkCMake (https://github.com/asmodehn/wkcmake-astyle)"
)

IF (WKCMAKE_AStyle_EXECUTABLE)
  SET (WKCMAKE_AStyle_FOUND "YES")
  MESSAGE(STATUS "Looking for astyle... - found ${WKCMAKE_AStyle_EXECUTABLE}")
ELSE (WKCMAKE_AStyle_EXECUTABLE)
  IF (WKCMAKE_AStyle_FIND_REQUIRED)
  MESSAGE(STATUS "AStyle not found on system but required. Download into WkCMake scheduled for build.")
  # If not found, download with ExternalPRoject_Add and install as wkcmake only install ( so that next configure will not download it. )
	ExternalProject_Add( AStyle
		PREFIX ${AStyle_path}
		# it seems the install_dir option doesnt work as expected...
		CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=../.. -DCMAKE_BUILD_TYPE=Release
		GIT_REPOSITORY https://github.com/asmodehn/wkcmake-astyle.git
		GIT_TAG master
		#URL https://github.com/asmodehn/wkcmake-astyle/archive/master.zip
		#INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}
		LOG_DOWNLOAD 0
		LOG_UPDATE 0
		LOG_CONFIGURE 0
		LOG_BUILD 0
		LOG_TEST 0
		LOG_INSTALL 0
	)
  #Registering astyle executable where it is supposed to end up.
  SET (WKCMAKE_AStyle_FOUND "YES")
  set (WKCMAKE_AStyle_EXECUTABLE "${AStyle_path}/bin/astyle")

  ELSE (WKCMAKE_AStyle_FIND_REQUIRED)
    MESSAGE(STATUS "Looking for astyle... - NOT found")
  ENDIF (WKCMAKE_AStyle_FIND_REQUIRED)
ENDIF (WKCMAKE_AStyle_EXECUTABLE)

MARK_AS_ADVANCED(
  WKCMAKE_AStyle_FOUND
  WKCMAKE_AStyle_EXECUTABLE
  )

