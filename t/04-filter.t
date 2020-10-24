use Subtitle::Filter;
use Subtitle::Filter::Grammar;
use Subtitle::Filter::ConstructFilter;
use SubtitleParser;

use Test;

plan 4;

subtest 'parse' => sub {
    my @tests = (
        q<1 = 1>,
        q<1= 2>,
        q<field ="str">,
        q<"multi word str" = field>,
        q<1 = 'str'>,
        q<'multi q str'=field>,
    );
    plan @tests.elems;

    for @tests -> $t {
        my Subtitle::Filter $f = Subtitle::Filter::Grammar.parse($t, actions => Subtitle::Filter::ConstructFilter).made;
        ok($f, "Parsed: $t");
    }
}

subtest 'basic filter' => sub {
    # We'll use "Layer" as an identifier for the lines
    my $subs = q:to/END/;
        [Foo]
        Foo: Bar

        [Events]
        Format: Layer, Name, Text
        Dialogue: 1, First, Line 1
        Dialogue: 2, Second, Line 2
        Dialogue: 3, Third, Entry number three
        END

    # Filters, and which "Layer" lines match
    my @filters =
        '1=1'               => ( '1', '2', '3'),
        'Layer=2'           => List.new( '2' ),
        'Name="bogus"'      => ( ),
        'Text != "Line 2"'  => ( '1', '3' ),
        'Text like "Line"'  => ( '1', '2' ),
        'Layer<3'       => ( '1', '2' ),
        'Layer lt 3'    => ( '1', '2' ),
        'Layer > 1'     => ( '2', '3' ),
        'Layer gt 1'    => ( '2', '3' ),
        'Layer<=2'      => ( '1', '2' ),
        'Layer le 2'    => ( '1', '2' ),
        'Layer >= 2'    => ( '2', '3' ),
        'Layer ge 2'    => ( '2', '3' ),
        ;

    plan 1 + @filters.elems;

    my $s = SubtitleParser.parse_ssa($subs);
    ok($s, 'Parsed subtitles');

    for @filters -> (:key($filter), :value($expected_lines)) {
        subtest $filter => sub {
            plan 3;

            my $f = Subtitle::Filter::Grammar.parse($filter, actions => Subtitle::Filter::ConstructFilter).made;
            ok $f, 'create filter';
            my $filtered_subs = $f.evaluate($s);
            ok $filtered_subs.section('Foo') && $filtered_subs.section('Events'),
                'Result has both sections';
            is-deeply $filtered_subs.events>>.get('Layer'),
                $expected_lines,
                'Returned expected events';
        };
    }
}

subtest 'filter on bogus field' => sub {
    plan 3;
    my $subs = q:to/END/;
        [Events]
        Format: Layer, Name, Text
        Dialogue: 1, First, Line 1
        Dialogue: 2, Second, Line 2
        Dialogue: 3, Third, Entry number three
        END
    my $s = SubtitleParser.parse_ssa($subs);
    ok $s, 'Parse subtitles';

    my $filter = Subtitle::Filter::Grammar.parse('bogus="foo"', actions => Subtitle::Filter::ConstructFilter).made;
    ok $filter, 'Create filter';

    throws-like { $filter.evaluate($s) },
            Exception,
            message => qq<Unknown field "bogus">,
            'Filtering on unknown field throws exception';
}

subtest 'filter by time' => sub {
    my $subs = q:to/END/;
        [Events]
        Format: Layer, Start, End, Text
        Dialogue: 1, 0:00:01, 0:00:02, First
        Dialogue: 2, 0:01:01, 0:02:02, Second overlaps third
        Dialogue: 3, 0:01:31, 0:03:02, Third overlaps second
        END
    my $s = SubtitleParser.parse_ssa($subs);

    my @tests =
        'Start < 0:01:00'   => List.new('1'),
        'Start < 0:01:30'   => ( '1', '2' ),
        'End > 0:02:00'     => ( '2', '3' ),
        'at 0:01:00'        => ( ),
        'at 0:01:10'        => List.new('2'),
        'at 0:02:00'        => ( '2', '3' ),
        ;

    plan @tests.elems;

    for @tests -> (:key($test), :value($expected_lines) ) {
        subtest $test => sub {
            plan 2;

            my $f = Subtitle::Filter::Grammar.parse($test, actions => Subtitle::Filter::ConstructFilter).made;
            ok $f, 'Parse';
            my $filtered_subs = $f.evaluate($s);
            is-deeply $filtered_subs.events>>.get('Layer'),
                $expected_lines,
                'Returned expected events';
        };
    }
}
