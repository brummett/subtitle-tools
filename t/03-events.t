use SubtitleParser;

use Test;

plan 5;

my $subs = q:to/END/;
    [Script Info]
    Title: foo

    [Events]
    Format: Layer, Name, Text
    Comment: 0, Bob, Hello there
    Dialogue: 10, Joe, Nice to meet you
    END

my $subtitles = SubtitleParser.parse_ssa($subs);
ok $subtitles, 'Parsed';
is $subtitles.events.elems, 2, 'Number of events';

my @expected-events =
                Comment => {Layer => 0,
                            Name  => 'Bob',    
                            Text  => 'Hello there',
                            Foo   => Nil,
                          },
                Dialogue =>{Layer => 10,
                            Name  => 'Joe',
                            Text  => 'Nice to meet you',
                            Bar   => Nil,
                          },
                ;

for @expected-events.kv -> $i, (:key($type), :value($attribs)) {
    subtest "event $i" => sub {
        plan $attribs.values.elems + 1;

        is $subtitles.events[$i].key, $type, "event $i type";
        for $attribs.kv -> $key, $value {
            cmp-ok $subtitles.events[$i].get($key), '~~', $value, "value for $key";
        }
    }
}

is $subtitles.Str, $subs, 'Regenerate original';
