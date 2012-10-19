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
        }
    );
}

1;

=head1 NAME

Hubot::Scripts::ping

=head1 SYNOPSIS

    hubot ping - bot will pong me
    hubot die - shutdown robot

=head1 AUTHOR

Hyungsuk Hong <hshong@perl.kr>

=cut
