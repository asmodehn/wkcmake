# - This module looks for AStyle
# AStyle is a source code formatting tool see http://astyle.sourceforge.net
# This code sets the following variables:
#  AStyle_EXECUTABLE     = The path to the astyle command.
#  AStyle_FOUND		 = Whether the astyle tool has been found

MESSAGE(STATUS "Looking for astyle...")

FIND_PROGRAM(WKCMAKE_AStyle_EXECUTABLE
  NAMES astyle AStyle.exe
  PATHS "${WKCMAKE_DIR}/Utils/astyle/bin"
#  PATHS "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\doxygen_is1;Inno Setup: App Path]/bin"
#  /Applications/Doxygen.app/Contents/Resources
#  /Applications/Doxygen.app/Contents/MacOS
  DOC "AStyle Source Code Formatting tool (http://astyle.sourceforge.net)"
)

IF (WKCMAKE_AStyle_EXECUTABLE)
  SET (WKCMAKE_AStyle_FOUND "YES")
  MESSAGE(STATUS "Looking for astyle... - found ${WKCMAKE_AStyle_EXECUTABLE}")
ELSE (WKCMAKE_AStyle_EXECUTABLE)
  IF (WKCMAKE_AStyle_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Looking for astyle... - NOT found")
  ELSE (WKCMAKE_AStyle_FIND_REQUIRED)
    MESSAGE(STATUS "Looking for astyle... - NOT found")
  ENDIF (WKCMAKE_AStyle_FIND_REQUIRED)
ENDIF (WKCMAKE_AStyle_EXECUTABLE)

MARK_AS_ADVANCED(
  WKCMAKE_AStyle_FOUND
  WKCMAKE_AStyle_EXECUTABLE
  )

