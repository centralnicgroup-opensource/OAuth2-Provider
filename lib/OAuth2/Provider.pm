package OAuth2::Provider;

use 5.012;
use Any::Moose;

# ABSTRACT: A generic OAuth2 Provider

# VERSION


=head1 SYNOPSIS

OAuth2 clients are plenty but provider are harder to find than they
should be. This provider is written in a way that hopefully makes it
easy to tweak for your environment.

=head1 ATTRIBUTES

=head2 attr

=cut

has 'attr' => (
    is => 'rw',
);



=head1 SUBROUTINES/METHODS

General authentocator implementing all authentication mechanisms

=head2 authenticator

=cut

sub authenticator { }


=head2 get_client_by_id

Get a client definition by client_id

=cut

sub get_client_by_id { }



=head2 validate_by_token

Validate a token, check it for expiration and return the associated
info for the token. This accepts a optional second parameter if the
requests is for a refresh_token.

=cut

sub validate_by_token { }


=head2 validate_user_by_username

Validate a user/password combination

=cut

sub validate_user_by_username { }


=head2 get_access_token

Get a access_token from the storage plugin

=cut

sub get_access_token { }


=head2 create_access_token

Create access token based on the client information. This has a optional
second parameter if the token are based off a refresh_token

=cut

sub create_access_token {
    #body ...
}


=head2 to_bearer_token

Convert a token to a Bearer Token

=cut

sub to_bearer_token { }


=head2 to_mactoken

Convert a token to a MAC token

=cut

sub to_mactoken { }

=head2 error

General error handler

=cut

sub error {
    my($self, $error) = @_;

    warn $error;
    return;
}


=head1 BUGS

Please report any bugs or feature requests on GitHub's issue tracker L<https://github.com/<github_user>/OAuth2::Provider/issues>.
Pull requests welcome.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc OAuth2::Provider


You can also look for information at:

=over 4

=item * GitHub repository

L<https://github.com/<github_user>/OAuth2::Provider>

=item * MetaCPAN

L<https://metacpan.org/module/OAuth2::Provider>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/OAuth2::Provider>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/OAuth2::Provider>

=back


=head1 ACKNOWLEDGEMENTS

=over 4

=item * Lenz Gschwendtner (@norbu09), for being an awesome mentor and friend.

=back

=cut

1;  # End of OAuth2::Provider
