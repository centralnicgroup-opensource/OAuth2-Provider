package OAuth2::Provider::Plugin::Token;

use 5.012;
use Any::Moose 'Role';
use Data::UUID;

# ABSTRACT: Token provider for OAuth2 Provider
#
# Version


has 'token_expire' => (
    is       => 'rw',
    isa      => 'Int',
    required => 1,
    default  => 3600,
);


has 'token' => {
    is => 'rw',
    isa => 'Str',
    lazy => 1,
    builder => 'generate_token'
};


around 'authenticator' => sub {
    my ($orig, $self, $req, $mode) = @_;

    my $client = $self->get_client_by_id($req->{client_id});
    return $self->error('client_not_found') unless $client;

    return $self->error('client_authentication_failed')
        unless $client->{client_secret} eq $req->{client_secret};

    my $token;
    given ($req->{grant_type}) {
        when (/^authorization_code$/i) {
            my $code = $self->validate_by_token($req->{token});
            return $self->error('no_valid_token') unless $code;

            # TODO is this where we also need to add support for roles?
            return $self->error('invalid_grant')
                unless $code->{redirect_uri} eq $req->{redirect_uri};
            $token = $self->get_access_token($code);
        }
        when (/^password$/i) {
            my $user =
                $self->validate_user_by_username($req->{username},
                $req->{password});
            return $self->error('invalid_grant') unless $user;
            $token = $self->create_access_token($client);
        }
        when (/^client_credentials$/i) {

            # already authenticated
            my $token = $self->create_access_token($client);
            return { access_token => $token };
        }
        when (/^refresh_token$/i) {
            my $code = $self->validate_by_token($req->{refresh_token}, $client);
            return $self->error('no_valid_token') unless $code;
            $token = $self->create_access_token($client, $code);
        }
        default { return $self->error('unsupported_grant_type'); }
    }
    given ($mode) {
        when ('mac') {
            return $self->to_mac_token({ access_token => $token });
        }
        default {
            return $self->to_bearer_token({ access_token => $token });
        }
    }
};

sub generate_token {
    my $self = shift;

    my $ug = new Data::UUID;
    my $token = $ug->create_b64();
    $token = s/\W//g;
    return $token;
}

1;

__END__

=pod

=head1 NAME

OAuth2::Provider::Plugin::Token - Token provider for OAuth2 Provider

=head1 VERSION

version 0.1

=head2 token_expire

Default token expire in seconds.

=head2 token

Implicitly generate a token

=head1 AUTHOR

Lenz Gschwendtner <lenz@springtimesoft.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by springtimesoft LTD.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
