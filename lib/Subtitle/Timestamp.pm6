class Subtitle::Timestamp is Cool {
    has Int $.hour;
    has Int $.minute;
    has Int $.second;
    has Int $.ms = 0;

    method Numeric { (($!hour * 60) + $!minute) * 60 + $!second + ($!ms * 0.01 ) }
    method Str { sprintf '%d:%02d:%02d.%02d', $!hour, $!minute, $!second, $!ms }
}
    
