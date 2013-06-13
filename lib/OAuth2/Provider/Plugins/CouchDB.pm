package OAuth2::Provider::Plugin::CouchDB;

use 5.012;
use Any::Moose 'Role';
use Store::CouchDB;

# ABSTRACT: CouchDB Storage provider
#
# Version

=head1 ATTRIBUTES

=head2 couch_host

=cut

has 'couch_host' => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => sub { 'localhost' },
);

=head2 couch_port

=cut

has 'couch_port' => (
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1,
    default => sub { 5984 },
);

=head2 couch_db

=cut

has 'couch_db' => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => sub { 'test' },
);

=head2 couch_user

=cut

has 'couch_user' => (
    is  => 'rw',
    isa => 'Str',
);

=head2 couch_pass

=cut

has 'couch_pass' => (
    is  => 'rw',
    isa => 'Str',
);

has 'couchdb' => (
    is  => 'rw',
    isa => 'Store::CouchDB',
    builder  => '_connect_couchdb',
);

sub _connect_couchdb {
    my $self = shift;

    my $couch = Store::CouchDB->new(
        host  => $self->couch_host,
        port  => $self->couch_port,
        debug => $self->debug ? 1 : 0,
    );
    $couch->db($self->couch_db) if ($self->couch_db);
    if ($self->couch_user && $self->couch_pass) {
        $couch->user($self->couch_user);
        $couch->pass($self->couch_pass);
    }
    return $couch;
}


1;
