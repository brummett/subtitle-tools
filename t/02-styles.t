use SubtitleParser;

use Test;

plan 5;

my $subs = q:to/END/;
    [Script Info]
    Title: foo

    [V4+ Styles]
    Format: Name,Fontname,Fontsize,PrimaryColour,Bold,Angle
    Style: BoldStyle,BoldFont,100,BoldColor,1,90
    Style: Default,DefaultFont,10,DefaultColor,0,180
    END

my $subtitles = SubtitleParser.parse_ssa($subs);
ok $subtitles, 'Parsed';
is $subtitles.styles.elems, 2, 'Number of styles';

my %expected-styles =
                'BoldStyle' => {'Name'          => 'BoldStyle',
                                'Fontname'      => 'BoldFont',
                                'Fontsize'      =>  100,
                                'PrimaryColour' =>  'BoldColor',
                                'Bold'          => 1,
                                'Angle'         => 90,
                                'Foo'           => Nil,
                              },
                'Default' => {  'Name'          => 'Default',
                                'Fontname'      => 'DefaultFont',
                                'Fontsize'      =>  10,
                                'PrimaryColour' =>  'DefaultColor',
                                'Bold'          => 0,
                                'Angle'         => 180,
                                'Foo'           => Nil,
                              },
                    ;

for %expected-styles.kv -> $style-name, $expected {
    subtest "$style-name style", sub {
        plan $expected.values.elems;

        for $expected.kv -> $key, $value {
            cmp-ok $subtitles.style($style-name).get($key), '~~', $value, "value for $key";
        }
    }
}

is $subtitles.Str, $subs, 'Regenerate original';
