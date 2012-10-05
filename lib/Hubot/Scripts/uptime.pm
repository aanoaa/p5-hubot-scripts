package Hubot::Scripts::uptime;
use strict;
use warnings;
use DateTime;
use DateTime::Format::Duration;

sub load {
    my ( $class, $robot ) = @_;
    my $start = DateTime->now;
    $robot->respond(
        qr/uptime/i,
        sub {
            my $msg = shift;
            uptimeMe($msg, $start, sub { $msg->send(shift) } );
        }
    );
}

sub uptimeMe {
    my ($msg, $start, $cb) = @_;
    my $now = DateTime->now;
    my $duration = $now - $start;
    my $d = DateTime::Format::Duration->new(
        pattern => '%Y years, %m months, %e days, '.
            '%H hours, %M minutes, %S seconds'
        );
    $cb->("I've been sentient for " . $d->format_duration($duration));
}

1;

=head1 SYNOPSIS

  hubot: uptime

=cut
