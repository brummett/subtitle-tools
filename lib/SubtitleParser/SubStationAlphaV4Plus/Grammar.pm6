unit grammar SubtitleParser::SubStationAlphaV4Plus::Grammar;

rule TOP {
    <section>+ %% \n
}

token section {
    '[' <section-name> ']' \n
    <section-line>+
}

token section-name { <-[\]]>+ }

token section-line {
    <key> \s* ':' \s* <value=string-to-end-of-line> \n
}

token key { <-[:\n]>+ }
token string-to-end-of-line { \V+ }
