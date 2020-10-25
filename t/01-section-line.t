use Subtitle::SubStationAlphaV4Plus::SectionLine;

use Test;

plan 4;

subtest 'KeyValue' => sub {
    plan 2;

    my $kv = Subtitle::SubStationAlphaV4Plus::KeyValue.new(key => 'Title', value => 'foo');
    ok $kv, 'create';
    is $kv.Str, "Title: foo\n", 'stringify';
}

subtest 'Comment' => sub {
    plan 5;

    my $comment1 = Subtitle::SubStationAlphaV4Plus::Comment.new(key => ';', value => 'foo');
    ok $comment1, 'create ;';
    is $comment1.Str, "; foo\n", 'stringify ;';

    my $comment2 = Subtitle::SubStationAlphaV4Plus::Comment.new(key => '!:', value => 'foo');
    ok $comment2, 'create !:';
    is $comment2.Str, "!: foo\n", 'stringify $!';

    throws-like {
        my $broken = Subtitle::SubStationAlphaV4Plus::Comment.new(key => 'Notallowed', value => 'foo');
    }, X::TypeCheck::Assignment, 'restrict keys';
}

subtest 'Format' => sub {
    plan 4;

    my $format = Subtitle::SubStationAlphaV4Plus::Format.new(values => [ 'one', 'two', 'three' ]);
    ok $format, 'create';
    is $format.Str, "Format: one,two,three\n", 'stringify';
    is $format.values, ['one', 'two', 'three'], 'values';
    is $format.value, 'one,two,three', 'value';
}

subtest 'Style' => sub {
    plan 8;

    my $style = Subtitle::SubStationAlphaV4Plus::Style.new(
                    fields => ['first', 'second', 'third'],
                    values => [ 'one', 'two', 'three' ]);
    ok $style, 'create';
    is $style.Str, "Style: one,two,three\n", 'stringify';
    is $style.values, ['one', 'two', 'three'], 'values';
    is $style.value, 'one,two,three', 'value';
    is $style.fields, ['first', 'second', 'third'], 'fields';
    is $style.get('first'), 'one', 'get first field';
    is $style.get('second'), 'two', 'get second field';
    is $style.get('third'), 'three', 'get third field';
}
