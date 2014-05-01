#Perl script to copy IHERemoteServices related classfiles into patch location.
use File::Copy;
open(F,"<logs/IHERemoteServices.txt") or die("Cannot open file");
open(A,">>logs/AntBuild.log") or warn("Cannot open file");

$\ = "\n";
$, = "\t";

$workspace=$ARGV[0];
$patchdir=$ARGV[1];

while($line=<F>) {
	chomp($line);
	if($line=~/(\/src\/)(.*\/)(.*)(\.java)/i) {
		$classfile="$3.class";
		$src="$workspace\\src\\AutomatedBuildScripts\\build\\IHERemoteServices\\WebContent\\WEB-INF\\classes\\$2$3\.class";
		$dest="$patchdir\\Liferay\\jboss-as\\server\\default\\deploy\\IHERemoteServices\.war\\WEB-INF\\classes\\$2";
		$src=~s/\//\\/g;
		$dest=~s/\//\\/g;
		$status=copy($src,$dest) or warn("Could not copy $classfile class file");
		if($status==1) { print A "$classfile is copied\n"; }
	}
}
