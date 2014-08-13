#!/usr/bin/perl
use warnings;
use strict;
use Config::Simple;
use DBI;
use DBI qw(:sql_types);

# Read config file
my %config;
Config::Simple->import_from('kostour.ini', \%config);

my ($dsn, $dbh, $sth, $sql, $id, $type);

# Get DB handle
$dsn="dbi:mysql:" . $config{Database};

# Connect to the database
$dbh=DBI->connect($dsn, $config{Username}, $config{Password},
                  {RaiseError=>1, AutoCommit=>0, ShowErrorStatement=>1}) ||
     die "Error opening database: $DBI::errstr\n";

$sql = "CALL get_next_id('a', \@rtnVal)";
$dbh->do($sql);
$id = $dbh->selectrow_array('SELECT @rtnVal;');
#$sth = $dbh->prepare('CALL get_next_id(?, ?);');
#$sth->bind_param(1, \$type, SQL_CHAR);
#$sth->bind_param(2, \$id, SQL_CHAR);
#$sth->bind_param_inout(2, \$id, 6, SQL_CHAR);

#$type = 'a';
#$sth->execute() || print "Couldn't execute:\t$sth->errstr";

# Tidy up and disconnect
$dbh->disconnect || die "Failed to disconnect: $DBI::errstr\n";

print "ID is: $id\n";

