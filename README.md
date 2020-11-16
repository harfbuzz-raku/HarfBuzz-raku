HarfBuzz-raku
=============

Bindings to the HarfBuzz text shaping library.

Name
----

HarfBuzz - Use HarfBuzz for text shaping and font manipulation.

Synopsis
--------

```
use HarfBuzz;
my $file = 't/fonts/NimbusRoman-Regular.otf';
my HarfBuzz $hb .= new: :$file, :size(36), :text<Hello!>;
my @info = $hb.shape>>.ast;
```

The result is an array of hashes, one element for each glyph to be typeset.

Description
----------

HarfBuzz is a Raku module that provides access to a small subset of the native HarfBuzz library. 

The subset is suitable for typesetting programs that need to deal with complex languages like Devanagari, Hebrew or Arabic.

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

### new
```
method new(
    Str :$file, Font::FreeType::Face :$ft-face,
    Str :$text,
    Numeric :@scale, Numeric :$size = 12,
    :@features,
    Str :$language, Str :$script, UInt :$direction
) returns HarfBuzz:D;
```
Creates a new HarfBuzz object for text shaping, font subsetting, etc.

See Also
--------

[HarfBuzz::Shaper](https://metacpan.org/pod/HarfBuzz::Shaper) - Perl CPAN module.
[Cairo](https://github.com/timo/cairo-p6) - Raku bindings to Cairo 2D graphics library
[Font::FreeType](https://github.com/pdf-raku/Font-FreeType-raku) - Raku bindings to the FreeType2 font library
[HarfBuzz::Subset](https://github.com/pdf-raku/HarfBuzz-Subset-raku) - Raku bindings to harfbuzz-subset font subsetting library