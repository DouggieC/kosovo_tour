#!/usr/bin/perl
package KosovoTour;
use warnings;
use strict;

my ($idType, $sql);

$idType = 'a';

$sql = "CALL get_next_id('" . $idType . "', \@rtn)";

print "$sql\n";
