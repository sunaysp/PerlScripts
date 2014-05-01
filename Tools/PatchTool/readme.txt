----------------------------------------------------------------------------------------------------------------
#### Prerequisites ####
##SOFTWARE REQUIRED TO RUN IN YOUR SYSTEM ##

1. Collabnet subversion.

2. Perl Software(preferably latest version)

----------------------------------------------------------------------------------------------------------------
####### STEPS TO USE PATCH TOOL ########

1. This tool will take two tag names as input and creates a patch which contains only changed files or difference between two tags. The resulted patch will have all the changes between two tags. Please ensure tags are proper. 

2. Check out 'PatchTool' folder from svn. 
	i. Run the below command in command prompt if svn client is installed or checkout from Tortoise SVN. 
		EX: svn checkout http://.../Scripts/PatchTool
		
4. set all the environment variables in patch.properties file. 
	 i. fromtag - Assign old tag name. 
	ii. totag - Assign new/latest tag name. The difference between these two is what we get in patch. 
   iii.	patchdir - Patch will be created in this location. 
    iv. build-username-properties = Location of build.username.properties file.

5. Open command prompt and run "createpatch.bat" file. 

------------------------------------------------------------------------------------------------------------------
####### OUTPUT #########

1. Patch will be created in "patchdir" location which is defined in createpatch.bat file. 

2. Patch will have all the modified jars and property files. 

3. Patch will have modified jsp/html files in its proper location. 


-------------------------------------------------------------------------------------------------------------------

