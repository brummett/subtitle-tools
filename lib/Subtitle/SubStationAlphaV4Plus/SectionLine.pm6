class Subtitle::SubStationAlphaV4Plus::KeyValue {
    has Str $.key;
    has Str $.value;

    method Str { "$!key: $!value\n" }
}

class Subtitle::SubStationAlphaV4Plus::Comment
    is Subtitle::SubStationAlphaV4Plus::KeyValue
{
    has Str $.key is required where * eq any(';', '!:');
    method Str { "$!key $.value\n" }
}

class Subtitle::SubStationAlphaV4Plus::Multivalue
    is Subtitle::SubStationAlphaV4Plus::KeyValue
{
    has Str @.values;
    method value { @!values.join(', ') }
    method Str { "$.key: { self.value }\n" }
}

class Subtitle::SubStationAlphaV4Plus::Format
    is Subtitle::SubStationAlphaV4Plus::Multivalue
{
    has $.key = 'Format';
}
