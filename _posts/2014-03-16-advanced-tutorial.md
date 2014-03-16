---
layout: post
title: "Advanced Tutorial"
description: ""
category: 
tags: []
---
{% include JB/setup %}

## WkCMake : Advanced Tutorial

This advanced tutorial will demonstrate how to create a simple cmakelist for a project which use dependcies, have data, specific folder names for source and such, generate it's own doc and also have tests.

**TODO**

| As with all Cmake projects you need to start by creating a CMakeLists.txt inside your project root. Then you need to fill it.
| 

**Step 1**, WkCmake call::

 	CMAKE_MINIMUM_REQUIRED(VERSION 2.6 FATAL_ERROR )
 	INCLUDE ( WkCMake_Dir/WkCMake.cmake )
 	WkCMakeDir ( WkCMake_Dir )

| In this section we simply indicate the minimum version of cmake compatible with WkCmake (aka 2.6 and newer).
| Then we call WkCmake by loading the main file "WkCMake.cmake" and by defining the WkCMakeDir to where you have set your WkCmake copy (for example i generally locate it inside a WkCmake folder filled by a svn external).
| 

**Step 2**, Setting up folder *(optional)*::
 
 	WkSrcDir ( "Custom Src" )
 	WkIncludeDir ( "Custom Include" )
 	WkBinDir ( "Custom Bin" )
 	WkLibDir ( "Custom Lib" )
 	WkDataDir ( "Custom Data")
 	WkTestDir ( "Custom Test" )
 	WkDocDir ( "Custom Doc" )

| *Blabla folder*
| *Blabla2*
| 

**Step 3,** Project declaration::

	WkProject( Project_Name CXX )

| Here we set the project name to Project_Name and the language of the project to C++.
| Languages available are: C for C language, CXX for C++, Java for Java (not supported yet?). Please referer yourself to the `Project command
 <http://www.cmake.org/cmake/help/cmake-2.6.html#command:project>`_ from cmake for more info of these values.
| 

**Step 4**, Dependencies *(optional)*::

 	WkDepends( ProjectC )
	
| *BlaBla dependency*
|

**Step 5**, Build rules::

	WkBuild( LIBRARY SHARED )

| We simply call the WkBuild script with the build type in parameter.
| Type values are EXECUTABLE | LIBRARY [ STATIC|SHARED|MODULE ].
| 
 
**Step 6**, Documentation and Subversion *(optional)*::

	WkDoc()
	WkSvn()

| *Blabla doc*
| *Blabla2*
| 

**Step 7**, Tests *(optional)*::

	WkTestBuild( maintestB )
	WkTestRun( maintestB )

| *Blabla test*
| *Blabla2*
|

**Now**, simply run cmake as usual, setting your source folder where the CMakeLists.txt was created and enjoy ;)

