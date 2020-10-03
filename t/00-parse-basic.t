use SubtitleParser;

use Test;

plan 1;

subtest 'basic parse', sub {
    plan 4;

    my $subs = q:to/END/;
        [Script Info]
        Title: Foo
        Thing With Spaces: Bar

        [Section 2]
        Baz: Quux
        END

    my $subtitles = SubtitleParser.parse_ssa($subs);
    ok $subtitles, 'Parsed';

    is $subtitles.sections.elems, 2, '2 sections';
    is $subtitles.sections[0].lines.elems, 2, 'First section has 2 lines';
    is $subtitles.sections[1].lines.elems, 1, 'Second section has 1 line';
};


