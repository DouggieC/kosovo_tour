#!/usr/bin/perl
use warnings;
use strict;
use CGI;
use KosovoTour;

my ($cgi, $dbh, $sth, $cardTypes, $cardTypeValues, $cardTypeLabels, $client_id, %config, %insertData);

# Get the config details from file
%config = get_config();

# Connect to the database
$dbh = connect_db($config{'Database'}, $config{'Username'}, $config{'Password'});

my $curr_id;
$curr_id = ($dbh->selectrow_array("SELECT client_id FROM last_used_id WHERE last_used_pk = '0';"))[0];
my $num = (substr($curr_id,1,5))++;
#$num++;
print "Num:\t$num\n";
$client_id = "c" . $num;
print "Last ID:\t$curr_id\n";
print "Next ID:\t$client_id\n";
