[[Raku HarfBuzz Project]](https://harfbuzz-raku.github.io)
 / [[HarfBuzz Module]](https://harfbuzz-raku.github.io/HarfBuzz-raku)
 / [HarfBuzz](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz)
 :: [Buffer](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Buffer)

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

Description
-----------

A HarfBuzz::Buffer contains text and other shaping context properties, include language, script and writing direction.

It is normally shaped by calling the shape method from a font.

### method language

```raku
method language() returns Str
```

get or set the language.

### method length

```raku
method length() returns UInt
```

get the length of the buffer

script must be a string containing a valid ISO-15924 script code. For example, "Latn" for the Latin (Western European) script, or "Arab" for arabic script.

### method direction

```raku
method direction() returns Mu
```

Get or set the text direction

    use HarfBuzz::Raw::Defs :hb-direction;
    $buf.direction = HB_DIRECTION_RTL; # right-to-left

Direction should be `HB_DIRECTION_LTR` (left-to-right), `HB_DIRECTION_RTL` (right-to-left), `HB_DIRECTION_TTB` (top-to-bottom), or `HB_DIRECTION_BTT` (bottom-to-top).

### method text

```raku
method text() returns Mu
```

Get or set the text to shape

### method shaped

```raku
method shaped() returns Bool
```

Check if the buffer has been shaped.

A buffer is shaped by calling the `shape()` method from a [HarfBuzz::Font](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Font) object.

Note that a buffer needs to be reshaped after updating its properties, including text, language, script or direction.

See also [HarfBuzz::Shaper](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Shaper), which manages a font/buffer pairing for you.

### method is-horizontal

```raku
method is-horizontal() returns Bool
```

True if the writing direction is left-to-right or right-to-left

### method is-vertical

```raku
method is-vertical() returns Bool
```

True if the writing direction is top-to-bottom or bottom-to-top

### method reset

```raku
method reset() returns Mu
```

reset the buffer, ready for shaping

### method text-advance

```raku
method text-advance() returns List
```

Return the unscaled x and y displacement of the shaped text

