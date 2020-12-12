HarfBuzz-raku
=============

Bindings to the HarfBuzz text shaping library.

Name
----

HarfBuzz - Use HarfBuzz for text shaping and font manipulation.

Synopsis
--------

```
use HarfBuzz::Font;
use HarfBuzz::Buffer;
use HarfBuzz::Shaper;
my $file = 't/fonts/NimbusRoman-Regular.otf';
my @features = <smcp -kern -liga>; # enable small-caps, disable kerning and ligatures
my HarfBuzz::Font $font .= new :$file, :size(36), :@features;
my HarfBuzz::Buffer $buf .= new :text<Hello!>;
my HarfBuzz::Shaper $shape .= new: :$font :$buf;
my @info = $shape.ast;
```

The result is an array of hashes, one element for each glyph to be typeset.

Description
----------

HarfBuzz is a Raku module that provides access to a small subset of the native HarfBuzz library. 

The subset is suitable for typesetting programs, whether they need to do basic glyph selection and layout, or deal with complex languages like Devanagari, Hebrew or Arabic.

Following the above example, the returned info is an array of hashes, one element for each glyph to be typeset. The hash contains the following items:

```
ax:   horizontal advance
ay:   vertical advance
dx:   horizontal offset
dy:   vertical offset
g:    glyph index in font (CId)
name: glyph name
```

Note that the number of glyphs does not necessarily match the number of input characters!


Methods
-------

### method new
```
method new(
    HarfBuzz::Font()   :$font,      # font object
    HarfBuzz::Buffer() :$buf,       # buffer to be shaped
) returns HarfBuzz:D;
```
Creates a new HarfBuzz object for text shaping, font subsetting, etc.

`:$font` and `:$buf` can be objects or coerced from hashes:
```
my HarfBuzz::Font $font .= new: :@scale, :$size, :@features;
my HarfBuzz::Buffer $buf .= new: :$language, :$size, :$text;
my HarfBuzz::Shaper :$shaper .= new: :$font, :$buf;
```
Can also be written as:
```
my HarfBuzz::Shaper :$shaper .= new(
    :font{ :@scale, :$size, :@features },
    :buf{ :$language, :$size, :$text }
);

```

### method advance
```
method advance returns Complex
```
Returns the overall size of the shaped text with the width as the real component and the vertical descent as the imaginary component.

### method shape
```
my HarfBuzz::Glyph @glyphs = $shaper.shape;
for $shaper.shape -> HarfBuzz::Glyph $glyph { ... }
```

Returns an iterable set of HarfBuzz::Glyph objects representing
the shaped glyphs.

### method ast
```
my Hash @glyphs = $shaper.ast;
for $shaper.ast -> %glyph-info { ... }
```
Similar to the shape method. However returning Hash rather than
Glyph objects

### method buf
```
method buf is rw returns HarfBuzz::Buffer
```
Getter/setter for the underlying HarfBuzz::Buffer object.

### method font
```
method font is rw returns HarfBuzz::Font
```
Getter/setter for the underlying HarfBuzz::Font object.
```

See Also
--------

[HarfBuzz::Shaper](https://metacpan.org/pod/HarfBuzz::Shaper) - Perl CPAN module.
[Cairo](https://github.com/timo/cairo-p6) - Raku bindings to Cairo 2D graphics library
[Font::FreeType](https://pdf-raku.github.io/Font-FreeType-raku/) - Raku bindings to the FreeType2 font library
[HarfBuzz::Subset](https://pdf-raku.github.io/HarfBuzz-Subset-raku/) - Raku bindings to harfbuzz-subset font subsetting library