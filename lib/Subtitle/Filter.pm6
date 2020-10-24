use Subtitle::SubStationAlphaV4Plus::SectionLine;

class Subtitle::Filter {
    method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event) { ... }
}

class Subtitle::Filter::Constant is Subtitle::Filter {
    has Cool $.value;
    method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Cool) { $.value }
}

class Subtitle::Filter::AttributeLookup is Subtitle::Filter {
    has Str $.field;
    method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Cool) {
        $event.get($.field);
    }
}

class Subtitle::Filter::Operator::Eq is Subtitle::Filter {
    has Subtitle::Filter $.left;
    has Subtitle::Filter $.right;

    method evaluate(Subtitle::SubStationAlphaV4Plus::Event $event --> Bool) {
        return $.left.evaluate eq $.right.evaluate;
    }
}

