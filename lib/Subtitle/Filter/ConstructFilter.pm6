unit class Subtitle::Filter::ConstructFilter;

use Subtitle::Filter;
use Subtitle::Timestamp;

method TOP($/) { make $<expression>.made }

method expression:sym<infix-operator>($/) {
    my $left  = $<left>.made;
    my $right = $<right>.made;
    my $op    = $<operator>.Str;

    my $op_class = do given $op {
        when '='    { Subtitle::Filter::Operator::Eq }
        when '!='   { Subtitle::Filter::Operator::Ne }
        when 'lt'   { Subtitle::Filter::Operator::Lt }
        when '<'    { Subtitle::Filter::Operator::LtNumber }
        when 'le'   { Subtitle::Filter::Operator::Le }
        when '<='   { Subtitle::Filter::Operator::LeNumber }
        when 'gt'   { Subtitle::Filter::Operator::Gt }
        when '>'    { Subtitle::Filter::Operator::GtNumber }
        when 'ge'   { Subtitle::Filter::Operator::Ge }
        when '>='   { Subtitle::Filter::Operator::GeNumber }
        when 'like' { Subtitle::Filter::Operator::Like }
        default { fail "Unknown operator $op" }
    };

    make $op_class.new(:$left, :$right);
}

method expression:sym<at-operator>($/) {
    my Subtitle::Filter $timestamp = $<timestamp>.made;
    make Subtitle::Filter::Operator::At.new(:$timestamp);
}

method expr-simple:sym<identifier-or-value>($/) { make $<atom>.made }

method atom:sym<identifier>($/) { make Subtitle::Filter::AttributeLookup.new(field => $/.Str) }
method atom:sym<number>($/)     { make Subtitle::Filter::Constant.new(value => $/.Str) }
method atom:sym<string-qq>($/)  { make Subtitle::Filter::Constant.new(value => $<value>.Str) }
method atom:sym<string-q>($/)   { make Subtitle::Filter::Constant.new(value => $<value>.Str) }
method atom:sym<timestamp>($/)  {
    my $hour    = $<hour>.Int;
    my $minute  = $<minute>.Int;
    my $second  = $<second>.Int;
    my $timestamp = Subtitle::Timestamp.new(:$hour, :$minute, :$second);
    make Subtitle::Filter::Constant.new(value => $timestamp);
}

