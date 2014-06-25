#!/bin/perl
use warnings;
use strict;

use Config::Simple

our %config;

Config::Simple->import_from(kostour.ini', \%config);