#!/usr/bin/perl
# Copyright muflax <muflax@gmail.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>
use strict;
use warnings;

my @entries = glob "*";

for (grep {-d} @entries) {
    system("zip -1 -r \"$_.zip\" \"$_\" && trash-put \"$_\"");
}
