# NAME

URL::List - Object-oriented methods of handling list of URLs.

# VERSION

Version 0.11

# SYNOPSIS

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

# DESCRIPTION

URL:List is a module which helps you with distributing a list of URLs "evenly"
based on the URLs' host name, domain name or TLD (top-level domain).

This can be useful for crawlers, ie. giving out a list of URLs within specific
hostnames, domain names and/or TLD names to different workers.

# METHODS

## new

Returns an instance of URL::List.

Takes one optional parameter, 'allow\_duplicates', which is default 0. By setting
it to true (1), URL::List will not filter out duplicate articles.

## add( $url )

Add a URL to the list.

## all

Returns an array reference of all the URLs in the list. This list can include
duplicates.

## count

Returns the number of URLs in the list, including potential duplicates,
depending on the 'allow\_duplicates' setting.

## clear

Clears the URL list.

## flush

An alias for `clear`.

## distributions

Returns a hash reference of all the possible distributions.

This method should not be used directly. Instead, the distributed\_by\_\* methods
should be used.

## distributed\_by\_host

Returns a hash reference where the key is the host name, like "www.google.com",
and the value is an array reference to the host name's URLs.

## distributed\_by\_domain

Returns a hash reference where the key is the domain name, like "google.com",
and the value is an array reference to the domain name's URLs.

## distributed\_by\_tld

Returns a hash reference where the key is the top-level domain name, like "com",
and the value is an array reference to the top-level domain name's URLs.

# LICENSE AND COPYRIGHT

Copyright 2012-2013 Tore Aursand.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

[http://www.perlfoundation.org/artistic\_license\_2\_0](http://www.perlfoundation.org/artistic\_license\_2\_0)

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
