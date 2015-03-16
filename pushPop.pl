#!/usr/bin/perl
use strict; 
# Program to demonstrate how to use push ... pop
# Reads words on one line, splits on space and then...
#
# push - add element at end of array
# pop - remove element from array
my ($input, @words, @words_backwards); 
print "Type in some words with a space between them: ";
$input=<STDIN>;
chomp $input;
@words = split " ", $input;
foreach (@words) {
	push @words_backwards, $_;
}
print "You entered: @words\n";
print "Reversed: ";
while (@words_backwards) {
	print pop @words_backwards, " ";
}

print "\n"
