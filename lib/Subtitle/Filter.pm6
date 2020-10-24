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

class Subtitle::Filter::Operator::Like is Subtitle::Filter::Operator {
    method op { 'like' }
    multi method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        my $right = $.right.evaluate($event);
        ($.left.evaluate($event) ~~ /<$right>/).Bool;
    }
}
