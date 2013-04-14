package Module::XSBuilder;
use 5.008001;
use strict;
use warnings;
use warnings FATAL => qw(uninitialized recursion);

our $VERSION = "0.01";

BEGIN {
    require Module::Build;
    our @ISA = qw(Module::Build);
}

use Fatal qw(open close);
use File::Basename;
use Devel::PPPort;

my $xs_src   = 'src';
my $xs_build = '.build/xsbuilder';

my %configure_requires = (
    (__PACKAGE__)   => $VERSION,
    'Devel::PPPort' => Devel::PPPort->VERSION,
);

sub new {
    my($class, %args) = @_;

    Devel::PPPort::WriteFile("$xs_src/ppport.h");

    my $xsbuilder_xs_src   = $args{xsbuilder_xs_src}   || $xs_src;
    my $xsbuilder_xs_build = $args{xsbuilder_xs_build} || $xs_build;

    my $so_prefix = $args{module_name};
    $so_prefix =~ s/::\w+$//;
    $so_prefix =~ s{::}{/}g;

    $args{needs_compiler} = 1;
    $args{xs_files} = {
        map { $_ => "./$xs_build/" . $_ }
        glob("$xs_src/*.xs"),
    };

    $args{extra_compiler_flags} = ["-I$xs_src"];

    my $self = $class->SUPER::new(%args);

    for my $name(keys %configure_requires) {

        $self->_add_prereq('configure_requires',
            $name, $configure_requires{$name},
        );
    }

    $self->notes(xsbuilder_xs_src   => $xsbuilder_xs_src);
    $self->notes(xsbuilder_xs_build => $xsbuilder_xs_build);

    return $self;
}

sub process_xs_files {
    my($self) = @_;

    my $xsbuilder_xs_src   = $self->notes('xsbuilder_xs_src');
    my $xsbuilder_xs_build = $self->notes('xsbuilder_xs_build');

    # NOTE:
    # XS modules are consist of not only *.xs, but also *.c, *.xsi, and etc.
    foreach my $from(glob "$xsbuilder_xs_src/*.{c,cpp,cxx,xsi,xsh}") {
        my $to = "$xsbuilder_xs_build/$from";
        $self->add_to_cleanup($to);
        $self->copy_if_modified(from => $from, to => $to);
    }

    $self->SUPER::process_xs_files();
}

sub _infer_xs_spec {
    my($self, $xs_file) = @_;

    my $spec = $self->SUPER::_infer_xs_spec($xs_file);

    $spec->{module_name} = $self->module_name;

    my @d = split /::/, $spec->{module_name};

    my $basename = pop @d;

    # NOTE:
    # They've been infered from the XS filename, but it's a bad idea!
    # That's because these names are used by XSLoader, which
    # deduces filenames from the module name, not an XS filename.

    $spec->{archdir} = File::Spec->catfile(
        $self->blib, 'arch', 'auto',
        @d, $basename);

    $spec->{bs_file}    = File::Spec->catfile(
        $spec->{archdir},
        $basename . '.bs');

    $spec->{lib_file}    = File::Spec->catfile(
        $spec->{archdir},
        $basename . '.' . $self->{config}->get('dlext'));

    #use Data::Dumper; print Dumper $spec;

    return $spec;
}

1;
__END__

=encoding utf-8

=head1 NAME

Module::XSBuilder - Module::Build extension to build XS modules

=head1 SYNOPSIS

    use Module::XSBuilder; # use this instead of Module::Build

    # or set into minil.toml
    # [build]
    # build_class = "Module::XSBuilder"

=head1 DESCRIPTION

Module::XSBuilder supports building XS modules,
started a a port of Module::Install::XSUtil for Module::Build.

=head1 LICENSE

Copyright (C) Fuji, Goro. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Fuji, Goro E<lt>g.psy.va@gmail.comE<gt>

