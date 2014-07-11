#!/usr/bin/perl
use warnings;
use strict;
use CGI;
use KosovoTour;

my ($cgi, $dbh, $sth, %config, %insertData);

# Get the config details from file
%config = get_config();

# Read user input from webpage into hash for DB insertion
$cgi = new CGI;
%insertData = $cgi->param();

# Connect to the database
$dbh = connect_db($config{Database}, $config{Username}, $config{Password});

# Insert the data
# TODO - What to do about PK?
$sth = $dbh->prepare("INSERT INTO client VALUES ($insertData{firstname}, $insertData{lastname},
                                                 $insertData{address_line_1}, $insertData{address_line_2},
                                                 $insertData{address_line_3}, $insertData{address_line_4},
                                                 $insertData{postcode}, $insertData{country},
                                                 $insertData{date_of_birth}, $insertData{tel_no},
                                                 $insertData{email_address}");
$sth->execute() || die "Couldn't insert data: $DBI::errstr.\n";

# Tidy up and disconnect
$sth->finish();
$dbh->disconnect();
