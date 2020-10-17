unit grammar SubtitleParser::SubStationAlphaV4Plus::Grammar;

rule TOP {
    :my Bool %*section-names;
    <section>+ %% \n
}

proto token section { * }
token section:sym<generic> {
    '[' <section-name> ']' \n
    { fail "Duplicate section: $<section-name>" if %*section-names{$<section-name>}:exists }
    { %*section-names{$<section-name>} = True }
    <section-line>+
}

token section-name { <-[\]]>+ }

proto token section-line { * }
token section-line:sym<comment> {
    <comment-token> \s* <value=string-to-end-of-line> \n
}
token section-line:sym<key-value> {
    <key> \s* ':' \s* <value=string-to-end-of-line> \n
}

token comment-token { [ ';' | '!:' ] }

token key { <-[:\n]>+ }
token string-to-end-of-line { \V+ }
