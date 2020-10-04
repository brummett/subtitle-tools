class Subtitle::SubStationAlphaV4Plus::KeyValue {
    has Str $.key is required;
    has Str $.value is required;

    method Str { "$!key: $!value" }
}

class Subtitle::SubStationAlphaV4Plus::Comment
    is Subtitle::SubStationAlphaV4Plus::KeyValue
{
    has Str $.key is required where * eq any(';', '!:');
    method Str { "$!key $.value" }
}

