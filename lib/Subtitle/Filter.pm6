use Subtitle::SubStationAlphaV4Plus;
use Subtitle::SubStationAlphaV4Plus::SectionLine;

class Subtitle::Filter {
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event) { ... }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus:D $subs) {
        my @passing_events = $subs.events.grep({ self.evaluate($_) });
        my $new_events_section = Subtitle::SubStationAlphaV4Plus::Section.new(name => 'Events', lines => @passing_events);
        my @sections = ( | ( $subs.sections.grep({ .name ne 'Events' })), $new_events_section );
        Subtitle::SubStationAlphaV4Plus.new(:@sections);
    }
}

class Subtitle::Filter::Constant is Subtitle::Filter {
    has Cool $.value;
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Cool) { $!value }
    method gist { qq<"$!value"> }
}

class Subtitle::Filter::AttributeLookup is Subtitle::Filter {
    has Str $.field;
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Cool) {
        my $value = $event.get($!field);
        die qq<Unknown field "$!field"> unless defined($value);
        $value;
    }
    method gist { qq<get($!field)> }
}

class Subtitle::Filter::Operator::At is Subtitle::Filter {
    has Subtitle::Filter $.timestamp;
    method gist { 'at ' ~ $!timestamp }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        $event.get('Start') <= $!timestamp.evaluate($event) <= $event.get('End');
    }
}

class Subtitle::Filter::Operator::In is Subtitle::Filter {
    has Subtitle::Filter $.left;
    has Set $.right;
    method gist { 'in [' ~ $!right ~ ']' }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        $!left.evaluate($event) (elem) $!right;
    }
}

class Subtitle::Filter::Operator is Subtitle::Filter {
    has Subtitle::Filter $.left;
    has Subtitle::Filter $.right;
    method op { ... }
    method gist { ($!left.gist, self.op, $!right.gist).join(' ') }
}

class Subtitle::Filter::Operator::Eq is Subtitle::Filter::Operator {
    method op { 'eq' }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        return $.left.evaluate($event) eq $.right.evaluate($event);
    }
}

class Subtitle::Filter::Operator::Ne is Subtitle::Filter::Operator {
    method op { 'ne' }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        return $.left.evaluate($event) ne $.right.evaluate($event);
    }
}

class Subtitle::Filter::Operator::Like is Subtitle::Filter::Operator {
    method op { 'like' }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        my $right = $.right.evaluate($event);
        ($.left.evaluate($event) ~~ /<$right>/).Bool;
    }
}

class Subtitle::Filter::Operator::Lt is Subtitle::Filter::Operator {
    method op { 'lt' }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        return $.left.evaluate($event) lt $.right.evaluate($event);
    }
}

class Subtitle::Filter::Operator::LtNumber is Subtitle::Filter::Operator {
    method op { '<' }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        return $.left.evaluate($event) < $.right.evaluate($event);
    }
}

class Subtitle::Filter::Operator::Le is Subtitle::Filter::Operator {
    method op { 'le' }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        return $.left.evaluate($event) le $.right.evaluate($event);
    }
}

class Subtitle::Filter::Operator::LeNumber is Subtitle::Filter::Operator {
    method op { '<=' }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        return $.left.evaluate($event) <= $.right.evaluate($event);
    }
}

class Subtitle::Filter::Operator::Gt is Subtitle::Filter::Operator {
    method op { 'gt' }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        return $.left.evaluate($event) gt $.right.evaluate($event);
    }
}

class Subtitle::Filter::Operator::GtNumber is Subtitle::Filter::Operator {
    method op { '>' }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        return $.left.evaluate($event) > $.right.evaluate($event);
    }
}

class Subtitle::Filter::Operator::Ge is Subtitle::Filter::Operator {
    method op { 'ge' }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        return $.left.evaluate($event) ge $.right.evaluate($event);
    }
}

class Subtitle::Filter::Operator::GeNumber is Subtitle::Filter::Operator {
    method op { '>=' }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        return $.left.evaluate($event) >= $.right.evaluate($event);
    }
}
