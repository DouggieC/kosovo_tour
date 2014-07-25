#!/usr/bin/perl
###########################################################
# Name:    add_client.pl
# Author:  Doug Cooper
# Version: 1.3
# Date:    01-07-2014
#
# Version History
# 1.0: Initial code. CGI only.
# 1.1: Improve CGI layout
# 1.2: Basic database interaction
# 1.3: DB transaction support
###########################################################

use warnings;
use strict;
use CGI;
use KosovoTour;

my ($cgi, $dbh, $sth, $cardTypes, $cardTypeValues, $cardTypeLabels, $client_id, %config, %insertData);

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
print $cgi->header;
print $cgi->start_html(-title => "Register as a new client");
print $cgi->h1("Please enter your details:");
print $cgi->start_form;
    print $cgi->p("First Name: ", $cgi->textfield(-name=>'firstname'),
                  "Last Name: ", $cgi->textfield(-name=>'lastname'), $cgi->br, $cgi->br,
                  "Address Line 1: ", $cgi->textfield(-name=>'address_line_1'), $cgi->br,
                  "Address Line 2: ", $cgi->textfield(-name=>'address_line_2'), $cgi->br,
                  "Address Line 3: ", $cgi->textfield(-name=>'address_line_3'), $cgi->br,
                  "Address Line 4: ", $cgi->textfield(-name=>'address_line_4'), $cgi->br,
                  "Postcode: ", $cgi->textfield(-name=>'postcode'), $cgi->br,
                  "Country: ", $cgi->textfield(-name=>'country'), $cgi->br, $cgi->br,
                  "Date of birth: ", $cgi->textfield(-name=>'date_of_birth'), $cgi->br,
                  "Phone Number: ", $cgi->textfield(-name=>'tel_no'),
                  "Email Address: ", $cgi->textfield(-name=>'email_address'));
    print $cgi->p($cgi->h2("You must register a credit or debit card with your account. Please enter details below:"),
                  "Card Number: ", $cgi->textfield(-name=>'card_no'),
                  "Card Type: ", $cgi->popup_menu(-name=>'card_type', -values=>$cardTypeValues, -labels=>$cardTypeLabels), $cgi->br,
                  "Start Date: ", $cgi->textfield(-name=>'start_date'),
                  "Expiry Date: ", $cgi->textfield(-name=>'end_date'), $cgi->br,
                  "Issue Number: ", $cgi->textfield(-name=>'issue_no'),
                  "CCV Code: ", $cgi->textfield(-name=>'ccv_code'));
    print$cgi->submit(-name=>'submit', -value=>'Register Now');
print $cgi->end_form;
print $cgi->end_html();

# Read user input from webpage into hash for DB insertion

%insertData = $cgi->param();

# Insert the data
# First get the last-used client ID from the database
my $curr_id = ($dbh->selectrow_array("SELECT client_id FROM last_used_id LIMIT 1;"))[0];
my $num = substr($curr_id,1);
$num++;
$client_id = "c" . $num;

# Begin transaction
eval {
    # Insert new client details
    $sth = $dbh->prepare("INSERT INTO client VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);");
    $sth->execute($client_id, $insertData{'firstname'}, $insertData{'lastname'},
                  $insertData{'address_line_1'}, $insertData{'address_line_2'},
                  $insertData{'address_line_3'}, $insertData{'address_line_4'},
                  $insertData{'postcode'}, $insertData{'country'}, $insertData{'date_of_birth'},
                  $insertData{'tel_no'}, $insertData{'email_address'});

    # Insert new credit card details
    $sth = $dbh->prepare("INSERT INTO credit_card VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);");
    $sth->execute($insertData{'card_no'}, $insertData{'firstname'}, $insertData{'lastname'},
                  $insertData{'address_line_1'}, $insertData{'address_line_2'}, $insertData{'address_line_3'},
                  $insertData{'address_line_4'}, $insertData{'postcode'}, $insertData{'country'},
                  $insertData{'card_type'}, $insertData{'start_date'}, $insertData{'end_date'},
                  $insertData{'issue_no'}, $insertData{'ccv_code'}, $client_id);

    $sth = $dbh->prepare("UPDATE last_used_id SET client_id = ?;");
    $sth->execute($client_id);

    # No errors so far. Commit.
    $dbh->commit();
};
# End transaction

if ($@) {
    # Something went wrong. Report the error and roll back.
    print $cgi->header();
    print $cgi->start_html("Client could not be added");
    print $cgi->p("Error adding new client:", $cgi->br, $@);

    $dbh->rollback();
}

print $cgi->header();
print $cgi->start_html("Client added successfully");
print $cgi->p($cgi->h1("Registration completed successfully"));
print $cgi->p("Congratulations $insertData{'firstname'} $insertData{'lastname'}! You are now registered with Kosovo Tours");
print $cgi->end_html();

# Tidy up and disconnect
$dbh->disconnect();

