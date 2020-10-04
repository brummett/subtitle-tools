role Subtitle::SubStationAlphaV4Plus::SectionLine {
    has Str $.value;

    method Str { ... }
}

class Subtitle::SubStationAlphaV4Plus::Comment does Subtitle::SubStationAlphaV4Plus::SectionLine
{
    has Str $.marker = ';';

    method Str { "$.marker $.value" }
}

class Subtitle::SubStationAlphaV4Plus::KeyValue does Subtitle::SubStationAlphaV4Plus::SectionLine
{
    has Str $.key;

    method Str { "$.key: $.value" }
}

