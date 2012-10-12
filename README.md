## p5-hubot-scripts ##

### Installing ###

    $ cpanm Hubot::Scripts::<script>    # not working yet, no Hubot modules in CPAN

add `"<script>"` to `hubot-scripts.json`

### run for test? ###

    $ git clone git://github.com/aanoaa/p5-hubot-scripts.git
    $ cd p5-hubot-scripts/
    $ cpanm --installdeps .    # fail? add `--no-test` option and again
    $ cd lib/
    $ export PERL5LIB=`pwd`
    $ cd /path/to/p5-hubot/
    # edit `hubot-scripts.json`
    $ perl -Ilib bin/hubot

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
