#!/usr/bin/perl
use warnings;
use strict;
use CGI;
use KosovoTour;

my ($cgi, $dbh, $sth, $picFile, $myAccomId, $roomTypes, $roomTypeValues, $roomTypeLabels,
    $roomPbs, $roomPbValues, $roomPbLabels, @row, %config, %searchData);

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


$cgi = new CGI;
print $cgi->header,
      $cgi->start_html(-title => "Search for accommodation"),
      $cgi->h1("Please enter the required accommodation details:"),
      $cgi->start_form,
      $cgi->p("Town: ", $cgi->textfield(-name=>'town'), $cgi->br,
                 "Room Type: ", $cgi->popup_menu(-name=>'room_type', -values=>$roomTypeValues, -labels=>$roomTypeLabels), $cgi->br,
                 "Price Basis: ", $cgi->popup_menu(-name=>'price_basis', -values=>$roomPbValues, -labels=>$roomPbLabels));
print $cgi->submit(-name=>'submit', -value=>'Search'), $cgi->br, $cgi->br;
print $cgi->end_form;
print $cgi->end_html();

# Read user input from webpage into hash for DB insertion
foreach ($cgi->param()) {
    $searchData{$_} = $cgi->param($_);
}

# Search for a match

$sth = $dbh->prepare("SELECT a.name, r.room_id, r.description, rt.room_type, r.price, rpb.room_price_basis
                      FROM accommodation a, room r, room_type rt, room_price_basis rpb
                      WHERE r.accom_id = a.accom_id AND rt.room_type_id = r.room_type AND rpb.room_pb_id = r.price_basis
                      AND a.address_line_4 = ? AND rt.room_type = ? AND rpb.room_price_basis = ?");

$sth->execute($searchData{'town'}, $searchData{'room_type'}, $searchData{'price_basis'})
    || die "Couldn't insert client details: $DBI::errstr\n";

my @rows;
while (@row = $sth->fetchrow_array) {
    push @rows, \@row;
}

foreach (@rows) {
    foreach (@$_) {
        print "$_\t";
    }
    print "\n";
}

print $cgi->table({-border=>1, -cellpadding=>3}, $cgi->Tr([
      $cgi->th(['Hotel Name', 'Room No.', 'Description', 'Type', 'Price', 'Basis']),
      map {
          $cgi->td([
              map { $_ } @$_
          ])
      } @rows
      ])
);

#while (@row = $sth->fetchrow_array) {
#    print $cgi->
#    foreach (@row) {
#        print "$_\t";
#    }
#    print "\n";
#}

# Tidy up and disconnect
$dbh->disconnect();

# Sample of table
#my @rows = (
#  [ 1, 2,  3,  4 ],
#  [ 5, 6,  7,  8 ],
#  [ 9, 10, 11, 12 ],
#);
#print table({-border=>1},Tr([
#      th(['Document', 'X', 'Y', 'Z']),
#      map {
#        td([
#                map {
#                        a({-href=>$_},$_)
#                } @$_
#        ])
#      } @rows
#    ])
#  );