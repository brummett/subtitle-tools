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
    has Cool @.values;
    method value { @!values.join(',') }
    method Str { "$.key: { self.value }\n" }
}

class Subtitle::SubStationAlphaV4Plus::Format
    is Subtitle::SubStationAlphaV4Plus::Multivalue
{
    has $.key = 'Format';
    method value { @.values.join(', ') }
}

class Subtitle::SubStationAlphaV4Plus::HashValue
    is Subtitle::SubStationAlphaV4Plus::Multivalue
{
    has @.fields;
    has %!fields;
    submethod BUILD(:@!fields) {
        for @!fields.kv -> $i, $name {
            %!fields{$name} = $i;
        }
    }

    method get(Str $field --> Cool) {
        my $idx = %!fields{$field};
        defined($idx) ?? @.values[ %!fields{$field} ] !! Nil;
    }
}

class Subtitle::SubStationAlphaV4Plus::Style
    is Subtitle::SubStationAlphaV4Plus::HashValue
{
    has $.key = 'Style';
}

class Subtitle::SubStationAlphaV4Plus::Event
    is Subtitle::SubStationAlphaV4Plus::HashValue
{ }
