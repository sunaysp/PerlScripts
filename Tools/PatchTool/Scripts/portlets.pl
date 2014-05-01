#Perl script to copy liferay-plugins-sdk-6.0-ee-sp1(PluginSDK)/portlets related classfiles,jsps and all other changes into patch location.
use File::Copy;
open(F,"<logs/portletchanges.txt") or die("Cannot open file");
open(A,">>logs/AntBuild.log") or warn("Cannot open file");

$workspace=$ARGV[0];
$patchdir=$ARGV[1];

while($line=<F>) {
	chomp($line);
	if($line=~/(\/portlets\/)(.*?)(\/.*\/src\/)(.*\/)(.*)(\.java)/i) {
		$src="$workspace\\src\\AutomatedBuildScripts\\build\\pluginSDK\\portlets\\$2\\docroot\\WEB-INF\\classes\\$4$5\.class";
		$classname=$5."\.class";
		$dest="$patchdir\\Liferay\\jboss-as\\server\\default\\deploy\\$2.war\\WEB-INF\\classes\\$4";
		$src=~s/\//\\/g;
		$dest=~s/\//\\/g;
		$status=copy($src,$dest) or die("Cannot copy $classname file");
		if($status==1) { 
			print A "$classname is copied\n";
		}
		next;
	}
	if($line=~/(\/portlets\/)(.*?)(\/.*\/src\/)(.*\/)?(.*\..*)/i) {
		$filename=$5;
		$src="$workspace\\src\\AutomatedBuildScripts\\build\\pluginSDK\\portlets\\$2$3$4$5";
		$dest="$patchdir\\Liferay\\jboss-as\\server\\default\\deploy\\$2.war\\WEB-INF\\classes\\$4";
		#print "Filename = $4\n";
		$src=~s/\//\\/g;
		$dest=~s/\/docroot\//\\/g;
		$dest=~s/\//\\/g;
		$status=copy($src,$dest) or die("Cannot copy $filename");
		if($status==1) { 
			print A "$filename is copied\n";
		}	
		next;
	}

	if($line=~/(\/portlets\/)(.*?)(\/.*\/)(.*\..*)/i) {
		$filename=$4;
		$src="$workspace\\src\\AutomatedBuildScripts\\build\\pluginSDK\\portlets\\$2$3$4";
		$dest="$patchdir\\Liferay\\jboss-as\\server\\default\\deploy\\$2.war$3";
		#print "Filename = $4\n";
		$src=~s/\//\\/g;
		$dest=~s/\/docroot\//\\/g;
		$dest=~s/\//\\/g;
		$status=copy($src,$dest) or die("Cannot copy $filename");
		if($status==1) { 
			print A "$filename is copied\n";
		}	
		next;
	}
	
}