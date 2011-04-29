package Crypt::Random::Source::Base::Proc;
BEGIN {
  $Crypt::Random::Source::Base::Proc::AUTHORITY = 'cpan:NUFFIN';
}
BEGIN {
  $Crypt::Random::Source::Base::Proc::VERSION = '0.07';
}
# ABSTRACT: Base class for helper processes (e.g. C<openssl>)

use Any::Moose;

extends qw(Crypt::Random::Source::Base::Handle);

use Capture::Tiny qw(capture);
use File::Spec;
use IO::File;

use 5.008;

has command => ( is => "rw", required => 1 );
has search_path => ( is => 'rw', isa => 'Str', lazy_build => 1 );

# This is a scalar so that people can customize it (which they would
# particularly need to do on Windows).
our $TAINT_PATH =
    '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin';

sub _build_search_path {
    # In taint mode it's not safe to use $ENV{PATH}.
    if (${^TAINT}) {
        return $TAINT_PATH;
    }
    return $ENV{PATH};
}

sub open_handle {
    my $self = shift;

    my $cmd = $self->command;
    my @cmd = ref $cmd ? @$cmd : $cmd;
        my $retval;
        local $ENV{PATH} = $self->search_path;
        my ($stdout, $stderr) = capture { $retval = system(@cmd) };
        chomp($stderr);
        if ($retval) {
            my $err = join(' ', @cmd) . ": $! ($?)";
            if ($stderr) {
                $err .= "\n$stderr";
            }
            die $err;
        }
        warn $stderr if $stderr;

    my $fh = IO::File->new(\$stdout, '<');

    return $fh;
}

1;



# ex: set sw=4 et:

__END__
=pod

=encoding utf-8

=head1 NAME

Crypt::Random::Source::Base::Proc - Base class for helper processes (e.g. C<openssl>)

=head1 SYNOPSIS

    use Moose;

    extends qw(Crypt::Random::Source::Base::Proc);

    has '+command' => ( default => ... );

=head1 DESCRIPTION

This is a base class for using command line utilities which output random data
on STDOUT as L<Crypt::Random::Source> objects.

=head1 ATTRIBUTES

=head2 command

An array reference or string that is the command to run.

=head1 METHODS

=head2 open_handle

Opens a pipe for reading using C<command>.

=head1 AUTHOR

  Yuval Kogman <nothingmuch@woobling.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Yuval Kogman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

