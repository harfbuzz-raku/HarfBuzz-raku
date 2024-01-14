use Test;
plan 5;
use HarfBuzz;
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
    my Version $min-version = v4.2.0;
    if HarfBuzz.version >= $min-version {
        my @unicodes := $unicode-set.array;
        is @unicodes.elems, 854, 'array elems';
        is @unicodes[10], 42;
    }
    else {
        skip-rest "HarfBuzz >= v$min-version is required for set array tests";
    }
}

subtest 'unicode-to-gid-map', {
    plan 6;
    my Version $min-version = v7.0.0;
    if HarfBuzz.version >= $min-version {
        my HarfBuzz::Map $unicode-map = $face.unicode-to-gid-map;
        ok $unicode-map.exists(42), 'exists';
        nok $unicode-map.exists(31), '!exists';
        my HarfBuzz::Set $keys = $unicode-map.keys;
        my HarfBuzz::Set $values = $unicode-map.values;
        is $values.array[10], 11, 'values';
        is $unicode-map.elems, 854, 'elems';
        is $unicode-map{42}, 11;
        is-deeply $unicode-map{31}, Int;
    }
    else {
        skip-rest "HarfBuzz >= v$min-version is required for unicode-map tests";
    }
}

subtest 'tags', {
    my @tags = $face.table-tags;
    is @tags.join(','), 'CFF,GPOS,GSUB,OS/2,PCLT,cmap,head,hhea,hmtx,maxp,name,post';
}

