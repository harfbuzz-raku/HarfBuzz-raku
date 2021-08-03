[[Raku HarfBuzz Project]](https://harfbuzz-raku.github.io)
 / [[HarfBuzz Module]](https://harfbuzz-raku.github.io/HarfBuzz-raku)
 / [HarfBuzz](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz)
 :: [Font](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Font)

class HarfBuzz::Font
--------------------

HarfBuzz font data-type

Synopsis
--------

    use HarfBuzz::Font;
    my HarfBuzz::Font() .= %( :$file, :@features, :$size, :@scale );

Description
-----------

A HarfBuzz font is used for shaping text (See class [HarfBuzz::Shaper](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Shaper)).

Fonts may also be subsetted (Reduced to a smaller set of glyphs; see module [HarfBuzz::Subset](https://harfbuzz-raku.github.io/HarfBuzz-Subset-raku/HarfBuzz/Subset)).

Methods
-------

### method scale

```raku
method scale() returns List
```

Gets or sets x and y scale

### method size

```raku
method size() returns Numeric
```

Gets or sets the font size

### method add-features

```raku
method add-features(
    HarfBuzz::Feature(Any) @features
) returns Array[HarfBuzz::Feature]
```

Add font features

### method glyph-name

```raku
method glyph-name(
    Int:D $gid where { ... }
) returns Str
```

Returns the glyph name for a glyph identifier

### method glyph-from-name

```raku
method glyph-from-name(
    Str:D $name
) returns UInt
```

Returns the glyph identifier for a given glyph name

### method glyph-extents

```raku
method glyph-extents(
    Int:D $gid where { ... }
) returns HarfBuzz::Raw::hb_glyph_extents
```

Returns metrics for a glyph

Note that `hb_glyph_extents` is a `CStruct` with `Num` attributes `x-advance`, `y-advance`, `x-offset` and `y-offset`.

### method shape

```raku
method shape(
    HarfBuzz::Buffer:D :$buf!
) returns Mu
```

Shape a buffer using this font

