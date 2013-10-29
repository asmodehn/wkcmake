WkCMake is aimed at simplifying CMake builds by making some assumptions :
- The hierarchy of project you are using is usually the same for all your projects.
- You are only working on one project at a time, that is one main target only. Other target are only simple tests ( or unit tests ) without other dependencies than the main target.

Making these assumption enable us to build a generic build framework, simple to use and very useful for many kind of C/C++ projects.

WkCMake currently supports :

- only one main target per project hierarchy
- Few simple executable tests ( in test/ subdirectory ) that don't require additional dependencies
- target can be executable, library shared or static (module not tested yet, need a Mac...)
- auto after-build dependency ( in another Wk build directory, automatically finding and importing all needed details )

WkCMake will eventually support :
- Doxygen generated documentation
- Simple Memory Leak detector for C/C++
- Simple Profiler use ??
- Support cppunit ??
- etc.

Released under Modified BSD License. Please check the LICENSE.txt file. 