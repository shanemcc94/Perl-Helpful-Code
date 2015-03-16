#!/usr/bin/perl
use strict; 
my (@data, $money, $fullname, $firstname, $lastname);
# Open a file for data
open DATA, 
"< /home/public/moneyowed04.dat";
@data = <DATA>;close DATA;foreach (@data){  
	chomp $_;
	# Eat the line-breaks
	($fullname,$money) = split (' €', $_); 
	# Split on the € symbol 
	print "$money is owed"; 
	($lastname, $firstname) = split ('€, ', $fullname); 
	# Now split on the comma 
	print " by $firstname $lastname.\n";
} 
