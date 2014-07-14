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
#$sth=$dbh->prepare("SELECT * FROM test;") || die "Prepare failed: $DBI::errstr\n";
#$sth = $dbh->prepare("SELECT card_type, card_type_id FROM card_type;");
#$sth->execute() || die "Couldn't execute query: $DBI::errstr\n";
#my %cardTypes;
#while (my ($type, $id) = $sth->fetchrow_array) {
#    $cardTypes{$type} = $id;
#}

#my @cardTypes = @{$dbh->selectcol_arrayref("SELECT card_type FROM card_type;")};
#my %cardTypes = %{$dbh->selectall_hashref("SELECT card_type_id, card_type FROM card_type;", "card_type")};
my $cardTypes = $dbh->selectall_hashref("SELECT card_type_id, card_type FROM card_type;", "card_type_id");

my $values_list = [sort(keys(%{$cardTypes}))];
my $labels_list = { map {$_->{card_type_id} => $_->{card_type}} values(%{$cardTypes}) };

print "@{$values_list}\n";

foreach (sort keys %{$labels_list}) {
    print "labels_list{$_}:\t$labels_list->{$_}\n";
}

#foreach (sort keys %cardTypes) {
#    print "$_:\t$cardTypes{$_}\n";
#}

#my ($i, $j);
#foreach $i (keys %cardTypes) {
#    foreach $j (keys %{$cardTypes{$i}}) {
#        print "cardTypes{$i} -> {$j}:\t$cardTypes{$i}{$j}\n";
#    }
#}

#print "Visa Credit: $cardTypes{'Visa Debit'}\n";

# Print it out
#while (( $id, $firstname, $lastname) = $sth->fetchrow_array) {
#    print "Person $id: $firstname $lastname\n";
#}

# Tidy up and disconnect
#$sth->finish;
$dbh->disconnect || die "Failed to disconnect: $DBI::errstr\n";

