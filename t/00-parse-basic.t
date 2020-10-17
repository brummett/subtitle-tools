use SubtitleParser;

use Test;

plan 6;

subtest 'basic parse', sub {
    plan 8;

    my $subs = q:to/END/;
        [Script Info]
        ; A comment
        Title: Foo
        Thing With Spaces: Bar

        [Section 2]
        !: another comment
        Baz: Quux
        END

    my $subtitles = SubtitleParser.parse_ssa($subs);
    ok $subtitles, 'Parsed';

    is $subtitles.sections.elems, 2, '2 sections';
    is $subtitles.sections[0].lines.elems, 3, 'First section line count';
    is $subtitles.sections[1].lines.elems, 2, 'Second section line count';

    ok $subtitles.section('Script Info'), 'Found "Script Info" section';
    ok $subtitles.section('Section 2'), 'Found "Section 2" section';
    ok ! $subtitles.section('foo'), 'No "foo" section';

    is $subtitles.Str, $subs, 'regenerate original';
};

subtest 'Duplicate section names' => sub {
    my %dups = 'Script Info' => q:to/DupScriptInfo/,
                    [Script Info]
                    Title: foo

                    [Section 2]
                    Foo: bar

                    [Script Info]
                    Baz: quux
                    DupScriptInfo
                'Section 2' => q:to/DupGenericSection/,
                    [Script Info]
                    Title: foo

                    [Section 2]
                    Foo: bar

                    [Section 2]
                    Baz: quux
                    DupGenericSection
                ;
    plan %dups.values.elems;
    for %dups.kv -> $section-name, $subs {
        throws-like { SubtitleParser.parse_ssa($subs) },
                    Exception,
                    :message("Duplicate section: $section-name"),
                    "Duplicate section $section-name";
    }
};

subtest 'styles' => sub {
    plan 3;

    my $subs = q:to/END/;
        [Script Info]
        Title: foo

        [V4+ Styles]
        Format: Name, Fontname, Fontsize, PrimaryColour, Bold, Angle
        Style: BoldStyle, BoldFont, 100, BoldColor, 1, 90
        Style: Default, DefaultFont, 10, DefaultColor, 0, 180

        END

    my $subtitles = SubtitleParser.parse_ssa($subs);
    ok $subtitles, 'Parsed';
    is $subtitles.styles.elems, 2, 'Number of styles';
    is $subtitles.section('V4+ Styles').lines.elems, 3, 'Number of lines in style section';
}

subtest 'events' => sub {
    plan 3;

    my $subs = q:to/END/;
        [Script Info]
        Title: foo

        [Events]
        Format: Layer, Start, End, Name, Text
        Comment: 0, 0:01:02,1:04:05, Bob, Hi There
        Dialogue: 10,0:03:03, 5:02:99, Joe, Hello World
        END

    my $subtitles = SubtitleParser.parse_ssa($subs);
    ok $subtitles, 'Parsed';
    is $subtitles.events.elems, 2, 'Number of events';
    is $subtitles.section('Events').lines.elems, 3, 'Number of lines in the Events section';
};

subtest 'empty lines' => sub {
    my $subs = q:to/END/;
        [Script Info]
        Title: foo

        Author: me

        [V4+ Styles]
        Format: Name, Fontname

        Style: BoldStyle, BoldFont

        Style: Default, DefaultFont


        [Section 2]
        Line2: 2

        Line4: 4

        [Events]
        Format: Layer, Name, Text

        Comment: 0, Bob, Hi there

        Dialogue: 1, Joe, Hello World

        END
    my $subtitles = SubtitleParser.parse_ssa($subs);
    ok $subtitles, 'Parsed';

    my %expected-lines = 'Script Info' => 2,
                         'V4+ Styles'  => 3,
                         'Section 2'   => 2,
                         'Events'      => 3,
                        ;

    is $subtitles.sections.elems, %expected-lines.keys.elems, 'Expected number of sections';
    for %expected-lines.kv -> $section-name, $expected-lines {
        is $subtitles.section($section-name).lines.elems, $expected-lines, "Expected lines for $section-name";
    }
    done-testing;
};

subtest 'enforce field cound' => sub {
    my @subs = qq:to/StyleTooManyFields/,
                    [V4+ Styles]
                    Format: One, Two, Three
                    Style: One, Two, Three, Four
                    StyleTooManyFields
                qq:to/StyleTooFewFields/,
                    [V4+ Styles]
                    Format: One, Two, Three
                    Style: One, Two
                    StyleTooFewFields
                qq:to/EventTooFewFields/,
                    [Events]
                    Format: One, Two, Three
                    Dialogue: One, Two
                    Comment: Fee, Foe, Fie
                    EventTooFewFields
            ;
    plan @subs.elems;
    for @subs.kv -> $i, $sub {
        throws-like { SubtitleParser.parse_ssa($sub) },
                    Exception,
                    :message(/'Expected ' \d ' fields but got ' \d ' at'/),
                    "Wrong number of fields $i";
    }
};
