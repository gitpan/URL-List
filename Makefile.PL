
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Object-oriented methods of handling list of URLs.",
  "AUTHOR" => "Tore Aursand <toreau\@gmail.com>",
  "BUILD_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.64",
    "Test::More" => "0.98"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "URL-List",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "URL::List",
  "PREREQ_PM" => {
    "Domain::PublicSuffix" => "0.08",
    "Mouse" => "1.05",
    "MouseX::NativeTraits" => "1.09",
    "URI" => "1.60",
    "namespace::autoclean" => "0.13"
  },
  "VERSION" => "0.05",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



