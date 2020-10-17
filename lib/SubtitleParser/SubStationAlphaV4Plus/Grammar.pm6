#use Grammar::Tracer;
unit grammar SubtitleParser::SubStationAlphaV4Plus::Grammar;

rule TOP {
    :my Bool %*section-names;
    <section>+ %% \n
}

proto token section { * }
token section:sym<style> {
    '[V4+ Styles]' \n
    { fail "Duplicate section: V4+ Styles" if %*section-names{'V4+ Styles'}:exists }
    { %*section-names{'V4+ Styles'} = True }
    <format> \n+
    {} # necessary to get $<format> filled in
    :my @*fields = $<format>.made.values;
    <style>+ % \n+
}
token section:sym<generic> {
    '[' <section-name> ']' \n
    { fail "Duplicate section: $<section-name>" if %*section-names{$<section-name>}:exists }
    { %*section-names{$<section-name>} = True }
    <section-line>+ % \n+
}

token format {
    'Format: '
    <field>+ % <comma-separator>
}

token style {
    'Style: '
    <field>+ % <comma-separator>
}

token section-name { <-[\]]>+ }

proto token section-line { * }
token section-line:sym<comment> {
    <comment-token> \s* <value=string-to-end-of-line>
}
token section-line:sym<key-value> {
    <key> \s* ':' \s* <value=string-to-end-of-line>
}

token comment-token { [ ';' | '!:' ] }

token key { <-[:\n]>+ }
token string-to-end-of-line { \V+ }

token field { <-[,\n]>+ }

token comma-separator { \s* ',' \s* }
