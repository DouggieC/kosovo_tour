#!/usr/bin/perl
use warnings;
use strict;
use CGI;
use KosovoTour;

my ($cgi, $dbh, $sth, $cardTypes, $cardTypeValues, $cardTypeLabels, %config, %insertData);

# Get the config details from file
%config = get_config();

# Connect to the database
$dbh = connect_db($config{'Database'}, $config{'Username'}, $config{'Password'});

# Read the list of valid credit card types from the DB lookup table
$cardTypes      = $dbh->selectall_hashref("SELECT card_type_id, card_type FROM card_type;", "card_type_id");
$cardTypeValues = [sort(keys(%{$cardTypes}))];
$cardTypeLabels = { map {$_->{card_type_id} => $_->{card_type}} values(%{$cardTypes}) };

#Create and display the initial form
$cgi = new CGI;
print $cgi->header,
      $cgi->start_html(-title => "Register as a new client"),
      $cgi->h1("Please enter your details:"),
      $cgi->start_form,
         $cgi->p("First Name: ", $cgi->textfield(-name=>'firstname')),
          $cgi->p("Last Name: ", $cgi->textfield(-name=>'lastname')),
          $cgi->p("Address Line 1: ", $cgi->textfield(-name=>'address_line_1')),
          $cgi->p("Address Line 2: ", $cgi->textfield(-name=>'address_line_2')),
          $cgi->p("Address Line 3: ", $cgi->textfield(-name=>'address_line_3')),
          $cgi->p("Address Line 4: ", $cgi->textfield(-name=>'address_line_4')),
          $cgi->p("Postcode: ", $cgi->textfield(-name=>'postcode')),
          $cgi->p("Country: ", $cgi->textfield(-name=>'country')),
          $cgi->p("Date of birth: ", $cgi->textfield(-name=>'date_of_birth')),
          $cgi->p("Phone Number: ", $cgi->textfield(-name=>'tel_no')),
          $cgi->p("Email Address: ", $cgi->textfield(-name=>'email_address')),
          $cgi->p($cgi->h2("You must register a credit or debit card with your account. Please enter details below:")),
          $cgi->p("Card Number: ", $cgi->textfield(-name=>'card_no')),
          $cgi->p("Card Type: ", $cgi->popup_menu(-name=>'card_type', -values=>$cardTypeValues, -labels=>$cardTypeLabels)),
          $cgi->p("Start Date: ", $cgi->textfield(-name=>'start_date')),
          $cgi->p("Expiry Date: ", $cgi->textfield(-name=>'end_date')),
          $cgi->p("Issue Number: ", $cgi->textfield(-name=>'issue_no')),
          $cgi->p("CCV Code: ", $cgi->textfield(-name=>'ccv_code')),
          $cgi->submit(-name=>'submit', -value=>'Register Now'),
      $cgi->end_form,
      $cgi->end_html();

# Read user input from webpage into hash for DB insertion
%insertData = $cgi->param();

# TODO get the upper / lower working right
#$insertData{$_} = $cgi->param($_, ucfirst(lc($cgi->param($_))));

# Insert the data
# TODO - What to do about client PK?
$sth = $dbh->prepare("INSERT INTO client VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);");
$sth->execute('c00001', $insertData{'firstname'}, $insertData{'lastname'},
              $insertData{'address_line_1'}, $insertData{'address_line_2'},
              $insertData{'address_line_3'}, $insertData{'address_line_4'},
              $insertData{'postcode'}, $insertData{'country'}, $insertData{'date_of_birth'},
              $insertData{'tel_no'}, $insertData{'email_address'}) || die "Couldn't insert client details: $DBI::errstr\n";

$sth = $dbh->prepare("INSERT INTO credit_card VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);");
$sth->execute($insertData{'card_no'}, $insertData{'firstname'}, $insertData{'lastname'},
              $insertData{'address_line_1'}, $insertData{'address_line_2'}, $insertData{'address_line_3'},
              $insertData{'address_line_4'}, $insertData{'postcode'}, $insertData{'country'},
              $insertData{'card_type'}, $insertData{'start_date'}, $insertData{'end_date'},
              $insertData{'issue_no'}, $insertData{'ccv_code'}, 'c00001') || die "Couldn't insert credit card details: $DBI::errstr\n";

print $cgi->header(),
      $cgi->start_html("Client added successfully"),
      $cgi->p($cgi->h1("Registration completed successfully")),
      $cgi->p("Congratulations $insertData{'firstname'} $insertData{'lastname'}! You are now registered with Kosovo Tours"),
      $cgi->end_html();

# Tidy up and disconnect
$dbh->disconnect();

