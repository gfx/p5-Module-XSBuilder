package Acme::MoreComplexFooXS;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";

use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

1;
__END__

=encoding utf-8

=head1 NAME

Acme::MoreComplexFooXS - It's new $module

=head1 SYNOPSIS

    use Acme::MoreComplexFooXS;

=head1 DESCRIPTION

Acme::MoreComplexFooXS is ...

=head1 LICENSE

Copyright (C) Fuji, Goro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Fuji, Goro E<lt>g.psy.va@gmail.comE<gt>

