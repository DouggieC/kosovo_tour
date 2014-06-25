#!/usr/bin/perl
use warnings;
use strict;
use Config::Simple;
use DBI;

# Read config file
my %config;
Config::Simple->import_from('kostour.ini', \%config);

my ($dsn, $dbh, $sth, $id, $firstname, $lastname);

# Get DB handle
$dsn="dbi:mysql:" . $config{Database};

$dbh=DBI->connect($dsn, $config{Username}, $config{Password}) ||
    die "Error opening database: $DBI::errstr\n";

# Read all data from table
$sth=$dbh->prepare("SELECT * FROM test;") || die "Prepare failed: $DBI::errstr\n";

$sth->execute() || die "Couldn't execute query: $DBI::errstr\n";

# Print it out
while (( $id, $firstname, $lastname) = $sth->fetchrow_array) {
    print "Person $id: $firstname $lastname\n";
}

# Tidy up and disconnect
$sth->finish;
$dbh->disconnect || die "Failed to disconnect: $DBI::errstr\n";

