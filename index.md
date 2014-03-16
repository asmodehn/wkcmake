---
layout: page
title: WkCMake
tagline: The Workshop CMake
---
{% include JB/setup %}

## What is WkCMake

An easy-to-use portable C++ Build Framework.
It s possible to make your cross-platform C++ building life much easier, just by making few simple and sensible assumptions such as :

 - The project hierarchy is similar in all projects
 - The code structure is similar on all platforms
 - You will build your different libraies before including them in other projects
 - You want to test and document your code without bothering about all the side tools you need
 - you want your sources to be added where needed, automatically whenever it s possible.
 - you want your dependencies to be added where needed, automatically whenever it s possible.

## What does it do?

WkCMake gives you a few very useful features and make your life easier by :

 - Making your project start easier,
 - Greatly simplifying your build scripts,
 - Simple test builds and run ( CppUnit to come )
 - Automatic Source Code formatting with astyle
 - Automatic Documentation generation with doxygen
 - Automatic dependency detection and propagation
 - Automatically detecting memory leaks ( Dr.Memory to come )
 - Simplifying profiler builds and usage ( to come )
 - Simplifying installer routines ( to come )
 - Simpler multi-platform packaging ( to come )

## How is it made?

WkCMake heavily depends on **CMake**, and a few other optional tools such as doxygen, astyle, etc.
It s a set of CMake scripts you need to include in your CMakeLists.txt to make your cmake build scripts even easier.
A non exhaustive list of scripts :

 - WkCMake : Main script, you need to include it and call WkCMakeDir() to define where your WkCMake distribution is located. Everything you need for basic builds will be automatically included and configured
 - WkBuild : Script containing building macros ( and dependency inclusion for compilation )
 - WkLink : Script containint linking macros ( and dependency inclusion for linkage )
 - Even more stuff...

## Great - Where should I start ?

WkCMake is very easy to start with, just have a look at ours tutorials and start a new simple projects.

### Simple Tutorial

What you Need to know and use for a quick start:
[Simple Tutorial](tutorial.html)

### Advanced Tutorial

A full and complete tutorial that covers almost everything you can use
[Advanced Tutorial](adv_tutorial.html)

You can also have a look at our tests projects and the reference documentation to have a closer look at how it s actually done under the hood

### Reference

[Complete scripts reference](script_ref.html)

After you grasp how it all works together, feel free to add recipes to our cookbook.

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

If you want to participate in any way - we especially need lots of testers on a wide set of platforms, and people keen to integrate new useful tools in the build process - feel free to have a look at the project on GitHub.

AlexV `asmodehn`

