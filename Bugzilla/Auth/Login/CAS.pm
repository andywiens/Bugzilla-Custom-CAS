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

use AuthCAS;

use constant requires_verification => 0;
use constant can_login => 0;
use constant is_automatic => 1;

sub get_login_info {
    my ($self) = @_;
    my $params = Bugzilla->input_params;
    
    my $service_ticket = trim(delete $params->{"ticket"});
    
    if ($service_ticket) {
        #validate service ticket
        my $cas = $self->cas_server();
        my $user = $cas->validateST(Bugzilla->cgi->url(),$service_ticket);
        if (AuthCAS::get_errors()) {
            # errors kept the service ticket from validating. it could be that the ticket expired as well, 
            # so just returning no data ... could prove to be a bad decision ... maybe throwing an error is better
            return { failure => AUTH_NODATA };
        }
        # should look for any saved url parameters and push back into parameter hash, then return user
        return { username => $user . Bugzilla->params->{"cas_user_domain"} || '' } if $user;
    }
    return { failure => AUTH_NODATA };
}

sub fail_nodata {
    my ($self) = @_;
    my $cgi = Bugzilla->cgi;
    
    my $cas = $self->cas_server();
    my $login_url = $cas->getServerLoginURL($cgi->url());
    
    my $service_name = Bugzilla->params->{"cas_service_name"} || 'Bugzilla';
    my $logout_callback = $self->logout_redirect_url();
    
    my $redirection_url = $login_url . '&serviceName=' . $service_name . '&logoutCallback=' . $logout_callback;
    
    # should save the request parameters (at least the post parameters), then redirect to the cas server

    print $cgi->redirect($redirection_url);
}

sub cas_server {
    return new AuthCAS(casUrl => Bugzilla->params->{"cas_url"},
        CAPath => Bugzilla->params->{"cas_cert_path"});
}

sub logout {
    my $cas_logout_url = Bugzilla->params->{"cas_logout_url"};
    
    if ( $cas_logout_url ) {
        print( Bugzilla->cgi->redirect($cas_logout_url) );
    }
}

sub logout_redirect_url {
    my $cgi = Bugzilla->cgi;
    
    my $p = $cgi->url(-path => 1);
    my $r = $cgi->url(-relative => 1);
    
    if ($r) {
        return substr($p,0,rindex($p, $r)) . 'ksulogout.cgi';
    }
     
    return $p . 'ksulogout.cgi';
}






1;
