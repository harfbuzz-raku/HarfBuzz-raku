[[Raku HarfBuzz Project]](https://harfbuzz-raku.github.io)
 / [[HarfBuzz Module]](https://harfbuzz-raku.github.io/HarfBuzz-raku)
 / [HarfBuzz](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz)
 :: [Shaper](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Shaper)

class HarfBuzz::Shaper
----------------------

HarfBuzz shaping object

### method font

```raku
method font() returns HarfBuzz::Font
```

Gets or sets the font

### method buf

```raku
method buf() returns HarfBuzz::Buffer
```

Gets or sets the shaping buffer

### method glyphs

```raku
method glyphs() returns Iterator
```

Returns a set of shaped HarfBuzz::Glyph objects

### method text-advance

```raku
method text-advance() returns List
```

Returns scaled X and Y displacement of the shaped text

### method ast

```raku
method ast() returns List
```

Returns a Hash sequence of scaled glyphs

Entries are:

  * `ax`: horizontal advance

  * `ay`: vertical advance

  * `dx`: horizontal offset

  * `dy`: vertical offset

  * `g`: glyph index in font (CId)

  * `name`: glyph name

### method version

```raku
method version() returns Version
```

Returns the version of the nativeHarfBuzz library

### size

    method size(--> Num) is rw;

Get or set the font size used for shaping.

Note that the font size will in general affect details of the appearance, A 5 point fontsize magnified 10 times is not identical to 50 point font size.

### text

    method text(--> Str) is rw;

Gets or sets the text to shape.

### features

    method features(--> HarfBuzz::Feature() @)

Get shaping features. 

### add-features

    method add-features(HarfBuzz::Feature() @features)

Add specified features are added to the set of persistent features. Features may be added as HarfBuzz::Feature objects, or coerced from strings as described in https://harfbuzz.github.io/harfbuzz-hb-common.html#hb-feature-from-string and https://css-tricks.com/almanac/properties/f/font-feature-settings/#values.

### language

    method language returns Str is rw

Gets or sets the language for shaping. The language must be a string containing a valid BCP-47 language code.

### script

    method script returns Str is rw

Gets or sets the script (alphabet) for shaping.

script must be a string containing a valid ISO-15924 script code. For example, "Latn" for the Latin (Western European) script, or "Arab" for arabic script.

### direction

    use HarfBuzz::Raw::Defs :hb-direction;
    method direction returns UInt is rw;

Gets or sets the direction for shaping: `HB_DIRECTION_LTR` (left-to-right), `HB_DIRECTION_RTL` (right-to-left), `HB_DIRECTION_TTB` (top-to-bottom), or `HB_DIRECTION_BTT` (bottom-to-top).

If you don't set a direction, HarfBuzz::Shaper will make a guess based on the text string. This may or may not yield desired results.

### AT-KEY

    method AT-KEY(Int $pos) returns HarfBuzz::Glyph
    say "last glyph: " ~ $shaper[$shaper.elems -1].name;

