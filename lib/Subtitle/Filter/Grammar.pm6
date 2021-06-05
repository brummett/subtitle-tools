unit grammar Subtitle::Filter::Grammar;

token TOP {
    <complex-expression>
}

proto rule complex-expression { * }
rule complex-expression:sym<and>     { :ignorecase <left=expression> 'and' <right=complex-expression> }
rule complex-expression:sym<or>      { :ignorecase <left=expression> 'or' <right=complex-expression> }
rule complex-expression:sym<simple>  { <expression> }

proto rule expression { * }
rule expression:sym<recurse>        { '(' ~ ')' <complex-expression> }
rule expression:sym<infix-operator> { <left=expr-simple> <operator> <right=expr-simple> }
rule expression:sym<at-operator>    { :ignorecase 'at' <timestamp=atom> }
rule expression:sym<not>            { <not-keyword> <complex-expression> }
rule expression:sym<in>             { :ignorecase <left=expr-simple> 'in' <in-list> }

token not-keyword { :ignorecase '!' | 'not' }

proto token operator { * }
token operator:sym<eq> { '==' | '=' }
token operator:sym<ne> { '!=' }
token operator:sym<lt> { 'lt'  }
token operator:sym<gt> { 'gt'  }
token operator:sym<le> { 'le'  }
token operator:sym<ge> { 'ge'  }
token operator:sym<lt-number> { '<'  }
token operator:sym<gt-number> { '>'  }
token operator:sym<le-number> { '<='  }
token operator:sym<ge-number> { '>='  }

token operator:sym<like> { :ignorecase 'like' }

proto rule expr-simple { * }
rule expr-simple:sym<identifier-or-value>  { <atom> }

rule in-list { '[' ~ ']' [ <atom>+ % ',' ] }

proto token atom { * }
token atom:sym<timestamp>  { <hour=digit> ':' $<minute>=[\d ** 2] ':' $<second>=[\d ** 2] [ '.' $<ms>=[ \d ** 2 ] ]? }
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
