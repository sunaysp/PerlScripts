#Perl script to copy liferay-plugins-sdk-6.0-ee-sp1(PluginSDK)/ext related jars and web changes into patch location.
use File::Copy;
open(F,"<logs/extchanges.txt") or die("Cannot open file");
open(A,">>logs/AntBuild.log") or warn("Cannot open file");

$workspace=$ARGV[0];
$patchdir=$ARGV[1];

$isImplJarCopied=0;
$isUtilJarCopied=0;
$isServiceJarCopied=0;

while($line=<F>) {
	chomp($line);
	if($line=~/\/ext-impl\/.*/i && $isImplJarCopied==0) {
		#print $line;
		$src="$workspace\\src\\AutomatedBuildScripts\\build\\pluginSDK\\ext\\moss-ext\\docroot\\WEB-INF\\ext-impl\\ext-impl.jar";
		$dest="$patchdir\\Liferay\\jboss-as\\server\\default\\deploy\\ROOT.war\\WEB-INF\\lib\\ext-moss-ext-impl.jar";
		$status=copy($src,$dest) or warn("could not copy ext-impl jar");
		if($status==1) { 
			print A "ext-impl jar is copied\n";
		}
		$isImplJarCopied=1;
		next;
	}
	if($line=~/\/ext-util-java\/.*\.java/i && $isUtilJarCopied==0) {
		$src="$workspace\\src\\AutomatedBuildScripts\\build\\pluginSDK\\ext\\moss-ext\\docroot\\WEB-INF\\ext-util-java\\ext-util-java.jar";
		$dest="$patchdir\\Liferay\\jboss-as\\server\\default\\deploy\\ROOT.war\\WEB-INF\\lib\\ext-moss-ext-util-java.jar";
		$status=copy($src,$dest) or warn("could not copy ext-util-java jar");
		if($status==1) {
			print A "ext-util-java jar is copied\n";
		}	
		$isUtilJarCopied=1;
		next;
	}
	if($line=~/\/ext-service\/.*\.java/i && $isServiceJarCopied==0) {
		$src="$workspace\\src\\AutomatedBuildScripts\\build\\pluginSDK\\ext\\moss-ext\\docroot\\WEB-INF\\ext-service\\ext-service.jar";
		$dest="$patchdir\\Liferay\\jboss-as\\server\\default\\lib\\ext-moss-ext-service.jar";
		$status=copy($src,$dest) or warn("could not copy ext-service jar");
		if($status==1) {
			print A "ext-service jar is copied\n";
		}	
		$isServiceJarCopied=1;
		next;
	}
	if($line=~/(\/ext-web\/)(.*\/)?(.*\..*)/i) {
		$filename=$3;
		$temp=$2.$3;
		$src="$workspace\\src\\AutomatedBuildScripts\\build\\pluginSDK\\ext\\moss-ext\\docroot\\WEB-INF\\ext-web\\$temp";
		$dest="$patchdir\\Liferay\\jboss-as\\server\\default\\deploy\\ROOT.war\\$temp";
		$src=~s/\//\\/g;
		$dest=~s/\//\\/g;
		$dest=~s/\\docroot\\/\\/;
		$status=copy($src,$dest) or warn("could not copy $filename");
		if($status==1) {
			print A "$filename is copied\n";
		}	
		next;
	}
	
}