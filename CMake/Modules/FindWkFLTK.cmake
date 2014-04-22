# - Try to find FLTK
# Once done, this will define 
#  FLTK_INCLUDE_DIRS, where to find wx.h
#  FLTK_LIBRARIES, the libraries needed to use wxWidgets.
#  FLTK_FOUND, If false, do not try to use wxWidgets.
#
include(LibFindMacros)

#TODO : wrap CMake wxWidgets in an easy to use / wkcmake module
#Dependencies

#custom : forcing wxwidgets root dir
libfind_package(WkFLTK FLTK)

# set the include dir variables and the libraries and let libfind_process do the rest
# NOTE : Singular variables for this library, plural for libraries this lib depends on.
set(WkFLTK_PROCESS_INCLUDES FLTK_INCLUDE_DIR )
set(WkFLTK_PROCESS_LIBS FLTK_BASE_LIBRARY FLTK_FORMS_LIBRARY FLTK_GL_LIBRARY FLTK_IMAGES_LIBRARY)

libfind_process(WkFLTK)







