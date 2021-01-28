[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[HarfBuzz Module]](https://pdf-raku.github.io/HarfBuzz-raku)
 / [HarfBuzz](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz)
 :: [Buffer](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Buffer)

class HarfBuzz::Buffer
----------------------

HarfBuzz Text Buffer

Synopsis
--------

    use HarfBuzz::Buffer;
    use HarfBuzz::Font;
    my HarfBuzz::Buffer $buf .= new: :text("Hello"), :lang<en>;
    say $font.shaped; # False
    my HarfBuzz::Font $font .= new: :file<t/fonts/NimbusRoman-Regular.otf>;
    $font.shape: :$buf;
    say $font.shaped; # True
    say $font.cairo-glyphs.raku;

Description
-----------

A HarfBuzz::Buffer contains text and other shaping context properties, include language, script and writing direction.

It is normally shaped by calling the shape method from a font.

### method language

```perl6
method language() returns Str
```

get or set the language.

### method length

```perl6
method length() returns UInt
```

get the length of the buffer

script must be a string containing a valid ISO-15924 script code. For example, "Latn" for the Latin (Western European) script, or "Arab" for arabic script.

### method direction

```perl6
method direction() returns Mu
```

Get or set the text direction

    use HarfBuzz::Raw::Defs :hb-direction;
    $buf.direction = `HB_DIRECTION_RTL' # right-to-left

Direction should be `HB_DIRECTION_LTR` (left-to-right), `HB_DIRECTION_RTL` (right-to-left), `HB_DIRECTION_TTB` (top-to-bottom), or `HB_DIRECTION_BTT` (bottom-to-top).

### method text

```perl6
method text() returns Mu
```

Get or set the text to shape

### method shaped

```perl6
method shaped() returns Bool
```

Check if the buffer has been shaped.

A buffer is shaped by calling the `shape()` method from a [HarfBuzz::Font](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Font) object.

Note that a buffer needs to be reshaped after updating its properties, including text, language, script or direction.

See also [HarfBuzz::Shaper](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Shaper), which manages a font/buffer pairing for you.

### method is-horizontal

```perl6
method is-horizontal() returns Bool
```

True if the writing direction is left-to-right or right-to-left

### method is-vertical

```perl6
method is-vertical() returns Bool
```

True if the writing direction is top-to-bottom or bottom-to-top

### method cairo-glyphs

```perl6
method cairo-glyphs(
    Numeric :x($x0) = 0e0,
    Numeric :y($y0) = 0e0,
    Numeric :$scale = 1.0
) returns Mu
```

Return a set of Cairo compatible shaped glyphs

The return object is typically passed to either the Cairo::Context show_glyphs() or glyph_path() methods

### method reset

```perl6
method reset() returns Mu
```

reset the buffer, ready for shaping

### method text-advance

```perl6
method text-advance() returns List
```

Return the unscaled x and y displacement of the shaped text

