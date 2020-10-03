unit class SubtitleParser::SubStationAlphaV4Plus::Actions;

use Subtitle::SubStationAlphaV4Plus;
use Subtitle::SubStationAlphaV4Plus::Section;
use Subtitle::SubStationAlphaV4Plus::SectionLine;

method TOP($/) {
    my @sections = $<section>>>.made;

    make Subtitle::SubStationAlphaV4Plus.new(:@sections);
}

method section($/) {
    my $name = $<section-name>.Str;
    my @lines = @<section-line>>>.made;


    make Subtitle::SubStationAlphaV4Plus::Section.new(:$name, :@lines);
}

method section-line($/) {
    my $key = $<key>.Str;
    my $value = $<value>.Str;
    make Subtitle::SubStationAlphaV4Plus::SectionLine.new(:$key, :$value);
}

