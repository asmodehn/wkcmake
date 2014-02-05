set BUILD_DIR="..\ProjectCsub_build"
set SRC_DIR="%~dp0"
set BUILD_TYPE=Release
set ENABLE_TESTS=ON

cd %SRC_DIR%

if not exist %BUILD_DIR% mkdir %BUILD_DIR%

cd %BUILD_DIR% && ^
echo "Running in %SRC_DIR% :" && ^
cmake -DProjectCsub_BUILD_TYPE=%BUILD_TYPE% -DProjectCsub_ENABLE_TESTS=%ENABLE_TESTS% %SRC_DIR% && ^
echo "TODO : build VS from here" && ^
echo "TODO:  run tests from here"