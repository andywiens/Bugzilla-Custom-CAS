package Crypt::Random::Source::Weak::rand;
BEGIN {
  $Crypt::Random::Source::Weak::rand::AUTHORITY = 'cpan:NUFFIN';
}
BEGIN {
  $Crypt::Random::Source::Weak::rand::VERSION = '0.07';
}
# ABSTRACT: Use C<rand> to create random bytes

use Any::Moose;

use bytes;

extends qw(
    Crypt::Random::Source::Weak
    Crypt::Random::Source::Base
);

sub rank { -100 } # slow fallback

sub available { 1 }

sub seed {
    my ( $self, @args ) = @_;
    srand( unpack("%L*", @args) );
}

sub get {
    my ( $self, $n ) = @_;
    pack "C*", map { int rand 256 } 1 .. $n;
}

1;




# ex: set sw=4 et:

__END__
=pod

=encoding utf-8

=head1 NAME

Crypt::Random::Source::Weak::rand - Use C<rand> to create random bytes

=head1 SYNOPSIS

    use Crypt::Random::Source::Weak::rand;

    my $p = Crypt::Random::Source::Weak::rand->new;

    $p->get(1024);

=head1 DESCRIPTION

This is a weak source of random data, that uses Perl's builtin C<rand>
function.

=head1 METHODS

=head2 seed @blah

Sets the random seed to a checksum of the stringified values of C<@blah>.

There is no need to call this method unless you want the random sequence to be
identical to a previously run, in which case you should seed with the same
value.

=head2 get $n

Produces C<$n> random bytes.

=head1 AUTHOR

  Yuval Kogman <nothingmuch@woobling.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Yuval Kogman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

