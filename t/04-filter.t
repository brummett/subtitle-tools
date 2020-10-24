use Subtitle::Filter;
use Subtitle::Filter::Grammar;
use Subtitle::Filter::ConstructFilter;

use Test;

plan 1;

subtest 'parse' => sub {
    my @tests = (
        q<1 = 1>,
        q<1= 2>,
        q<field ="str">,
        q<"multi word str" = field>,
        q<1 = 'str'>,
        q<'multi q str'=field>,
    );
    plan @tests.elems;

    for @tests -> $t {
        my Subtitle::Filter $f = Subtitle::Filter::Grammar.parse($t, actions => Subtitle::Filter::ConstructFilter).made;
        ok($f, "Parsed: $t");
    }
}
