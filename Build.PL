use strict;
use warnings;

use Module::Build;

my $Builder = Module::Build->new(
    module_name         => 'URL::List',
    license             => 'perl',
    dist_author         => 'Tore Aursand <toreau@gmail.com>',
    dist_version_from   => 'lib/URL/List.pm',
    build_requires => {
        'Mouse' => 1.05,
        'MouseX::NativeTraits' => 1.09,
        'URI' => 1.60,
        'namespace::autoclean' => 0.13,
        'Test::More' => 0.98,
    },
    create_makefile_pl  => 'traditional',
);

$Builder->create_build_script();
