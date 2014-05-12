wkcmake
=======

WkCMake is aimed at simplifying CMake builds by making some assumptions :
 - The hierarchy of project you are using is usually similar between all of your projects,  a source directory, a header directory, some data and some tests, maybe...
 - You are only working on one project at a time, that is one main target only. Other target are only simple tests ( or unit tests ) without other dependencies than the main target.
 - It s easier to rerun "cmake" once, using the cached values on the build, rather than modifying many configuration files everywhere.

Making these assumption enable us to build a generic build framework, simple to use and very useful for many kind of C/C++ projects.

WkCMake currently supports :

 - Only one main target per project hierarchy 
 - Few simple executable tests ( in test/ subdirectory ) that don't require additional dependencies
 - Target can be executable, library shared or static (module not tested yet, need a Mac...)
 - Auto after-build dependency ( in another Wk build directory, automatically finding and importing all needed files, run time libraries, etc. )
 - Auto AStyle source reformatting
 - Doxygen generated documentation

WkCMake will eventually support :
 - Simple Memory Leak detector for C/C++
 - Simple Profiler use ??
 - Generate UML diagrams from precompiled code ?? ( Need to find a proper XMI / UML diagram generator from source... )
 - Support cppunit ??
 - etc.

Released under Modified BSD License. Please check the LICENSE.txt file.

