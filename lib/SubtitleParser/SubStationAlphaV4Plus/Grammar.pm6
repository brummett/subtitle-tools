unit grammar SubtitleParser::SubStationAlphaV4Plus::Grammar;

rule TOP {
    <section>+ %% \n
}

token section {
    '[' <section-name> ']' \n
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
