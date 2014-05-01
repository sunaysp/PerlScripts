#Perl script to copy services related jars into patch location.
use File::Copy;
use File::Find;
open(S,"<logs/services.txt") or die("Cannot open file");
open(A,">>logs/AntBuild.log") or warn("Cannot open file");

# $\ = "\n";
# $, = "\t";

$workspace=$ARGV[0];
$patchdir=$ARGV[1];


$dir="$workspace\\src\\AutomatedBuildScripts\\build\\pluginSDK\\ext\\moss-ext\\docroot\\WEB-INF\\ext-lib\\global\\";
$dest="$patchdir\\Liferay\\jboss-as\\server\\default\\lib";

%seen;
@mod_folders;
while($line=<S>) {
chomp($line);
	if($line=~/(\/services\/)(.*)(\/hieportal\/)(.*?)(\/.*\.java$)/i) {
		$name=$4; #print $4;
		if($line=~/(\/onramp\/)(.*?)(\/.*\.java$)/i) {
		$name=$2;
		#print $name;
		unless($seen{$name}) {
				push(@mod_folders, $name);
				$seen{$name}=1;
			}
		}
		else{
			unless($seen{$name}) {
				push(@mod_folders, $name);
				$seen{$name}=1;
			}
		}	
	}
}

foreach $i (@mod_folders) {
	find(\&wanted,$dir);
}

sub wanted {
	if($_=~/^$i-/i ) {
		#print $_;
		$status=copy($_,$dest);
		if($status==1) { print A "$_ is copied\n"; }
		
	}
}
