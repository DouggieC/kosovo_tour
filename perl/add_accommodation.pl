#!/usr/bin/perl
use warnings;
use strict;
use CGI;
use KosovoTour;

my ($cgi, $dbh, $sth, $picFile, $myAccomId, $roomTypes, $roomTypeValues, $roomTypeLabels,
    $roomPbs, $roomPbValues, $roomPbLabels, %config, %insertData);

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
      $cgi->start_html(-title => "Register new accommodation"),
      $cgi->h1("Please enter the accommodation details:"),
      $cgi->start_form,
         $cgi->p("Accommodation Name: ", $cgi->textfield(-name=>'name')),
         $cgi->p("Address Line 1: ", $cgi->textfield(-name=>'address_line_1')),
         $cgi->p("Address Line 2: ", $cgi->textfield(-name=>'address_line_2')),
         $cgi->p("Address Line 3: ", $cgi->textfield(-name=>'address_line_3')),
         $cgi->p("Address Line 4: ", $cgi->textfield(-name=>'address_line_4')),
         $cgi->p("Postcode: ", $cgi->textfield(-name=>'postcode')),
         $cgi->p("Country: ", $cgi->textfield(-name=>'country')),
         $cgi->p("Phone Number: ", $cgi->textfield(-name=>'tel_no')),
         $cgi->p("Email Address: ", $cgi->textfield(-name=>'email_address')),
         $cgi->p("Description: ", $cgi->textfield(-name=>'description', -rows=>20, -columns=>50)),
         $cgi->p("Website: ", $cgi->textfield(-name=>'website_url')),
         $cgi->p("Upload a picture: ", $cgi->filefield(-name=>'picture')),
         $cgi->p($cgi->h2("Please enter one room's details below. More rooms can be added later.")),
         $cgi->p("Description: ", $cgi->textfield(-name=>'description', -rows=>20, -columns=>50)),
         $cgi->p("Room Type: ", $cgi->popup_menu(-name=>'room_type', -values=>$roomTypeValues, -labels=>$roomTypeLabels)),
         $cgi->p("Capacity: ", $cgi->textfield(-name=>'capacity')),
         $cgi->p("Price: ", $cgi->textfield(-name=>'price')),
         $cgi->p("Price Basis: ", $cgi->popup_menu(-name=>'price_basis', -values=>$roomPbValues, -labels=>$roomPbLabels)),
         $cgi->submit(-name=>'submit', -value=>'Add Accomodation'),
      $cgi->end_form,
      $cgi->end_html();

# Read user input from webpage into hash for DB insertion
%insertData = $cgi->param();

# Get the picture file data if needed
if (defined $insertData{'picture'}) {
    open PICFILE, $insertData{'picture'} || die "Cannnot open picture file: $!\n";
    
    while (<PICFILE>){
        $picFile .= $_;
    }
} else {
	$picFile = '';
}

# Insert the data
# TODO - What to do about client PK?
$sth = $dbh->prepare("INSERT INTO accommodation VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);");
$sth->execute('a00001', $insertData{'name'}, $insertData{'address_line_1'}, $insertData{'address_line_2'},
              $insertData{'address_line_3'}, $insertData{'address_line_4'}, $insertData{'postcode'},
              $insertData{'country'}, $insertData{'tel_no'}, $insertData{'email_address'},
              $insertData{'description'}, $insertData{'website_url'}, $insertData{'picture'}) || die "Couldn't insert client details: $DBI::errstr\n";

# Get the accommodation ID just inserted
$myAccomId = $dbh->selectrow_array("SELECT MAX(accom_id) FROM accommodation,");

$sth = $dbh->prepare("INSERT INTO room VALUES (?, ?, ?, ?, ?, ?, ?);");
$sth->execute('r00001', $insertData{'description'}, $insertData{'room_type'}, $insertData{'capacity'},
              $insertData{'price'}, $insertData{'price_basis'}, $myAccomId) || die "Couldn't insert credit card details: $DBI::errstr\n";

print $cgi->header(),
      $cgi->start_html("Accommodation added successfully"),
      $cgi->p($cgi->h1("Accommodation & room setup completed successfully")),
      $cgi->p("Congratulations $insertData{'name'}! You are now registered with Kosovo Tours"),
      $cgi->end_html();

# Tidy up and disconnect
$dbh->disconnect();
