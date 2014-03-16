---
layout: post
title: "Basic Tutorial"
description: ""
category: 
tags: [tutorial]
---
{% include JB/setup %}

## WkCMake : Simple Tutorial

This simple tutorial will demonstrate how to create a simple cmakelist file usable for any project that does not require external dependencies, data and such.

| As with all Cmake projects you need to start by creating a CMakeLists.txt inside your project root. Then you need to fill it.
| 
 
**First** you need to begin with wkcmake call::

 	CMAKE_MINIMUM_REQUIRED(VERSION 2.6 FATAL_ERROR )
 	INCLUDE ( WkCMake_Dir/WkCMake.cmake )
 	WkCMakeDir ( WkCMake_Dir )

| In this section we simply indicate the minimum version of cmake compatible with WkCmake (aka 2.6 and newer).
| Then we call WkCmake by loading the main file "WkCMake.cmake" and by defining the WkCMakeDir to where you have set your WkCmake copy (for example i generally locate it inside a WkCmake folder filled by a svn external).
|

**Second step** is to define your project name and language::

	WkProject( Project_Name CXX )

| Here we set the project name to Project_Name and the language of the project to C++.
| Languages available are: C for C language, CXX for C++, Java for Java (not supported yet?). Please referer yourself to the `Project command
 <http://www.cmake.org/cmake/help/cmake-2.6.html#command:project>`_ from cmake for more info of these values.
| 

**Finally** we tell wkacmake to create a project that will be build as a shared library::

	WkBuild( LIBRARY SHARED )

| We simply call the WkBuild script with the build type in parameter.
| Type values are EXECUTABLE | LIBRARY [ STATIC|SHARED|MODULE ].
| 
 
**Now**, simply run cmake as usual, setting your source folder where the CMakeLists.txt was created and enjoy ;)

