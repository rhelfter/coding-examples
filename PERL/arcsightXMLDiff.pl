#!/usr/bin/perl

##
## Author: Ryan Helfter

## Purpose:  This script will take a COB and a PROD XML dump of the same resource
##
## Arguments are : xmlDiff.pl "PROD XML FILE" "COB XML FILE" "RESOURCE"
## i.e.  bin/xmlDiff.pl files/PROD/Rules_export.xml files/COB/Rules_export.xml Rules 
##
## Resource XML files tested
#SessionList
#Rule
#DataMonitor
#FieldSet
#Trend
#ActiveChannel
#Query
#Dashboard
#Filter
#ActiveList
#Report
##
# Version 1.0
# version 1.01 has 4 hard coded filters listed below under ignore
# version 1.02 corrected a few bugs
# version 1.03 now does hard coded filters on character differences
# Version 1.1 is roadmapped to include a filter argument

#
# change->{message} has been observed to catch the following exceptions of arcsight xml file diffs
#
#Rogue element
#Child element
#Character differences
#
# ignores:
# ReferenceID, ManagerID, VersionID, TableID

use strict;

# this needs to be hardcoded 
BEGIN {push @INC, '/home/rhelfter/arcsight/ContentGap-Dev/ArcContentGap_Script/lib'}
use XML::SemanticDiff;

my ($file1, $file2, $string) = @ARGV;
my $diff = XML::SemanticDiff->new(keeplinenums => 1, keepdata => 1,);

foreach my $change ($diff->compare($file1, $file2)) {
	# set this to be 1 by default and only set to 0 when equal
	my $filter_diff = 1;

	if ($change->{message} =~ /^Character differences in element/) {
		#print "Filter Diff: " . $filter_diff . "\n";
		# remove filtered items old_values
		$change->{old_value} =~ s/versionID=\S+//g;
		$change->{old_value} =~ s/ReferenceID=\S+//g;
		$change->{old_value} =~ s/ManagerID=\S+//g;
		$change->{old_value} =~ s/tableID=\S+//g;
		# remove filtered items new_values
		$change->{new_value} =~ s/versionID=\S+//g;
		$change->{new_value} =~ s/ReferenceID=\S+//g;
		$change->{new_value} =~ s/ManagerID=\S+//g;
		$change->{new_value} =~ s/tableID=\S+//g;

		# now compare new strings
		if ($change->{old_value} ne $change->{new_value}) {
			#print "After filtering, character difference in element are still found to be different" . "\n\n";
			#print "Filtered old value: " . $change->{old_value} . "\n";
			#print "Filtered new value: " . $change->{new_value} . "\n\n";
			$filter_diff = 1;
		} else {
			#print "After filtering, character difference in element are now equal" . "\n\n";
			#print "Filtered old value: " . $change->{old_value} . "\n";
			#print "Filtered new value: " . $change->{new_value} . "\n\n";
			$filter_diff = 0;
		}
	}

	if (($change->{message} =~ /$string/) && ($change->{message} !~ /versionID|ReferenceID|ManagerID|tableID/ && ($filter_diff == 1))) {
		print "$change->{message} on line $change->{startline} in context $change->{context}" . "\n";
		if (($change->{old_value}) && ($change->{old_value} ne "o")) {
			print "FILE $file1 LINE $change->{startline} with OLD VALUE \"$change->{old_value}\"" . "\n";
		}
		if (($change->{new_value}) && ($change->{new_value} ne "o")) {
			print "FILE $file2 LINE $change->{endline} with NEW VALUE \"$change->{new_value}\"" . "\n";
		}
		# record spacing
		print "\n";
	}
}
