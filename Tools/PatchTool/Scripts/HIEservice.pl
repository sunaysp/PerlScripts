#Perl script to copy HIEservice related jars into patch location.
use File::Copy;
use File::Find;
open(S,"<logs/HIEServices.txt") or die("Cannot open file");
open(A,">>logs/AntBuild.log") or warn("Cannot open file");

$\ = "\n";
$, = "\t";

$workspace=$ARGV[0];
$patchdir=$ARGV[1];

$dir="$workspace\\src\\AutomatedBuildScripts\\build\\pluginSDK\\ext\\moss-ext\\docroot\\WEB-INF\\ext-lib\\portal\\";
$dest="$patchdir\\Liferay\\jboss-as\\server\\default\\deploy\\ROOT.war\\WEB-INF\\lib";

%seen;
@mod_folders;
while($line=<S>) {
chomp($line);
	if($line=~/(\/HIEServices\/)(.*?)(service\/.*\.java$)/i) {
		unless($seen{$2}) {
			push(@mod_folders, $2);
			$seen{$2}=1;
		}	
	}
}

foreach $i (@mod_folders) {
	chomp($i);
	find(\&wanted,$dir);
}

sub wanted {
	if($_=~/^$i-/i ) {
		copy($_,$dest);
		print A "$_ is copied";
		if($_=~/^clinicaldocument-/i || $_=~/^notification-/i) {
			$temp="$patchdir\\Liferay\\jboss-as\\server\\default\\deploy\\IHERemoteServices.war\\WEB-INF\\lib";	
			#print $_;
			$status=copy($_,$temp);
			if($status==1) { print A "$_ is copied to IHERemoteServices.war lib folder"; }
		}		
	}
}
