@echo off
echo start date:
date /t
echo start time:
time /T

REM set branchName and comment

SET ConfigFile=config.properties
For /F "tokens=1,2 delims==; eol=;" %%A IN (%ConfigFile%) DO (
SET  %%A=%%B
)

set /P usrname=Enter your SVN user name :
set /p passwd=Enter your SVN password :


REM Add url from which the branch should create i.e either trunk or parent branch. branch will be created in destnURL folder 
set srcURL=http://blrvlin03.misys.global.ad/svn/repos/connect_portal/hie_in_a_box/trunk/
set destnURL=http://blrvlin03.misys.global.ad/svn/repos/connect_portal/hie_in_a_box/branches/%branchName%/


svn list http://blrvlin03.misys.global.ad/svn/repos/connect_portal/hie_in_a_box/branches > branch.txt

FINDSTR %branchName% branch.txt 

if errorlevel 1 goto NotFound
ECHO branchName already exist
del /Q branch.txt
goto End

:NotFound

echo Creating Branch %branchName%

svn copy -r %svnREV% --parents %srcURL% %destnURL% --username=%usrname% --password=%passwd% -m "%comment%"
del /Q branch.txt  

mkdir workspace

call perl editbuild.pl %srcURL% %destnURL% "%comment%" %antpath% 

echo Do you want to delete temporary workspace....

RMDIR /S workspace

echo end time:
time /T

:End