#Perl script to copy liferay-plugins-sdk-6.0-ee-sp1(PluginSDK)/hooks related classfiles and other changes into patch location.
use File::Copy;
open(F,"<logs/hookschanges.txt") or die("Cannot open file");
open(A,">>logs/AntBuild.log") or warn("Cannot open file");

$workspace=$ARGV[0];
$patchdir=$ARGV[1];

while($line=<F>) {
	chomp($line);
	if($line=~/(\/hooks\/)(.*\/src\/)(.*\/)(.*)(\.java)/i) {
		$file=$4."\.class";
		$src="$workspace\\src\\AutomatedBuildScripts\\build\\pluginSDK\\hooks\\moss-hook\\docroot\\WEB-INF\\classes\\$3$4.class";
		$dest="$patchdir\\Liferay\\jboss-as\\server\\default\\deploy\\moss-hook\.war\\WEB-INF\\classes\\$3";
		$src=~s/\//\\/g;
		$dest=~s/\//\\/g;
		$status=copy($src,$dest) or warn("Could not copy $file");
		if($status==1) { 
			print A "$file is copied\n";
		}	
		next;
	}
	if($line=~/(\/hooks\/)(.*\/src\/)(.*\/)?(.*\..*)/i) {
		$file=$3.$4;
		#print "$file\n";
		$src="$workspace\\src\\AutomatedBuildScripts\\build\\pluginSDK\\hooks\\$2$3$4";
		$dest="$patchdir\\Liferay\\jboss-as\\server\\default\\deploy\\moss-hook\.war\\WEB-INF\\src\\$3";
		$src=~s/\//\\/g;
		$dest=~s/\//\\/g;
		$dest=~s/\\docroot\\/\\/;
		# print "$src\n";
		# print "$dest\n";
		$status=copy($src,$dest) or warn("Could not copy $file");
		if($status==1) {
			print A "$file is copied\n";
		}	
		next;
	}
	if($line=~/(\/hooks\/)(.*\/moss_jsps\/)(.*\/)?(.*\..*)/i) {
		$file=$4;
		$src="$workspace\\src\\AutomatedBuildScripts\\build\\pluginSDK\\hooks\\$2$3$4";
		$dest="$patchdir\\Liferay\\jboss-as\\server\\default\\deploy\\ROOT.war\\$3";
		$src=~s/\//\\/g;
		$dest=~s/\//\\/g;
		$status=copy($src,$dest) or warn("Could not copy $file");
		if($status==1) {
			print A "$file is copied\n";
		}	
	}
}
	
