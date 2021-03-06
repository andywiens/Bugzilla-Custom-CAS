# -*- Mode: perl; indent-tabs-mode: nil -*-
#
# The contents of this file are subject to the Mozilla Public
# License Version 1.1 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy of
# the License at http://www.mozilla.org/MPL/
#
# Software distributed under the License is distributed on an "AS
# IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
# implied. See the License for the specific language governing
# rights and limitations under the License.
#
# The Original Code is the Bugzilla Bug Tracking System.
#
# The Initial Developer of the Original Code is Everything Solved, Inc.
# Portions created by the Initial Developer are Copyright (C) 2010 the
# Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Max Kanat-Alexander <mkanat@bugzilla.org>

# This test combines two field/operator combinations using AND in
# a single boolean chart.
package Bugzilla::Test::Search::AndTest;
use base qw(Bugzilla::Test::Search::OrTest);

use Bugzilla::Test::Search::Constants;
use Bugzilla::Test::Search::FakeCGI;
use List::MoreUtils qw(all);

use constant type => 'AND';

#############
# Accessors #
#############

# In an AND test, bugs ARE supposed to be contained only if they are contained
# by ALL tests.
sub bug_is_contained {
    my ($self, $number) = @_;
    return all { $_->bug_is_contained($number) } $self->field_tests;
}

########################
# SKIP & TODO Messages #
########################

sub _join_skip { () }
sub _join_broken_constant { {} }

##############################
# Bugzilla::Search arguments #
##############################

sub search_params {
    my ($self) = @_;
    my @all_params = map { $_->search_params } $self->field_tests;
    my $params = new Bugzilla::Test::Search::FakeCGI;
    my $chart = 0;
    foreach my $item (@all_params) {
        $params->param("field0-$chart-0", $item->param('field0-0-0'));
        $params->param("type0-$chart-0", $item->param('type0-0-0'));
        $params->param("value0-$chart-0", $item->param('value0-0-0'));
        $chart++;
    }
    return $params;
}

1;