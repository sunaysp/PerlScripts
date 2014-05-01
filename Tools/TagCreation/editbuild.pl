#Perl Script to change the properties.
use File::Find;


$srcURL=$ARGV[0];
$tagURL=$ARGV[1];
$comment=$ARGV[2];
$antpath=$ARGV[3];

#$\ = "\n";
@array=`svn ls $tagURL/exchange`;
#print @array;

print "Checking out exchange project and AutomatedBuildScripts in temporary workspace folder\n";

`svn checkout --depth=files $tagURL/portal/AutomatedBuildScripts workspace/AutomatedBuildScripts`;

foreach(@array) {
	chomp($_);
	`svn checkout --depth=files $tagURL/exchange/$_ workspace/$_`;
	#print $_;
}

$dir="workspace";
print "Inside AutomatedBuildScripts and exchange folder... \nUpdating $srcURL with $tagURL\n";
find(\&wanted,$dir); # This line searches the srcURL in pom.xml, build.bat and build.properties file. Finally it updates with tagURL. 

open(F,"<workspace/AutomatedBuildScripts/build.properties") or die("Cannot open file");
@file=<F>;
close(F);
open(F,">workspace/AutomatedBuildScripts/build.properties") or die("Cannot open file");

print "Editing Ant Path in AutomatedBuildScripts/build.properties\n";
foreach $line (@file)  {
	if($line=~/ant\.lib\.dir=/i && $antpath ne "") {
		$line=$&.$antpath;
		print F "$line\n";
		next;
	}
	print F $line;
}
print "Commiting AutomatedBuildScripts/build.properties file\n";
`svn commit workspace/AutomatedBuildScripts -m "$comment"`;
foreach(@array) {
	chomp($_);
	print "Commiting workspace/$_\n";
	`svn commit workspace/$_ -m "$comment"`;
	#print $_;
}


sub wanted  {

	if($_=~/^pom\.xml$/i || $_=~/^build\.properties$/i || $_=~/^build\.bat$/i ) {
		$file=$_;
		print "Checking URL in $File::Find::name \n";
		chomp($file);
		open(F,"<$file") or die("Cannot open file\n");
		@filecontents=<F>;
		close(F);
		open(F,">$file") or die("Cannot open file\n");
		foreach $line(@filecontents) {
			$line=~s/$srcURL/$tagURL/i;
			print F $line;
		}
		close(F);
	}
}
