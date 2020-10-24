unit grammar Subtitle::Filter::Grammar;

token TOP {
    <expression>
}

proto rule expression { * }
rule expression:sym<infix-operator> { <left=expr-simple> <operator> <right=expr-simple> }

proto token operator { * }
token operator:sym<eq> { '=' }
token operator:sym<like> { :ignorecase 'like' }

proto rule expr-simple { * }
rule expr-simple:sym<identifier-or-value>  { <atom> }

proto token atom { * }
token atom:sym<identifier> { <alpha>+ }
token atom:sym<number> { <digit>+ }
token atom:sym<string-qq> {
    '"'
    $<value>=(
        [ <-["]>+:
            | '\"'
        ]*
    )
    '"'
}
token atom:sym<string-q> {
    "'"
    $<value>=(
        [ <-[']>+:
            | "\\'"
        ]*
    )
    "'"
}
