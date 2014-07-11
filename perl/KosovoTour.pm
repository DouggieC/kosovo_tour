#!/usr/bin/perl
package KosovoTour;
use warnings;
use strict;
use Exporter;
use DBI;
use Config::Simple;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(connect_db get_config);
our @EXPORT    = qw(connect_db get_config);

sub connect_db($$$);
#sub init_db($$$);
sub get_config();

sub connect_db($$$) {
	my ($dbname, $uname, $pword) = (shift, shift, shift);
	
	my $dbh = DBI->connect("dbi:mysql:$dbname", $uname, $pword)
	    || die "Could not open database: $DBI::errstr.\n";
	
	return $dbh;
}

#sub init_db($$$) {
#	my ($dbname, $uname, $pword) = (shift, shift, shift);
#	
#	my $db = connect_db($dbname, $uname, $pword);
#}

sub get_config() {
	my ($configFile, %config);
	$configFile = "kostour.ini";
	Config::Simple->import_from($configFile, \%config);
	
	return %config;
}

1;