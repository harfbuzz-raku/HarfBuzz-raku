use Test;
plan 4;
use HarfBuzz::Face;

my $file = 't/fonts/NimbusRoman-Regular.otf';
my HarfBuzz::Face:D() $face = %( :$file );

is $face.get-glyph-count, 855;
is $face.units-per-EM, 1000;

subtest 'unicode-set', {
    my HarfBuzz::Set $unicode-set = $face.unicode-set;
    ok $unicode-set.defined;
    is $unicode-set.elems, 854, 'set elems';
    ok $unicode-set.exists(42), 'exists';
    my @unicodes := $unicode-set.array;
    is @unicodes.elems, 854, 'array elems';
    is @unicodes[10], 42;
}

subtest 'unicode-to-gid-map', {
    my HarfBuzz::Map $unicode-map = $face.unicode-to-gid-map;
    ok $unicode-map.exists(42), 'exists';
    my HarfBuzz::Set $keys = $unicode-map.keys;
    my HarfBuzz::Set $values = $unicode-map.values;
    is $values.array[10], 11, 'values';
    is $unicode-map.elems, 854, 'elems';
    is $unicode-map[42], 11;
}

