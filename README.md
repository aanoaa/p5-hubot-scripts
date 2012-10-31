## p5-hubot-scripts ##

### Installation ###

    $ cpanm Hubot::Scripts::Bundle

### Documentation ###

just write a `pod` in source code

```perl
=head1 SYNOPSIS

  hubot: usage here

=head1 DESCRIPTION

  this is blablabla

=head1 CONFIGURATION

=over

=item ENV_VARS_TO_SET1

=item ENV_VARS_TO_SET2

=back

=head1 AUTHOR

Hyungsuk Hong <hshong@perl.kr>

=cut
```

`cpan` or `cpanm` command will help dependency problem at install time

### Make your own script for Dist::Zilla user ###

make sure copy `misc/dzil/profiles/hubot` directory to `$HOME/.dzil/profiles`

```bash
$ dzil new -p hubot Hubot::Script::awesome
```

### How test your script ###

- use `Shell` adapter
- add `script` to `hubot-scripts.json`
- make sure Perl knows your `p5-hubot-scripts/lib` path

    $ cd /path/to/p5-hubot-scripts/
    $ export PERL5LIB=./lib
    $ hubot
