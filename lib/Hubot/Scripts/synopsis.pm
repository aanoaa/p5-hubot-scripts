package Hubot::Scripts::synopsis;
use strict;
use warnings;
use Encode qw/decode_utf8/;

sub load {
    my ($class, $robot) = @_;
    $robot->respond(
        qr/([A-Z](?:[a-zA-Z]+(?:::)?)+)/,
        sub {
            my $msg    = shift;
            my $module = $msg->match->[0];

            $msg->http("https://metacpan.org/module/$module")->get(
                sub {
                    my ($body, $hdr) = @_;

                    return if $hdr->{Status} !~ /^2/;

                    my $decoded_content = decode_utf8($body);
                    my ($SYNOPSIS) =
                      $decoded_content =~ m{<h1 id="SYNOPSIS">SYNOPSIS</h1>((?!<h1).+?)<h1}s;

                    return unless $SYNOPSIS;

                    $SYNOPSIS =~ s{<pre[^>]+>}{};
                    $SYNOPSIS =~ s{</pre>}{};
                    $SYNOPSIS =~ s{^ *\n$}{}m;
                    $SYNOPSIS =~ s{(\s+$)}{}s;

                    my @SYNOPSIS = split /\n/, $SYNOPSIS;
                    $msg->send(splice @SYNOPSIS, 0, 8);
                }
            );
        }
    );
}

1;

=head1 NAME

Hubot::Scripts::synopsis

=head1 SYNOPSIS

    hubot <CPAN::Module> - print a part of SYNOPSIS of <CPAN::Module>

=head1 AUTHOR

Hyungsuk Hong <hshong@perl.kr>

=cut
