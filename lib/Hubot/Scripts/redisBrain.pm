package Hubot::Scripts::redisBrain;
use strict;
use warnings;
use Redis;
use JSON::XS;
use Data::Structure::Util qw( unbless );

sub load {
    my ( $class, $robot ) = @_;
    my $redis = Redis->new(server => $ENV{REDIS_SERVER} || '127.0.0.1:6379');
    print "connected to redis-server\n" if $ENV{DEBUG};
    my $json = $redis->get('hubot:storage');
    $robot->brain->mergeData(decode_json($json));
    $robot->brain->on(
        'save',
        sub {
            my ($e, $data) = @_;
            for my $key (keys %{ $data->{users} }) {
                unbless $data->{users}{$key};
            }

            my $json = encode_json($data);
            $redis->set('hubot:storage', $json);
        }
    );
    $robot->brain->on( 'close', sub { $redis->quit } );
}

1;

=head1 SYNOPSIS

=head1 CONFIGURATION

=over

=item REDIS_SERVER

C<127.0.0.1:6379> is default to use.

=back

=head1 SEE ALSO

L<https://github.com/github/hubot-scripts/blob/master/src/scripts/redis-brain.coffee>

=head1 AUTHOR

Hyungsuk Hong <hshong@perl.kr>

=cut
