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

method section-line:sym<comment>($/) {
    my $marker = $<comment-token>.Str;
    my $value = $<value>.Str;
    make Subtitle::SubStationAlphaV4Plus::Comment.new(:$marker, :$value);
}

method section-line:sym<key-value>($/) {
    my $key = $<key>.Str;
    my $value = $<value>.Str;
    make Subtitle::SubStationAlphaV4Plus::KeyValue.new(:$key, :$value);
}

