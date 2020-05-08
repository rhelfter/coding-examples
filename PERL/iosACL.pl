#!/usr/bin/perl

use strict;
use POSIX qw(strftime);
use Getopt::Long;
use Text::ParseWords qw(parse_line);


my ($f);
GetOptions('f=s' => \$f) or die "$!" . "\n";
open my $file, '<', $f or die "$!" . "\n";
 
#217.195.147.42/31,,,,,suspicious,,100,ipati --- edge filtering cidrs,2014-07-29T16:04:54Z,everyone,29a21cac-a86d-43e1-bec6-8a77bd822897,,mitigation,,,,2014-07-29T16:04:54Z,need-to-know,,high

my @array = <$file>;

print "Generating an IOS Compapible Network Object-Group" . "\n\n";

print "enable" . "\n";
print "configure terminal" . "\n";
print "object-group network IPatiACL" . "\n";
print "description IPati_Edge_Filtering_CIDRs" . "\n\n";
foreach my $line (@array) {
	my $output;
        #if ($line !~ /^(#.*)$/) {
        if ($line) {
		#print "DEBUG : $line";
                my @elements = Text::ParseWords::parse_line(',', 0, $line);
		my @cidr = split ("/", $elements[0]);
		chomp $cidr[1];
		my $OUTPUT1 = cvt_bits_mask($cidr[1]);
		my $OUTPUT2 = do_subtract($OUTPUT1);
		#print "cidr[0]: " . $cidr[1] . " " . "OUTPUT1: " . $OUTPUT1 . " " . "OUTPUT1: " . $OUTPUT2 . "\n";
		#$output = do_subtract(cvt_bits_mask($cidr[1]));
		#print "do_subtract(cvt_bits_mask(" . $cidr[1] . "))" . "\n";
		print "network-object " . $cidr[0] . " " . $OUTPUT2 . "\n";
        }
}
print "end" . "\n";

sub do_subtract() {
	my $s_ip = shift;
	#print "s_ip " . " " . $s_ip . "\n";
   
	# break up the bytes of the incoming IP address
	$_ = $s_ip;
	my ($a, $b, $c, $d) = split(/\./);
   
	if ($a > 255 || $b > 255 || $c > 255 || $d > 255 || /[^0-9.]/) {
		print "invalid input mask or wildcard\n";
		exit();
	}
   
	$a = 255 - $a;
	$b = 255 - $b;
	$c = 255 - $c;
	$d = 255 - $d;
   
	#print "DEBUG: do_subtract returned: " . $a . "." . $b . "." . $c . "." . $d . "\n";
	return ($a . "." . $b . "." . $c . "." . $d);
}

sub cvt_bits_mask() {
	my $cbits = shift;
	#print "c_bits " . " " . $cbits . "\n";
	my ($aa, $ab, $ac, $ad);
   
	if ($cbits <= 8 ) {
		$aa = bits_to_dec($cbits);
		$ab=$ac=$ad=0;
	} else {
		$aa=255;
		if ($cbits <= 16 ) {
			$ab = bits_to_dec($cbits-8);
			$ac=$ad=0; 
		} else {
			$ab=255;
			if ($cbits <= 24 ) {
				$ac = bits_to_dec($cbits-16);
				$ad=0;
			} else {
				$ac=255;
				if ($cbits <= 32 ) {
					$ad = bits_to_dec($cbits-24);
				} else {
					print "invalid bit count\n";
					exit();
				}
			}
		}
	}
	#print "DEBUG: cvt_bits_mask returned: " . $aa . "." . $ab . "." . $ac . "." . $ad . "\n";
	return ($aa . "." . $ab . "." . $ac . "." . $ad);
}

sub bits_to_dec() {
	my $bbits = shift;
   
	if($bbits == 0 ) { return 0; }
	if($bbits == 1 ) { return 128; }
	if($bbits == 2 ) { return 192; }
	if($bbits == 3 ) { return 224; }
	if($bbits == 4 ) { return 240; }
	if($bbits == 5 ) { return 248; }
	if($bbits == 6 ) { return 252; }
	if($bbits == 7 ) { return 254; }
	if($bbits == 8 ) { return 255; }
}
