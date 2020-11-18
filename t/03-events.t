use SubtitleParser;

use Test;

my $subs = q:to/END/;
    [Script Info]
    Title: foo

    [Events]
    Format: Layer,Name,Text
    Comment: 0,Bob,Hello there
    Dialogue: 10,Joe,Nice to meet you, too
    Dialogue: 10,,{\i1}Still{\i0}, there is more\Nto see
    Dialogue: 10,Foo,
    END

my $subtitles = SubtitleParser.parse_ssa($subs);
ok $subtitles, 'Parsed';

my @expected-events =
                Comment => {Layer => 0,
                            Name  => 'Bob',    
                            Text  => 'Hello there',
                            Foo   => Nil,
                          },
                Dialogue =>{Layer => 10,
                            Name  => 'Joe',
                            Text  => 'Nice to meet you, too',
                            Bar   => Nil,
                          },
                Dialogue =>{Layer => 10,
                            Name  => '',
                            Text  => '{\i1}Still{\i0}, there is more\Nto see',
                          },
                Dialogue =>{Layer => 10,
                            Name  => 'Foo',
                            Text  => ''
                          },
                ;
is $subtitles.events.elems, @expected-events.elems, 'Number of events';

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

done-testing;
