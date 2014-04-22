@echo off
setlocal

set BUILD_DIR="build"
set SRC_DIR="%CD%"
set BUILD_TYPE=Release
set ENABLE_TESTS=ON

set ORI_DIR=%CD%

REM this can fail if directory already exist
mkdir %BUILD_DIR%
cd %BUILD_DIR%

echo "Running in %CD% :"
cmake -DProjectCsub_BUILD_TYPE=%BUILD_TYPE% -DProjectCsub_ENABLE_TESTS=%ENABLE_TESTS% %SRC_DIR%

@echo off

@if "%VS120COMNTOOLS%"=="" (
	goto error_no_VS120COMNTOOLSDIR
	) else (
	@echo Initializing VS environment
	call "%VS120COMNTOOLS%\vsvars32.bat"
	)

@echo Building project
msbuild ProjectCsub.sln /p:Configuration=%BUILD_TYPE%

ctest

cd %ORI_DIR%
endlocal
goto end


:error_no_VS120COMNTOOLSDIR
@echo ERROR: Cannot determine the location of the VS 12.0 Common Tools folder.
@goto end

:end
