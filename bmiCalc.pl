#!/usr/bin/perl 
use strict; 

my ($mass,$height,$bmi,); 
print "Enter your mass.";
$mass = <STDIN>;

print "Enter your height."; 
$height= <STDIN>;

$bmi= $mass/($height*$height);


print "your BMI is $bmi\n"; 

if ($bmi <15){
  print "Very severely underweight.";
}

elsif ($bmi <16){
  print "Severely underweight.";
}

elsif ($bmi <18.6){
  print "Underweight.";
}

elsif ($bmi <26){
  print "Normal range.";
}

elsif ($bmi <31){
  print "Overweight.";
}

elsif ($bmi <36){
  print "Obese class 1.";
}

elsif ($bmi <41){
  print "Obese class 2.";
}

else{
  print "Obese class 3.\n";
}

