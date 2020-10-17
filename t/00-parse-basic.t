use SubtitleParser;

use Test;

plan 3;

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
