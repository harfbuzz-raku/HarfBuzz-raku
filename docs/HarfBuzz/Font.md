[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[HarfBuzz Module]](https://pdf-raku.github.io/HarfBuzz-raku)
 / [HarfBuzz](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz)
 :: [Font](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Font)

class HarfBuzz::Font
--------------------

HarfBuzz font data-type

Synopsis
--------

    use HarfBuzz::Font;
    my HarfBuzz::Font() .= %( :$file, :@features, :$size, :@scale );

Description
-----------

A HarfBuzz font is used for shaping text (See class [HarfBuzz::Shaper](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Shaper)).

Fonts may also be subsetted (Reduced to a smaller set of glyphs; see module [HarfBuzz::Subset](https://pdf-raku.github.io/HarfBuzz-Subset-raku/HarfBuzz/Subset)).

Methods
-------

### method scale

```perl6
method scale() returns List
```

Gets or sets x and y scale

### method size

```perl6
method size() returns Numeric
```

Gets or sets the font size

### method add-features

```perl6
method add-features(
    HarfBuzz::Feature(Any) @features
) returns Array[HarfBuzz::Feature]
```

Add font features

### method glyph-name

```perl6
method glyph-name(
    Int:D $gid where { ... }
) returns Str
```

Returns the glyph name for a glyph identifier

### method glyph-from-name

```perl6
method glyph-from-name(
    Str:D $name
) returns UInt
```

Returns the glyph identifier for a given glyph name

### method glyph-extents

```perl6
method glyph-extents(
    Int:D $gid where { ... }
) returns HarfBuzz::Raw::hb_glyph_extents
```

Returns metrics for a glyph

Note that `hb_glyph_extents` is a `CStruct` with `Num` attributes `x-advance`, `y-advance`, `x-offset` and `y-offset`.

### method shape

```perl6
method shape(
    HarfBuzz::Buffer:D :$buf!
) returns Mu
```

Shape a buffer using this font

