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
    $robot->brain->cb_save(
        sub {
            my $data = shift;
            for my $key (keys %{ $data->{users} }) {
                unbless $data->{users}{$key};
            }

            my $json = encode_json($data);
            $redis->set('hubot:storage', $json);
        }
    );
    $robot->brain->cb_close( sub { $redis->quit } );
}

1;

=head1 SYNOPSIS

None

=head1 AUTHOR

Hyungsuk Hong <hshong@perl.kr>

=cut
