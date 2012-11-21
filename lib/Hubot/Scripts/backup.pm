package Hubot::Scripts::backup;
use strict;
use warnings;

sub load {
    my ( $class, $robot ) = @_;
    $robot->respond(
        qr/save$/i,
        sub {
            $robot->brain->save;
            shift->send('OK');
        }
    );
}

1;

=head1 NAME

Hubot::Scripts::backup

=head1 SYNOPSIS

    hubot save - save robot's brain data to external storage if used

=head1 AUTHOR

Hyungsuk Hong <hshong@perl.kr>

=cut
