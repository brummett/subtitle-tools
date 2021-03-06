unit class Subtitle::SubStationAlphaV4Plus::Section;

use Subtitle::SubStationAlphaV4Plus::SectionLine;

has Str $.name;
has Subtitle::SubStationAlphaV4Plus::KeyValue @.lines;

method Str { "[$.name]\n" ~ @.lines.join() }

method format {
    @!lines.grep({ $_ ~~ Subtitle::SubStationAlphaV4Plus::Format})
}
