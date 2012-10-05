## p5-hubot-scripts ##

### Installing ###

    $ cpanm Hubot::Scripts::<script>    # not working yet, no Hubot modules in CPAN

add `"<script>` to `hubot-scripts.json`

### Documentation ###

just write a `pod` in source code

```pod
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
