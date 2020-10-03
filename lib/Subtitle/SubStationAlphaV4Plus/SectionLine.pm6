role Subtitle::SubStationAlphaV4Plus::SectionLine {
    has Str $.value;
}

class Subtitle::SubStationAlphaV4Plus::Comment does Subtitle::SubStationAlphaV4Plus::SectionLine { }

class Subtitle::SubStationAlphaV4Plus::KeyValue does Subtitle::SubStationAlphaV4Plus::SectionLine
{
    has Str $.key;
}

