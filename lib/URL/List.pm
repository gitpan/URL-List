package URL::List;
use Mouse;
use namespace::autoclean;

=head1 NAME

URL::List - Object-oriented methods of handling list of URLs.

=head1 VERSION

Version 0.11

=cut

our $VERSION = '0.11';

use Carp;
use Domain::PublicSuffix;
use List::MoreUtils qw( uniq );
use URI;

=head1 SYNOPSIS

    use URL::List;

    my $list = URL::List->new; # or URL::List->new;
    $list->add( 'http://www.google.com/' );
    $list->add( 'http://www.bbc.co.uk/' );

    my $distributed_by_hosts = $list->distributed_by_host;

    # $VAR1 = {
    #     'www.google.com' => [
    #         'http://www.google.com/',
    #     ],
    #     'www.bbc.co.uk' => [
    #         'http://www.bbc.co.uk/',
    #     ],
    # };

    my $distributed_by_domains = $list->distributed_by_domain;

    # $VAR1 = {
    #     'google.com' => [
    #         'http://www.google.com/',
    #     ],
    #     'bbc.co.uk' => [
    #         'http://www.bbc.co.uk/',
    #     ],
    # };

    my $distributed_by_tlds = $list->distributed_by_tld;

    # $VAR1 = {
    #     'com' => [
    #         'http://www.google.com/',
    #     ],
    #     'co.uk' => [
    #         'http://www.bbc.co.uk/',
    #     ],
    # };

    my $urls = $list->all; # All the URLs are still there, so use this...
    $list->clear;          # ...to clear the list.

=head1 DESCRIPTION

URL:List is a module which helps you with distributing a list of URLs "evenly"
based on the URLs' host name, domain name or TLD (top-level domain).

This can be useful for crawlers, ie. giving out a list of URLs within specific
hostnames, domain names and/or TLD names to different workers.

=head1 METHODS

=head2 new

Returns an instance of URL::List.

Takes one optional parameter, 'allow_duplicates', which is default 0. By setting
it to true (1), URL::List will not filter out duplicate articles.

=cut

has 'allow_duplicates' => ( isa => 'Bool',          is => 'rw', default => 0          );
has 'urls'             => ( isa => 'ArrayRef[Str]', is => 'rw', default => sub { [] } );

=head2 add( $url )

Add a URL to the list.

=cut

sub add {
    my $self = shift;
    my $url  = shift;

    if ( defined $url && length $url ) {
        push( @{$self->urls}, $url );
    }
}

=head2 all

Returns an array reference of all the URLs in the list. This list can include
duplicates.

=cut

sub all {
    my $self = shift;

    if ( $self->allow_duplicates ) {
        return $self->urls;
    }
    else {
        return [ List::MoreUtils::uniq(@{$self->urls}) ];
    }
}

=head2 count

Returns the number of URLs in the list, including potential duplicates,
depending on the 'allow_duplicates' setting.

=cut

sub count {
    my $self = shift;

    return scalar( @{$self->all} );
}

=head2 clear

Clears the URL list.

=cut

sub clear {
    my $self = shift;

    $self->urls( [] );
}

=head2 flush

An alias for C<clear>.

=cut

sub flush {
    return shift->clear;
}

#
# DISTRIBUTIONS
#

=head2 distributions

Returns a hash reference of all the possible distributions.

This method should not be used directly. Instead, the distributed_by_* methods
should be used.

=cut

has 'distributions' => ( isa => 'HashRef', is => 'ro', lazy_build => 1 );

sub _build_distributions {
    my $self = shift;

    #
    # Create a list of valid URLs
    #
    my @urls = ();

    foreach my $url ( @{$self->all} ) {
        if ( my $uri = URI->new($url) ) {
            push( @urls, $url );
        }
        else {
            carp "Couldn't create a URI object from '" . $url . "'. Skipping it!";
        }
    }

    #
    # Build the different distributions
    #
    my %distributions = ();
    my $suffix        = Domain::PublicSuffix->new;

    foreach my $url ( @urls ) {
        my $host = undef;

        eval {
            $host = URI->new( $url )->host;
        };

        if ( $@ ) {
            carp "Failed to determine host from '" . $url . "'. Skipping it!";
            next;
        }

        if ( defined $host && length $host ) {
            my $domain = $suffix->get_root_domain( $host );
            my $tld    = $suffix->tld;

            push( @{$distributions{host}->{$host}}, $url );

            if ( defined $domain && length $domain ) {
                push( @{$distributions{domain}->{$domain}}, $url );
            }
            else {
                carp "Failed to determine the domain name from '" . $url . "'. Skipping it!";
                next;
            }

            if ( defined $tld && length $tld ) {
                push( @{$distributions{tld}->{$tld}}, $url );
            }
            else {
                carp "Failed to determine the TLD from '" . $url . "'. Skipping it!";
                next;
            }
        }
        else {
            carp "Failed to determine host from '" . $url . "'. Skipping it!";
        }
    }

    #
    # Return
    #
    return \%distributions;
}

=head2 distributed_by_host

Returns a hash reference where the key is the host name, like "www.google.com",
and the value is an array reference to the host name's URLs.

=cut

sub distributed_by_host {
    my $self = shift;

    return $self->distributions->{host};
}

=head2 distributed_by_domain

Returns a hash reference where the key is the domain name, like "google.com",
and the value is an array reference to the domain name's URLs.

=cut

sub distributed_by_domain {
    my $self = shift;

    return $self->distributions->{domain};
}

=head2 distributed_by_tld

Returns a hash reference where the key is the top-level domain name, like "com",
and the value is an array reference to the top-level domain name's URLs.

=cut

sub distributed_by_tld {
    my $self = shift;

    return $self->distributions->{tld};
}

#
# The End
#
__PACKAGE__->meta->make_immutable;

1;

=head1 LICENSE AND COPYRIGHT

Copyright 2012-2013 Tore Aursand.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
