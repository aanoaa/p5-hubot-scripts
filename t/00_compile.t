use strict;
use Test::More tests => 13;

BEGIN { use_ok 'Hubot::Scripts::Bundle' }
BEGIN { use_ok 'Hubot::Scripts::ping' }
BEGIN { use_ok 'Hubot::Scripts::redisBrain' }
BEGIN { use_ok 'Hubot::Scripts::uptime' }
BEGIN { use_ok 'Hubot::Scripts::eval' }
BEGIN { use_ok 'Hubot::Scripts::tell' }
BEGIN { use_ok 'Hubot::Scripts::bugzilla' }
BEGIN { use_ok 'Hubot::Scripts::googleImage' }
BEGIN { use_ok 'Hubot::Scripts::macboogi' }
BEGIN { use_ok 'Hubot::Scripts::blacklist' }
BEGIN { use_ok 'Hubot::Scripts::backup' }
BEGIN { use_ok 'Hubot::Scripts::op' }
BEGIN { use_ok 'Hubot::Scripts::storable' }
