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

method styles {
    self.section('V4+ Styles').lines.grep({ $_ ~~ Subtitle::SubStationAlphaV4Plus::Style });
}

method style(Str $name) {
    self.styles.grep({ $_.get('Name') eq $name })[0];
}

method events {
    self.section('Events').lines.grep({ $_~~ Subtitle::SubStationAlphaV4Plus::Event });
}
