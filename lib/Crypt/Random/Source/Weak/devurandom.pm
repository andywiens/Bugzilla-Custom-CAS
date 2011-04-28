package Crypt::Random::Source::Weak::devurandom;
BEGIN {
  $Crypt::Random::Source::Weak::devurandom::AUTHORITY = 'cpan:NUFFIN';
}
BEGIN {
  $Crypt::Random::Source::Weak::devurandom::VERSION = '0.07';
}
# ABSTRACT: A weak random data source using F</dev/urandom>

use Any::Moose;

extends qw(
    Crypt::Random::Source::Weak
    Crypt::Random::Source::Base::RandomDevice
);

sub default_path { "/dev/urandom" }

1;


# ex: set sw=4 et:

__END__
=pod

=encoding utf-8

=head1 NAME

Crypt::Random::Source::Weak::devurandom - A weak random data source using F</dev/urandom>

=head1 SYNOPSIS

    use Crypt::Random::Source::Weak::devurandom;

=head1 AUTHOR

  Yuval Kogman <nothingmuch@woobling.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Yuval Kogman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

