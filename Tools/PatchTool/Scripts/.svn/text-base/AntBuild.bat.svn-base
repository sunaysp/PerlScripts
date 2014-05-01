REM #### ANT BUILD ######
REM This file creates src folder and checkout all the project and will do the build. Build status text file will be created.
SET TagURL=%1

mkdir src
cd src

svn export "%TagURL%/portal/AutomatedBuildScripts"

cd AutomatedBuildScripts

ECHO Copying user properties file to build location
echo properties file is %build-username-properties%

copy %build-username-properties% 

echo Tag export is completed. Starting Build now. 
call ant

cd../..

FINDSTR /C:"BUILD SUCCESSFUL" logs\AntBuild.log > logs\BUILD_SUCCESSFUL.txt
FINDSTR /C:"BUILD FAILED" logs\AntBuild.log > logs\BUILD_FAILED.txt
