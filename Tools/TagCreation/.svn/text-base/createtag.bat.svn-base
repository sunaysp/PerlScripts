@echo off
echo start date:
date /t
echo start time:
time /T

REM set tagname and comment

SET ConfigFile=config.properties
For /F "tokens=1,2 delims==; eol=;" %%A IN (%ConfigFile%) DO (
SET  %%A=%%B
)

set /P usrname=Enter your SVN user name :
set /p passwd=Enter your SVN password :


REM Add url from which the tag has to create i.e either branch or trunk. Tag will create in destnURL folder 
set srcURL=http://blrvlin03.misys.global.ad/svn/repos/connect_portal/hie_in_a_box/branches/hie_in_a_box_Release-1.0/
set destnURL=http://blrvlin03.misys.global.ad/svn/repos/connect_portal/hie_in_a_box/tags/%tagName%/

svn list http://blrvlin03.misys.global.ad/svn/repos/connect_portal/hie_in_a_box/tags > tag.txt

FINDSTR %tagName% tag.txt 

if errorlevel 1 goto NotFound
ECHO TagName already exist
del /Q tag.txt
goto End

:NotFound

echo Creating Tag %tagName%

svn copy -r %svnREV% --parents %srcURL% %destnURL% --username=%usrname% --password=%passwd% -m "%comment%"
del /Q tag.txt  


mkdir workspace

call perl editbuild.pl %srcURL% %destnURL% "%comment%" %antpath% 

echo Do you want to delete temporary workspace....

RMDIR /S workspace

echo end time:
time /T

:End