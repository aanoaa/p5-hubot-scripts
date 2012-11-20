package Hubot::Scripts::blacklist;
use strict;
use warnings;
use Try::Tiny;

sub load {
    my ( $class, $robot ) = @_;
    $robot->brain->{data}{blacklist}{subscriber} = {};
    $robot->brain->{data}{blacklist}{patterns} = [];
    $robot->respond(
        qr/blacklist add (.*)$/i,
        sub {
            my $msg = shift;
            my $pattern = $msg->match->[0];
            try {
                qr/$pattern/ and push @{ $robot->brain->{data}{blacklist}{patterns} }, $pattern;
                $msg->send("OK, added <$pattern> to blacklist");
            } catch {
                $msg->send("Failed to add <$pattern> to blacklist: $_");
            };
        }
    );

    $robot->respond(
        qr/blacklist$/i,
        sub {
            my $msg = shift;
            my $match = $msg->match->[0];
            my @list = @{ $robot->brain->{data}{blacklist}{patterns} };
            if (@list) {
                my $index = 0;
                map {
                    s/^/\# [$index] /;
                    $index++;
                } @list;
                $msg->send(@list);
            } else {
                $msg->send('no blacklist');
            }
        }
    );

    $robot->respond(
        qr/blacklist del(?:ete)? (\d+)$/i,
        sub {
            my $msg = shift;
            my $index = $msg->match->[0];
            my @list = @{ $robot->brain->{data}{blacklist}{patterns} };
            if ($index > @list - 1) {
                $msg->send("Can't delete [$index] from blacklist");
            } else {
                my $pattern = splice @list, $index, 1;
                $msg->send("Deleted [$index] - <$pattern> from blacklist");
                $robot->brain->{data}{blacklist}{patterns} = \@list;
            }
        }
    );

    $robot->respond(
        qr/blacklist subscribe$/i,
        sub {
            my $msg = shift;
            my $name = $msg->message->user->{name};
            $robot->brain->{data}{blacklist}{subscriber}{$name}++;
            $msg->send("OK, $name subscribes blacklist");
        }
    );

    $robot->respond(
        qr/blacklist unsubscribe$/i,
        sub {
            my $msg = shift;
            my $name = $msg->message->user->{name};
            delete $robot->brain->{data}{blacklist}{subscriber}{$name};
            $msg->send("OK, $name unsubscribes blacklist");
        }
    );

    $robot->enter(
        sub {
            my $msg = shift;
            my $user = $msg->message->user->{name};
            ## support IRC adapter only
            if ('Hubot::Adapter::Irc' eq ref $robot->adapter) {
                my $whois = $robot->adapter->whois($user);
                for my $pattern (@{ $robot->brain->{data}{blacklist}{patterns} }) {
                    my $regex = qr/$pattern/;
                    if ($whois =~ m/$regex/) {
                        my @subscriber = keys %{ $robot->brain->{data}{blacklist}{subscriber} };
                        notify($robot, $msg, $pattern, @subscriber);
                        last;
                    }
                }
            }
        }
    );
}

sub notify {
    my ($robot, $res, $patt, @subs) = @_;
    for my $sub (@subs) {
        my $to = $robot->userForName($sub);
        $res->whisper($to, "blacklist[$patt] joined channel");
    }
}

1;

=head1 NAME

Hubot::Scripts::blacklist

=head1 SYNOPSIS

    hubot blacklist - show blacklist
    hubot blacklist add <pattern> - add pattern to blacklist
    hubot blacklist del <index> - delete pattern at blacklist[index]
    hubot blacklist subscribe - robot will tell you when blacklist enter a room
    hubot blacklist unsubscribe - robot will not tell you when blacklist enter a room anymore

=head1 AUTHOR

Hyungsuk Hong <hshong@perl.kr>

=cut
