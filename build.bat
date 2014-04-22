@echo off
setlocal

cd ProjectC && build.bat & cd ..
cd ProjectCsub && build.bat & cd ..
