package OAuth2::Provider::Plugin::Token;

use 5.012;
use Any::Moose 'Role';
use Cache::KyotoTycoon;
use Try::Tiny;
use MIME::Base64 qw(encode_base64 decode_base64);
use Storable qw/nfreeze thaw/;

# ABSTRACT: AuthToken Storage provider backed by KyotoTycoon
#
# Version



around 'validate_by_token' => sub {
    my ($orig, $self, $token, $client) = @_;

    if($client){
        return $self->get_refresh_token($token);
    } else {
        return $self->get_access_token($token);
    }
};

around 'get_access_token' => sub {
    my ($orig, $self, $token) = @_;

    return $self->cache_get($token);
};

around 'get_refresh_token' => sub {
    my ($orig, $self, $token) = @_;

    # find refresh token in couchdb
};

around 'create_access_token' => sub {
    my ($orig, $self, $client, $refresh_token) = @_;

    # generate a access token, save it in the cache, log it somewhere.
    # generate a refresh token and save it in the DB
};

1;
