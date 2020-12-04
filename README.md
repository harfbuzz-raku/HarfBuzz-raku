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
my @features = <smcp -kern -liga>; # enable small-caps, disable kerning and ligatures
my HarfBuzz $hb .= new: :font{:$file, :size(36), :@features} :text<Hello!>;
my @info = $hb.shape>>.ast;
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

### new
```
method new(
    HarfBuzz::Font()   :$font,      # font object
    HarfBuzz::Buffer() :$buf,       # buffer to be shaped
) returns HarfBuzz:D;
```
Creates a new HarfBuzz object for text shaping, font subsetting, etc.

`:$font` and `:$buf` can be supplied as objects or coerced from option hashes, logically:
```
method new(
    :%font (
      Numeric :@scale,                # font scale [x and y (optional)]
      Numeric :$size = 12,            # font size (default 12)
      HarfBuzz::Feature() :@features, # font features to enable
    ),
    :%buf (
      Str :$language,                 # language code
      Str :$script,                   # font script
      UInt :$direction,               # font direction
    ),
)
```

shape returns
====
Returns an iterable see of Harf


See Also
--------

[HarfBuzz::Shaper](https://metacpan.org/pod/HarfBuzz::Shaper) - Perl CPAN module.
[Cairo](https://github.com/timo/cairo-p6) - Raku bindings to Cairo 2D graphics library
[Font::FreeType](https://pdf-raku.github.io/Font-FreeType-raku/) - Raku bindings to the FreeType2 font library
[HarfBuzz::Subset](https://pdf-raku.github.io/HarfBuzz-Subset-raku/) - Raku bindings to harfbuzz-subset font subsetting library