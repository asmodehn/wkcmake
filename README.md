WkCmake Tests [![Build Status](https://travis-ci.org/asmodehn/wkcmake.png?branch=test)](https://travis-ci.org/asmodehn/wkcmake)
=============

WkCMake is aimed at simplifying CMake builds by making some assumptions :

- The hierarchy of project you are using is usually similar between all of your projects,  a source directory, a header directory, some data and some tests, maybe...
- You are only working on one project at a time, that is one main target only. Other target are only simple tests ( or unit tests ) without other dependencies than the main target.
- It s easier to rerun "cmake" once, using the cached values on the build, rather than modifying many configuration files everywhere.

Making these assumption enable us to build a generic build framework, simple to use and very useful for many kind of C/C++ projects.

This is the test branch of the wkcmake project.
It contains a list of sample projects, that are used to test wkcmake.
Each of these project refers to the master branch as a subtree

To test one project on Windows :

`> cd TestProject`<br/>
`> build.bat`

To test one project on Unix / Linux

`> cd TestProject`<br/>
`> sh build.sh`

To get updates from wkcmake master branch using subtree command :

`> git subtree pull --prefix=TestProject/CMakeDir . master [--squash]`
> 
The log on an uptodate subtree is :
>From . <br/>
> * branch	master -> FETCH_HEAD <br/>
>Already up-to-date


To send updates to wkcmake master branch using subtree command :

`git subtree push --prefix=TestProject/CMakeDir . master`

The log on an uptodate subtree is :
>git push using: . master <br/>
>1/	2 (0)2/		2 (0) Everything up-to-date <br/>


Project A - B - C
=================
This is an example hierarchy to be used along with WkCMake framework.
In this Hierarchy A depends on B and B depends on C
C is always a shared library or a module
B is a library. it is up to the builder to make it a shared library, or a static one, and have it embedded in A
The dependency mechanism should always detect which library are needed to link and run with A

Modules tests
=============
MySql is a test project for the detection of libmysqlclient-dev library
MySQL++ is a test project for the detection of libmysql++-dev library
Bullet is a test project for the detection of Bullet physics engine - TODO : fix it : At the moment bullet doesnt support being in a shared library on amd64 architectures
LuaJIT is a test project for the detection of LuaJIT

TODO
====
- [ ] we need one test project per module, to make sure modules are found properly and can find and link system packages properly.
- [ ] we need to review the codeblock project generated for A-B-C. There is a possibility to not have full path in C::B gui. We need to implement it
- we need to review our compiler setup vs C++11
- [ ] we need to not force compiler setup. because we cannot plan future cmake compiler options. and because other cmake projects( which can have WkCMake project dependencies) might have different compile / linking options
- we need to have one consistent way of finding sources, headers, etc. ( target introspection like cppcheck, or directly like astyle... )

