unit class Subtitle::SubStationAlphaV4Plus;

use Subtitle::SubStationAlphaV4Plus::Section;

has Subtitle::SubStationAlphaV4Plus::Section @.sections;

method Str { @.sections.join("\n") }

method section(Str $name) {
    for @.sections -> $section {
        return $section if $section.name eq $name;
    }
    fail "No section with name $name";
}
