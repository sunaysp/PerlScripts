echo OFF

REM ############### reading values from patch.properties file ##############################

SET ConfigFile=patch.properties
For /F "tokens=1,2 delims==; eol=;" %%A IN (%ConfigFile%) DO (
SET  %%A=%%B
)

REM #################################################################################


SET fromtagURL=http://blrgt75:8802/svn/connect_portal/hie_in_a_box/tags/%fromtag%

SET totagURL=http://blrgt75:8802/svn/connect_portal/hie_in_a_box/tags/%totag%

SET workspacedir=%cd%

SET liferaytemplate=FolderStructure

REM #### Delete temporary files #####


IF NOT EXIST %patchdir% mkdir %patchdir%

IF NOT EXIST logs goto DELSRC 

echo Deleting all txt and log files. Cleaning workspace

RMDIR /s /q logs

:DELSRC

IF NOT EXIST src goto START

echo Deleting src folder. 

RMDIR /s /q src

:START

mkdir logs 

echo #########  Patch Creation started on %date% %time%  #########  

svn diff %fromtagURL% %totagURL% --summarize > logs\diffAll.log

call perl Scripts\dobuild.pl logs\diffAll.log

:ANTBUILD

echo  ######### Ant build started ######### 

echo "Checking out %totagURL% now "

call Scripts\AntBuild.bat %totagURL% > logs\AntBuild.log

echo  ######### Ant build is done ######### 

FINDSTR /C:"BUILD FAILED" logs\BUILD_FAILED.txt 

IF %ERRORLEVEL% EQU 0 GOTO FAILED 

echo ####### Copying Liferay's template and jars into patch directory ####### 

XCOPY /E /I /Y /Q %liferaytemplate%\* %PatchDir%\

IF NOT EXIST logs\PortalInfra-src.txt GOTO PIGLOBAL
echo ### copying jars ###

XCOPY /E /I /Y /Q %workspacedir%\src\AutomatedBuildScripts\build\pluginSDK\ext\moss-ext\docroot\WEB-INF\ext-lib\portal\hieportal-commons-v0_1.jar %patchdir%\Liferay\jboss-as\server\default\deploy\ROOT.war\WEB-INF\lib\
echo hieportal-commons-v0_1.jar is copied.

:PIGLOBAL
IF NOT EXIST logs\PortalInfra-global.txt GOTO HIESERVICE

XCOPY /E /I /Y /Q %workspacedir%\src\AutomatedBuildScripts\build\pluginSDK\ext\moss-ext\docroot\WEB-INF\ext-lib\global\hieportal-utils-v0_1.jar %patchdir%\Liferay\jboss-as\server\default\lib\
echo hieportal-utils-v0_1.jar is copied

:HIESERVICE
IF NOT EXIST logs\HIEServices.txt GOTO SERVICE

call perl Scripts\HIEservice.pl %workspacedir% %patchdir%

:SERVICE
IF NOT EXIST logs\services.txt GOTO REMOTESERVICE

call perl Scripts\services.pl %workspacedir% %patchdir%


:REMOTESERVICE
IF NOT EXIST logs\IHERemoteServices.txt GOTO PORTLETS

call perl Scripts\remoteservices.pl %workspacedir% %patchdir%


:PORTLETS
IF NOT EXIST logs\portletchanges.txt GOTO EXT

call perl Scripts\portlets.pl %workspacedir% %patchdir%


:EXT
IF NOT EXIST logs\extchanges.txt GOTO HOOKS

call perl Scripts\ext.pl %workspacedir% %patchdir%

:HOOKS
IF NOT EXIST logs\hookschanges.txt GOTO END

call perl Scripts\hooks.pl %workspacedir% %patchdir%


echo Patch creation is successful. Patch is found in %patchdir% location. 
GOTO END

:FAILED
echo Build is failed. Terminating the process. 
GOTO END

:END 
echo END
echo End time: %time%

echo Check AntBuild.log and other log files in log folder for more information.
