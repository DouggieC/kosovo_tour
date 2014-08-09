#!/usr/bin/perl
package KosovoTour;
use warnings;
use strict;
use Exporter;
use DBI;
use Config::Simple;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(connect_db get_config get_next_id);
our @EXPORT    = qw(connect_db get_config get_next_id);

sub connect_db($$$);
#sub init_db($$$);
sub get_config();
sub get_next_id($);

sub connect_db($$$) {
    my ($dbname, $uname, $pword) = (shift, shift, shift);

    # Need to use transactions. Enable error handling
    # and disable auto-commit
    my %attr = (RaiseError=>1, AutoCommit=>0);

    my $dbh = DBI->connect("dbi:mysql:$dbname", $uname, $pword, \%attr)
        || die "Could not open database: $DBI::errstr.\n";

    return $dbh;
}

#sub init_db($$$) {
#    my ($dbname, $uname, $pword) = (shift, shift, shift);
#    
#    my $db = connect_db($dbname, $uname, $pword);
#}

sub get_config() {
    my ($configFile, %config);
    $configFile = "kostour.ini";
    Config::Simple->import_from($configFile, \%config);

    return %config;
}

sub get_next_id($) {
    my ($id, $idType, $sql);

    $idType = shift;

    $sql = "CALL get_next_id('" . $idType . "', \@rtn)";
    $dbh->do($sql);
    $id = $dbh->selectrow_array('SELECT @rtn');

    return $id;
}

1;
