use SubtitleParser;

use Test;

plan 1;

subtest 'basic parse', sub {
    plan 5;

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

    is $subtitles.Str, $subs, 'regenerate original';
};


