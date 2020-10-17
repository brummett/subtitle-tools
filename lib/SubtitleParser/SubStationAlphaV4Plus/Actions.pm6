unit class SubtitleParser::SubStationAlphaV4Plus::Actions;

use Subtitle::SubStationAlphaV4Plus;
use Subtitle::SubStationAlphaV4Plus::Section;
use Subtitle::SubStationAlphaV4Plus::SectionLine;

method TOP($/) {
    my @sections = $<section>>>.made;

    make Subtitle::SubStationAlphaV4Plus.new(:@sections);
}


method section:sym<style>($/) {
    my $format = $<format>.made;
    my @styles = @<style>>>.made;
    make Subtitle::SubStationAlphaV4Plus::Section.new(name => 'V4+ Styles', lines => ($format, |@styles));
}

method section:sym<event>($/) {
    my $format = $<format>.made;
    my @events = @<event>>>.made;
    make Subtitle::SubStationAlphaV4Plus::Section.new(name => 'Events', lines => ($format, |@events));
}

method section:sym<generic>($/) {
    my $name = $<section-name>.Str;
    my @lines = @<section-line>>>.made;

    make Subtitle::SubStationAlphaV4Plus::Section.new(:$name, :@lines);
}

method format($/) {
    my @fields = @<field>>>.Str;
    make Subtitle::SubStationAlphaV4Plus::Format.new(name => 'Format', values => @fields);
}

method style($/) {
    make Subtitle::SubStationAlphaV4Plus::Style.new(fields => @*fields, values => @<field>>>.Str);
}

method event($/) {
    my $type = $<event-type>.Str;
    make Subtitle::SubStationAlphaV4Plus::Event.new(key => $type, fields => @*fields, values => @<field>>>.Str);
}

method section-line:sym<comment>($/) {
    my $key = $<comment-token>.Str;
    my $value = $<value>.Str;
    make Subtitle::SubStationAlphaV4Plus::Comment.new(:$key, :$value);
}

method section-line:sym<key-value>($/) {
    my $key = $<key>.Str;
    my $value = $<value>.Str;
    make Subtitle::SubStationAlphaV4Plus::KeyValue.new(:$key, :$value);
}

