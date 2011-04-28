package Crypt::Random::Source::Strong;
BEGIN {
  $Crypt::Random::Source::Strong::AUTHORITY = 'cpan:NUFFIN';
}
BEGIN {
  $Crypt::Random::Source::Strong::VERSION = '0.07';
}
# ABSTRACT: Abstract base class for strong random data sources

use Any::Moose;

sub is_strong { 1 }

1;


# ex: set sw=4 et:

__END__
=pod

=encoding utf-8

=head1 NAME

Crypt::Random::Source::Strong - Abstract base class for strong random data sources

=head1 SYNOPSIS

    use Moose;

    extends qw(Crypt::Random::Source::Strong);

=head1 DESCRIPTION

This is an abstract base class. There isn't much to describe.

=head1 METHODS

=head2 is_strong

Returns true

=head1 AUTHOR

  Yuval Kogman <nothingmuch@woobling.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Yuval Kogman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

