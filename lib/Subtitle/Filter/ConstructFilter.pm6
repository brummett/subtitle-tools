unit class Subtitle::Filter::ConstructFilter;

use Subtitle::Filter;

method TOP($/) { make $<expression>.made }

method expression:sym<infix-operator>($/) {
    my $left  = $<left>.made;
    my $right = $<right>.made;
    my $op    = $<operator>.Str;

    my $op_class = do given $op {
        when '=' { Subtitle::Filter::Operator::Eq }
        when 'like' { Subtitle::Filter::Operator::Like }
        default { fail "Unknown operator $op" }
    };

    make $op_class.new(:$left, :$right);
}

method expr-simple:sym<identifier-or-value>($/) { make $<atom>.made }

method atom:sym<identifier>($/) { make Subtitle::Filter::AttributeLookup.new(field => $/.Str) }
method atom:sym<number>($/)     { make Subtitle::Filter::Constant.new(value => $/.Str) }
method atom:sym<string-qq>($/)  { make Subtitle::Filter::Constant.new(value => $<value>.Str) }
method atom:sym<string-q>($/)   { make Subtitle::Filter::Constant.new(value => $<value>.Str) }


