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
print $cgi->header;
print $cgi->start_html(-title => "Register as a new client");
print $cgi->$h1("Please enter your details:");
print $cgi->start_form;
    print $cgi->p("First Name: ", textfield(-name=>'firstname'));
    print $cgi->p("Last Name: ", textfield(-name=>'lastname'));
    print $cgi->p("Address Line 1: ", textfield(-name=>'address_line_1'));
    print $cgi->p("Address Line 2: ", textfield(-name=>'address_line_2'));
    print $cgi->p("Address Line 3: ", textfield(-name=>'address_line_3'));
    print $cgi->p("Address Line 4: ", textfield(-name=>'address_line_4'));
    print $cgi->p("Postcode: ", textfield(-name=>'postcode'));
    print $cgi->p("Country: ", textfield(-name=>'country'));
    print $cgi->p("Date of birth: ", textfield(-name=>'date_of_birth'));
    print $cgi->p("Phone Number: ", textfield(-name=>'tel_no'));
    print $cgi->p("Email Address: ", textfield(-name=>'email_address'));
    print $cgi->p(h2("You must register a credit or debit card with your account. Please enter details below:"));
    print $cgi->p("Card Number: ", textfield(-name=>'card_no'));
    print $cgi->p("Card Type: ", textfield(-name=>'card_type'));
    print $cgi->popup_menu(-name=>'card_type', -values=>$cardTypeValues, -labels=>$cardTypeLabels);
    print $cgi->p("Start Date: ", textfield(-name=>'start_date'));
    print $cgi->p("Expiry Date: ", textfield(-name=>'end_date'));
    print $cgi->p("Issue Number: ", textfield(-name=>'issue_no'));
    print $cgi->p("CCV Code: ", textfield(-name=>'ccv_code'));
    p(submit),
print $cgi->end_form;

print end_html();








# Read user input from webpage into hash for DB insertion

%insertData = $cgi->param();

foreach ($cgi->param()) {
    #unless ($_ == 'email_address' or $_ == 'postcode') {
        $insertData{$_} = $cgi->param($_, ucfirst(lc($cgi->param($_))));
    #} else {
    #    $insertData{$_} = $cgi->param($_);
    #}
}

# Insert the data
# TODO - What to do about PK?
#$sth = $dbh->prepare("INSERT INTO client VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);");
#$sth->execute('c00001', $insertData{'firstname'}, $insertData{'lastname'},
#              $insertData{'address_line_1'}, $insertData{'address_line_2'},
#              $insertData{'address_line_3'}, $insertData{'address_line_4'},
#              $insertData{'postcode'}, $insertData{'country'}, $insertData{'date_of_birth'},
#              $insertData{'tel_no'}, $insertData{'email_address'}) || die "Couldn't insert data: $DBI::errstr.\n";
#
print $cgi->header();
print $cgi->start_html("Add client");
#print $cgi->p($cgi->h1("Registration completed successfully"));
#print $cgi->p("Congratulations $insertData{'firstname'} $insertData{'lastname'}! You are now registered with Kosovo Tours");
foreach (keys %insertData) {
    print $cgi->p("$_:\t$insertData{$_}\n");
}
print $cgi->end_html();

# Tidy up and disconnect
#$sth->finish();
$dbh->disconnect();

sub generate_form {
#<FORM METHOD=GET ACTION="/cgi-bin/add_client.pl">
    return start_form,
    h1("Please enter your details:"),
    p("First Name: ", textfield('firstname')),
    p("Last Name: ", textfield('lastname')),
    p("Address Line 1: ", textfield('address_line_1')),
    p("Address Line 2: ", textfield('address_line_2')),
    p("Address Line 3: ", textfield('address_line_3')),
    p("Address Line 4: ", textfield('address_line_4')),
    p("Postcode: ", textfield('postcode')),
    p("Country: ", textfield('country')),
    p("Date of birth: ", textfield('date_of_birth')),
    p("Phone Number: ", textfield('tel_no')),
    p("Email Address: ", textfield('email_address')),
    p(h2("You must register a credit or debit card with your account. Please enter details below:")),
    p("Card Number: ", textfield('card_no')),
    p("Card Type: ", textfield('card_type')),
    p("Start Date: ", textfield('start_date')),
    p("Expiry Date: ", textfield('end_date')),
    p("Issue Number: ", textfield('issue_no')),
    p("CCV Code: ", textfield('ccv_code')),
    p(submit),
    end_form;
}

