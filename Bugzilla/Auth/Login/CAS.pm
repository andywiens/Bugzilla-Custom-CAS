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
# Contributor(s): Andy Wiens <andy@ksu.edu>

package Bugzilla::Auth::Login::CAS;
use strict;
use base qw(Bugzilla::Auth::Login);

use Bugzilla::Constants;
use Bugzilla::Util;

use constant requires_verification => 0;
use constant can_login => 0;
use constant is_automatic => 1;

sub get_login_info {
    my ($self) = @_;
    my $params = Bugzilla->input_params;
    
    my $service_ticket = trim(delete $params->{"ST"});
    
    if ($service_ticket) {
        #validate service ticket
        my $cas = $self->cas_server();
        my $user = $cas->validateST(Bugzilla->cgi->url(),$service_ticket);
        
        return { username => $user } if $user;
        
        #if invalid throw error or return no data
        #else look for any saved url parameters and push back into parameter hash, then return user
    }
    return { failure => AUTH_NODATA };
}

sub fail_nodata {
    my ($self) = @_;
    my $cgi = Bugzilla->cgi;
    
    my $cas = $self->cas_server();
    my $login_url = $cas->getServerLoginURL($cgi->url());
    
    print $cgi->redirect($login_url);
    
    # save the request parameters (at least the post parameters), then redirect to the cas server
    
    # TODO:finish!
}

sub cas_server {
    return new AuthCAS(casUrl => Bugzilla->params->{"cas_url"},
        CAFile => Bugzilla->params->{"cas_server_cert"});
}




1;
