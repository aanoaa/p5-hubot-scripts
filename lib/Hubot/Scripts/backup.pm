package Hubot::Scripts::backup;
use strict;
use warnings;
use AnyEvent;

my $w;    # consider *WATCHER* lifetime

sub load {
    my ( $class, $robot ) = @_;

    $w = AnyEvent->timer(
        after    => 0,
        interval => $ENV{HUBOT_BACKUP_INTERVAL} || 60 * 60,
        cb       => sub { $robot->brain->save }
    );
}

1;

=head1 NAME

Hubot::Scripts::backup

=head1 SYNOPSIS

    backup - save robot's brain data to external storage automatically if used; this is *NOT COMMAND* like others; just work

=head1 CONFIGURATION

=over

=item * HUBOT_BACKUP_INTERVAL

C<3600>(1 hour) is default to use.

=back

=head1 SEE ALSO

=over

=item * L<Hubot::Scripts::redisBrain>

=back

=head1 AUTHOR

Hyungsuk Hong <hshong@perl.kr>

=cut
