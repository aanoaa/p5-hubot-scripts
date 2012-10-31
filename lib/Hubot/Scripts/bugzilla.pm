package Hubot::Scripts::bugzilla;
use utf8;
use strict;
use warnings;
use JSON::XS;

sub load {
    my $client = JSONRPC->new({ url => $ENV{HUBOT_BZ_JSONPRC_URL} });
    my %PRIORITY_MAP = (
        '---'   => '☆☆☆☆☆',
        Lowest  => '★☆☆☆☆',
        Low     => '★★☆☆☆',
        Normal  => '★★★☆☆',
        High    => '★★★★☆',
        Highest => '★★★★★',
    );

    my ( $class, $robot ) = @_;
    $robot->hear(
        qr/^bug ([0-9a-z-A-Z]+)/i,
        sub {
            my $msg = shift;
            $client->call(
                'Bug.get',
                { ids => [$msg->match->[0]] },
                sub {
                    my ($body, $hdr) = @_;
                    my $data = decode_json($body);
                    my $bug = @{ $data->{result}{bugs} ||= [] }[0];
                    $msg->send(sprintf "#%s %s - [%s, %s, %s]", $bug->{id}, $bug->{summary}, $bug->{status}, $bug->{assigned_to}, $PRIORITY_MAP{$bug->{priority}}) if $bug;
                }
            );
        }
    );
}

package JSONRPC;
use strict;
use warnings;
use AnyEvent::HTTP::ScopedClient;
use JSON::XS;
use Data::Printer;

sub new {
    my ($class, $ref) = @_;
    $ref->{http} = AnyEvent::HTTP::ScopedClient->new($ref->{url});
    $ref->{username} ||= $ENV{HUBOT_BZ_USERNAME};
    $ref->{password} ||= $ENV{HUBOT_BZ_PASSWORD};
    my $self = bless $ref, $class;
    $self->login;
    return $self;
}

sub call {
    my ($self, $method, $params, $cb) = @_;
    $params = encode_json({ method => $method, params => $params, version => '1.1' });
    $self->{http}->header({
        cookie => $self->{cookie} || '',
        Accept => 'application/json',
        'Content-Type' => 'application/json',
        'User-Agent' => 'p5-hubot-bugzilla-script-jsonrpc-client',
    })->post(
        $params,
        sub {
            my ($body, $hdr) = @_;
            $cb->($body, $hdr) if $hdr->{Status} =~ m/^2/;
        }
    );
}

sub set_cookies {
    my ($self, $hdr) = @_;
    $self->{cookie} = $hdr->{'set-cookie'};
}

sub login {
    my $self = shift;
    $self->call(
        'User.login',
        {
            login => $self->{username},
            password => $self->{password}
        }, sub {
            my ($body, $hdr) = @_;
            $self->set_cookies($hdr);
        }
    );
}

1;

=head1 NAME

Hubot::Scripts::bugzilla

=head1 SYNOPSIS

    bug (<bug id>|<keyword>) - retrun bug summary, status, assignee and priority if exist
    bug search <keyword>     - retrun bug summary, status, assignee and priority if exist
    bug <number> - show the bug title.

=head1 CONFIGURATION

=over

=item * HUBOT_BZ_JSONRPC_URL

=item * HUBOT_BZ_USERNAME

=item * HUBOT_BZ_PASSWORD

=back

=head1 AUTHOR

Hyungsuk Hong <hshong@perl.kr>

=cut
