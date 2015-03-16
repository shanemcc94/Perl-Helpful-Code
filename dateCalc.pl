#!/usr/bin/perl 
use strict; 
use Date::Calc(check_date Decode_Date_EU Today Date_to_Days); 

my($now_year, $now_month, $now_day, $test_year, $test_month, $test_month, $test_day, $test_date); 

($now_year, $now_month, $now_day) = Today(); 


$test_date = <STDIN>; 
$test_date =~ s/\s//g; 
if ($test_date ne "") { 
	($test_year, $test_month, $test_day) = Decode_Date_EU($test_date); 
	if (check_date($test_year, $test_month, $test_day) ==1) { 
		print "That's ", Date_to_Days($test_year, $test_month, $test_day), " days since 1/1/0001\n"; 
		if (Date_to_Days($test_year, $test_month, $test_day) > Date_to_Days($now_year, $now_month, $now_day)) { 
			print "<html><body>That date is in the future</body></html>\n"; 
		} 
		elsif (Date_to_Days($test_year, $test_month, $test_day) < Date_to_Days($now_year, $now_month, $now_day)) { 
			print "<html><body>That date is in the past</body></html>\n"; 
		} 
		else { 
			print "<html><body>That's todays date</body></html>\n"; 
		}	 
	} 
	else { 
		print "<html><body>that's not a valid date</body></html>\n"; 
	} 
} 
