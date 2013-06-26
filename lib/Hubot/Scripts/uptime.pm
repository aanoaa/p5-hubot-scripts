package Hubot::Scripts::uptime;
use strict;
use warnings;
use Storable;
use DateTime;
use DateTime::Format::Duration;

sub load {
    my ( $class, $robot ) = @_;
    my $start = DateTime->now;
    $robot->respond(
        qr/uptime/i,
        sub {
            my $msg = shift;
            my $ymd = $start->ymd('/');
            my $hms = $start->hms;
            my @ymdhms = "$ymd-$hms";
            if ( -f 'ymdhms.dat' ) {
                my $started_time = retrieve('ymdhms.dat');
                my $die_during_time = $started_time->[0];
                $msg->send('Hubot die time ' . $started_time->[0]);
                $msg->send('Hubot start time ' . "@ymdhms");
                uptimeMe( $msg, $start, sub { $msg->send(shift) } );
            }
            store \@ymdhms, 'ymdhms.dat';
        }
    );
}

sub uptimeMe {
    my ( $msg, $start, $cb ) = @_;
    my $now      = DateTime->now;
    my $duration = $now - $start;
    my $d =
      DateTime::Format::Duration->new(
        pattern => '%Y years, %m months, %e days, '
          . '%H hours, %M minutes, %S seconds' );
    $d->set_normalizing(1);
    $cb->( "I've been sentient for " . $d->format_duration($duration) );
}

sub stop_during_time {
        
}

1;

=head1 NAME

Hubot::Scripts::uptime

=head1 SYNOPSIS

  hubot uptime - display robot's uptime

=head1 AUTHOR

Hyungsuk Hong <hshong@perl.kr>

=cut
