package {{$name}};
{{
    use strict;
    use vars '$foo';
    $Text::Template::SILENTLY; # same as '';
}}
# ABSTRACT: {{$name}}
use strict;
use warnings;

sub load {
    my ( $class, $robot ) = @_;

    ## robot respond only called its name first. `hubot xxx`
    $robot->respond(
        qr/pattern (.*)?$/i, # (.*) will captured as `$msg->match->[0]`
        sub {
            my $msg  = shift;    # Hubot::Response
            $msg->send('hi');    # hubot> hi
            $msg->reply('hi');   # hubot> user: hi
        }
    );

    ## robot can hear anything
    $robot->hear(
        qr/^pattern (.*)?$/i,
        sub {
            my $msg  = shift;    # Hubot::Response
        }
    );
}

1;


=pod

=head1 NAME

{{$name}}

=head1 SYNOPSIS

    hubot <command> <args> - help message here

=head1 DESCRIPTION

need more description?

=head1 CONFIGURATION

=over

=item HUBOT_ENV_VARS_TO_SET

=back

=head1 AUTHOR

Your name <your@email.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by <Your Name>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
