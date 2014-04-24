@echo off

setlocal

set BUILD_DIR="build"
set SRC_DIR="%CD%"
set BUILD_TYPE=Release
set ENABLE_TESTS=ON

set ORI_DIR=%CD%

@echo Building binary depend ..\ProjectC
cd "..\ProjectC" && call build.bat
cd %ORI_DIR%

@echo Building binary depend Custom Depend\ProjectDsub_bin
cd "Custom Depend\ProjectDsub_bin" && call build.bat 
cd %ORI_DIR%

@echo Source depend will be built with the current project

REM this can fail if directory already exist
mkdir %BUILD_DIR%
cd %BUILD_DIR%

echo "Running in %CD% :"
rem ProjectDsub_DIR will be found automatically by wkcmake as it is a subdirectory
cmake -DProjectB_BUILD_TYPE=%BUILD_TYPE% -DProjectB_ENABLE_TESTS=%ENABLE_TESTS% -DProjectC_DIR="..\ProjectC\build" %SRC_DIR%

@echo off

@if "%VS120COMNTOOLS%"=="" (
	goto error_no_VS120COMNTOOLSDIR
	) else (
	@echo Initializing VS environment
	call "%VS120COMNTOOLS%\vsvars32.bat"
	)

@echo Building project
msbuild ProjectB.sln /p:Configuration=%BUILD_TYPE% /verbosity:minimal

ctest

cd %ORI_DIR%
endlocal
goto end


:error_no_VS120COMNTOOLSDIR
@echo ERROR: Cannot determine the location of the VS 12.0 Common Tools folder.
@goto end

:end
