package Crypt::Random::Source::Base::RandomDevice;
BEGIN {
  $Crypt::Random::Source::Base::RandomDevice::AUTHORITY = 'cpan:NUFFIN';
}
BEGIN {
  $Crypt::Random::Source::Base::RandomDevice::VERSION = '0.07';
}
# ABSTRACT: Base class for random devices

use Any::Moose;

extends qw(Crypt::Random::Source::Base::File);

sub rank { 100 } # good quality, pretty fast

has '+path' => (
    builder => "default_path",
);

sub available {
    -r shift->default_path;
}

sub seed {
    my ( $self, @args ) = @_;

    my $fh = $self->open_handle("w+");

    print $fh @args;

    close $fh;
}

sub default_path {
    die "abstract";
}

1;


# ex: set sw=4 et:

__END__
=pod

=encoding utf-8

=head1 NAME

Crypt::Random::Source::Base::RandomDevice - Base class for random devices

=head1 SYNOPSIS

    use Moose;

    extends qw(Crypt::Random::Source::Base::RandomDevice);

    sub default_path { "/dev/myrandom" }

=head1 DESCRIPTION

This is a base class for random device sources.

See L<Crypt::Random::Source::Strong::devrandom> and
L<Crypt::Random::Source::Weak::devurandom> for actual implementations.

=head1 AUTHOR

  Yuval Kogman <nothingmuch@woobling.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Yuval Kogman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

