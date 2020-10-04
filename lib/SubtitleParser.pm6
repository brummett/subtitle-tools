unit class SubtitleParser;

use Subtitle::SubStationAlphaV4Plus;
use SubtitleParser::SubStationAlphaV4Plus::Grammar;
use SubtitleParser::SubStationAlphaV4Plus::Actions;

method parse_ssa(Str:D $content --> Subtitle::SubStationAlphaV4Plus) {

    my $parsed = SubtitleParser::SubStationAlphaV4Plus::Grammar.parse($content, actions => SubtitleParser::SubStationAlphaV4Plus::Actions);
    die "Didn't parse" unless $parsed;

    return $parsed.made;
}
