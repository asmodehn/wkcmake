# - Try to find Bullet
# Once done this will define
#
# Bullet_FOUND - system has Bullet
# Bullet_INCLUDE_DIRS - the Bullet include directories
# Bullet_LIBRARIES - link these to use Bullet

include(LibFindMacros)

#Dependencies
#NONE

# Use pkg-config to get hints about paths
# NO pkg-config for now at least

# Include dir
#paths is there to work around bug in cmake 2.6 on debian
# no_default_path avoid stupid path being setup by cmake
find_path(Bullet_INCLUDE_DIR
	NAMES btBulletDynamicsCommon.h
	PATH_SUFFIXES bullet Bullet
	)

# libraries
#TODO : separate into COMPONENTS properly if possible
find_library(Bullet_COLLISION_LIBRARY
	NAMES BulletCollision
	)
find_library(Bullet_DYNAMICS_LIBRARY 
	NAMES BulletDynamics
	)
find_library(Bullet_MULTITHREADED_LIBRARY 
	NAMES BulletMultiThreaded
	)
find_library(Bullet_SOFTBODY_LIBRARY 
	NAMES BulletSoftBody
	)
find_library(Bullet_SOFTBODYSOLVERS_LIBRARY 
	NAMES BulletSoftBodySolvers_CPU BulletSoftBodySolvers_OpenCL_Mini
	)
find_library(Bullet_MATH_LIBRARY
	NAMES LinearMath
	)
find_library(Bullet_MINICL_LIBRARY 
	NAMES MiniCL
	)

# Set the include dir variables and the variables and let libfind_process do the rest.
# NOTE : Singular variables for this library, plural for libraries this lib depends on
set(Bullet_PROCESS_INCLUDES Bullet_INCLUDE_DIR)
set(Bullet_PROCESS_LIBS	Bullet_SOFTBODY_LIBRARY
			Bullet_SOFTBODYSOLVERS_LIBRARY
			Bullet_DYNAMICS_LIBRARY
			Bullet_COLLISION_LIBRARY
			Bullet_MINICL_LIBRARY
			Bullet_MATH_LIBRARY
			Bullet_MULTITHREADED_LIBRARY
)

libfind_process(Bullet)

