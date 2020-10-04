use Subtitle::SubStationAlphaV4Plus::SectionLine;

use Test;

plan 2;

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
