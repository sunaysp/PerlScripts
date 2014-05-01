#perl file which creates required files

open(D,"<logs/diffAll.log") or die("Cannot open diffAll.log file");
open(F,">logs/diff.log") or die("Cannot open diff.log file");
open(C,">logs/count.txt") or die("Cannot open count.txt file");

print "Inside dobuild.pl file.. Generating required temp files\n";
## Below code finds any deleted files and will not consider further for patch creation.  
while($line=<D>) {

	if($line=~/^(\s*D)\s+.*/i) {
		
		$line =~ s/\s*//;
		$line =~ s/^[A-Z]*\s*//;
		
		open(DEL,">>logs/DeleteFiles.txt") or die("Cannot open deletefiles.txt file\n");
		print DEL $line;
		next;
	}
	else {
		print F $line;
	}
}
close(DEL);
close(F);

open(F,"<logs/diff.log") or die("Cannot open diff.log file");


$count_java=0;
$count_portlets=0;
$count_ext=0;
$count_hooks=0;
$count_properties=0;
$count_xml=0;
$count_sql=0;
$count_web=0;
$count_other=0;

#Below loop takes each line from diff.log file and finds the project to which it belongs and adds in seperate text file. 
while($path = <F>) {
	$path =~ s/\s*//;
	$path =~ s/^[A-Z]*\s*//;
	if($path=~/\/portal\/HIEPortalInfra\/src\/.*\.java$/i) {
		open(J,">>logs/javachanges.txt") or die("Cannot open file");
		open(PS,">>logs/PortalInfra-src.txt") or die("Cannot open file");
		print J $path;
		print PS $path;
		$count_java++;
		close(J);
		close(PS);
		next;
	}
	if($path=~/\/portal\/HIEPortalInfra\/srcGlobal\/.*\.java$/i) {
		open(J,">>logs/javachanges.txt") or die("Cannot open file");
		open(PG,">>logs/PortalInfra-global.txt") or die("Cannot open file");
		print J $path;
		print PG $path;
		$count_java++;
		close(J);
		close(PG);
		next;
	}
	if($path=~/\/portal\/HIEServices\/.*\.java/i) { 
		open(J,">>logs/javachanges.txt") or die("Cannot open file");
		open(HS,">>logs/HIEServices.txt") or die("Cannot open file");
		print J $path;
		print HS $path;
		$count_java++;
		close(J);
		close(HS);
		next;
	}
	if($path=~/\/portal\/services\/.*\.java/i) { 
		open(J,">>logs/javachanges.txt") or die("Cannot open file");
		open(S,">>logs/services.txt") or die("Cannot open file");
		print J $path;
		print S $path;
		$count_java++;
		close(J);
		close(S);
		next;
	}
	if($path=~/\/portal\/IHERemoteServices\/.*\.java/i) { 
		open(J,">>logs/javachanges.txt") or die("Cannot open file");
		open(R,">>logs/IHERemoteServices.txt") or die("Cannot open file");
		print J $path;
		print R $path;
		$count_java++;
		close(J);
		close(R);
		next;
	}
	if($path=~/\/portal\/.*\/portlets\/.*/i) {
		open(P,">>logs/portletchanges.txt") or die("Cannot open file");
		print P $path;
		$count_portlets++;
		close(P);
	}
	if($path=~/\/portal\/.*\/ext\/.*/i) { 
		open(E,">>logs/extchanges.txt") or die("Cannot open file");
		print E $path;
		$count_ext++;
		close(E);
	}
	if($path=~/\/portal\/.*\/hooks\/.*/i) { 
		open(H,">>logs/hookschanges.txt") or die("Cannot open file");
		print H $path;
		$count_hooks++;
		close(H);
	}
	if($path=~/\/portal\/.*\.properties/i) {
		open(P,">>logs/properties.txt") or die("Cannot open file");
		print P $path;
		$count_properties++;
		next;
	}
	if($path=~/\/portal\/.*\.xml/i) {
		open(X,">>logs/xmlchanges.txt") or die("Cannot open file");
		print X $path;
		$count_xml++;
		next;
	}
	if($path=~/\/portal\/.*\.sql/i) {
		open(SQL,">>logs/sqlchanges.txt") or die("Cannot open file");
		print SQL $path;
		$count_sql++;
		next;
	}
	if($path!~/\/portal\//i) {
		open(O,">>logs/otherchanges.txt") or die("Cannot open file");
		print O $path;
		$count_other++;
		next;
	}
}	

print C "Inside Portal\n";
print C "Count of Java changes  = $count_java\n";
print C "Count of portlet changes = $count_portlets\n";
print C "Count of ext changes= $count_ext\n";
print C "Count of hooks changes= $count_hooks\n";
print C "Count of Property file changes  = $count_properties\n";

print C "\n\nCount of files changed in other projects = $count_other\n";
if($count_other>1)  {
print C "List of all files changed in other projects are found in otherchanges.txt file";
}


