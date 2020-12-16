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
use HarfBuzz::Feature;
my HarfBuzz::Feature() @features = <smcp -kern -liga>; # enable small-caps, disable kerning and ligatures
my $file = 't/fonts/NimbusRoman-Regular.otf';
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


Classes/Modules in this distribution
-------

- [HarfBuzz::Buffer](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Font) - Shaping content and context
- [HarfBuzz::Font](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Font) - Shaping font
- [HarfBuzz::Font::FreeType](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Font/FreeType) - HarfBuzz / FreeType integration
- [HarfBuzz::Feature](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Feature) - Font Features
- [HarfBuzz::Glyph](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Glyph) - Shaped Glyphs
- [HarfBuzz::Shaper](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Shaper) - Font/Buffer shaper
- [HarfBuzz::Raw](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Raw) - Native bindings
- [HarfBuzz::Raw::Defs](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Raw/Defs) - Enumerations and other constants

See Also
--------

- [HarfBuzz::Shaper](https://metacpan.org/pod/HarfBuzz::Shaper) - Perl CPAN module.
- [Cairo](https://github.com/timo/cairo-p6) - Raku bindings to Cairo 2D graphics library
- [Font::FreeType](https://pdf-raku.github.io/Font-FreeType-raku/) - Raku bindings to the FreeType2 font library
- [HarfBuzz::Subset](https://pdf-raku.github.io/HarfBuzz-Subset-raku/) - Raku bindings to harfbuzz-subset font subsetting library