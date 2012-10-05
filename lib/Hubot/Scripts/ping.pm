package Hubot::Scripts::ping;
use strict;
use warnings;

sub load {
    my ( $class, $robot ) = @_;
    $robot->respond( qr/ping$/i, sub { shift->reply('PONG') } );
    $robot->respond(
        qr/die$/i,
        sub {
            shift->send('Goodbye, cruel world.');
            $robot->shutdown;
            exit;
        }
    );
}

1;

=head1 SYNOPSIS

  hubot: ping

=cut
