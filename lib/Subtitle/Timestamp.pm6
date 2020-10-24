class Subtitle::Timestamp is Cool {
    has Int $.hour;
    has Int $.minute;
    has Int $.second;

    method Numeric { (($!hour * 60) + $!minute) * 60 + $!second }
    method Str { sprintf '%d:%02d:%02d', $!hour, $!minute, $!second }
}
    
