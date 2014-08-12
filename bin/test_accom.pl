#!/usr/bin/perl
use warnings;
use strict;
use CGI;
use lib "/opt/git/kosovo_tour/perl";
use KosovoTour;

my ($cgi, $dbh, $sth, $picFile, $myAccomId, $roomTypes, $roomTypeValues, $roomTypeLabels,
    $roomPbs, $roomPbValues, $roomPbLabels, %config, %searchData);

# Get the config details from file
%config = get_config();

# Connect to the database
$dbh = connect_db($config{'Database'}, $config{'Username'}, $config{'Password'});

# Read the list of valid room types from the DB lookup table
$roomTypes      = $dbh->selectall_hashref("SELECT room_type_id, room_type FROM room_type;", "room_type_id");
$roomTypeValues = [sort(keys(%{$roomTypes}))];
$roomTypeLabels = { map {$_->{room_type_id} => $_->{room_type}} values(%{$roomTypes}) };

# Read the list of valid room price bases from the DB lookup table
$roomPbs      = $dbh->selectall_hashref("SELECT room_pb_id, room_price_basis FROM room_price_basis;", "room_pb_id");
$roomPbValues = [sort(keys(%{$roomPbs}))];
$roomPbLabels = { map {$_->{room_pb_id} => $_->{room_price_basis}} values(%{$roomPbs}) };

# Search for a match

%searchData = (
    'town'        => 'Prishtina',
    'room_type'   => 'Double',
    'price_basis' => 'Full Board',
    'start_date'  => '20160911',
    'end_date'    => '20160914'
);

$sth = $dbh->prepare("SELECT a.name, r.room_id, r.description, rt.room_type, r.price, rpb.room_price_basis
                      FROM accommodation a, room r, room_type rt, room_price_basis rpb, booking b, books_room br
                      WHERE r.accom_id = a.accom_id AND rt.room_type_id = r.room_type AND rpb.room_pb_id = r.price_basis
                      AND br.room_id = r.room_id AND b.booking_id = br.booking_id
                      AND a.address_line_4 = ? AND rt.room_type = ? AND rpb.room_price_basis = ?
                      AND (b.end_date < ? OR b.start_date > ? OR (b.end_date IS NULL AND b.start_date IS NULL))");

$sth->execute($searchData{'town'}, $searchData{'room_type'}, $searchData{'price_basis'}, $searchData{'start_date'}, $searchData{'end_date'})
    || die "Couldn't insert client details: $DBI::errstr\n";

while (my @row = $sth->fetchrow_array) {
    foreach (@row) {
        print "$_\t";
    }
    print "\n";
}

#foreach (my $result = $sth->fetchrow_hashref) {
#    foreach (keys %{$result}) {
#        print "$_:\t$result->{$_}\n";
#    }
#}

#my @results = $sth->fetchall_arrayref({});

#foreach (@results) {
#    print keys $_;
#}

# Tidy up and disconnect
$sth->finish();
$dbh->disconnect();
