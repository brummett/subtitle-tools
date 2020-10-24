use Subtitle::Filter;
use Subtitle::Filter::Grammar;
use Subtitle::Filter::ConstructFilter;
use SubtitleParser;

use Test;

plan 3;

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
    my %filters =
        '1=1'           => ( '1', '2', '3'),
        'Layer=2'       => List.new( '2' ),
        'Name="bogus"'    => ( ),
        ;

    plan 1 + %filters.elems;

    my $s = SubtitleParser.parse_ssa($subs);
    ok($s, 'Parsed subtitles');

    for %filters.kv -> $filter, $expected_lines {
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
