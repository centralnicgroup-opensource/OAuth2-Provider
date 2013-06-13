package OAuth2::Provider::Plugin::Token;

use 5.012;
use Any::Moose 'Role';
use Cache::KyotoTycoon;
use Try::Tiny;
use MIME::Base64 qw(encode_base64 decode_base64);
use Storable qw/nfreeze thaw/;

# ABSTRACT: KyotoTycoon Storage provider
#
# Version

=head1 ATTRIBUTES

=head2 tycoon_host

=cut

has 'tycoon_host' => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => sub { 'localhost' },
);

=head2 tycoon_port

=cut

has 'tycoon_port' => (
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1,
    default => sub { 1978 },
);

=head2 tycoon_db

=cut

has 'tycoon_db' => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => sub { 0 },
);

=head2 tycoon_connect_timeout

=cut

has 'tycoon_timeout' => (
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1,
    default => sub { 5 },
);

=head2 tycoon

=cut

has 'tycoon' => (
    is       => 'rw',
    isa      => 'Cache::KyotoTycoon',
    required => 1,
    builder  => '_connect_tycoon',
);

sub _connect_tycoon {
    my $self = shift;

    my $tycoon = KyotoTycoon->new(
        host    => $self->tycoon_host,
        port    => $self->tycoon_port,
        timeout => $self->tycoon_timeout,
        db      => $self->tycoon_db,
    );
    return $tycoon;
}

=head2

cache_get is used to get a value from a fast cache as opposed to a slow database. this should be used to look up access_token

=cut

sub cache_get {
    my ($self, $key) = @_;

    my ($value, $expire) = $self->tycoon->get($key);
    return unless defined $value;
    return (thaw(decode_base64($value)), $expire);
}

=head2

cache_set is used to set a value in a fast cache as opposed to a slow database. this should be used to store access_token

=cut

sub cache_set {
    my ($self, $key, $data, $expire) = @_;

    $data = encode_base64(nfreeze($data));
    try {
        return $self->tycoon->replace($key, $data, $expire);
    }
    catch {
        return $self->tycoon->set($key, $data, $expire)
    };
    return 1;
}

1;
