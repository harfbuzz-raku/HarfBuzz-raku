[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[HarfBuzz Module]](https://pdf-raku.github.io/HarfBuzz-raku)

HarfBuzz-raku
=============

Bindings to the HarfBuzz text shaping library.

**EXPERIMENTAL** recommended minimum HarfBuzz version is v2.6.6 - See [Installation](#installation)

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
use HarfBuzz::Glyphs;
my HarfBuzz::Feature() @features = <smcp -kern -liga>; # enable small-caps, disable kerning and ligatures
my $file = 't/fonts/NimbusRoman-Regular.otf';
my HarfBuzz::Font $font .= new :$file, :size(36), :@features;
my HarfBuzz::Buffer $buf .= new :text<Hello!>;
my HarfBuzz::Shaper $shaper .= new: :$font :$buf;
for $shaper.shape -> HarfBuzz::Glyph $glyph { ... }
my Hash @info = $shaper.ast;
```

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

- [HarfBuzz::Buffer](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Buffer) - Shaping text and context
- [HarfBuzz::Font](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Font) - Shaping font
- [HarfBuzz::Feature](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Feature) - Font Features
- [HarfBuzz::Glyph](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Glyph) - Shaped Glyphs
- [HarfBuzz::Shaper](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Shaper) - Shape a buffer using a given font and features
- [HarfBuzz::Raw](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Raw) - Native bindings
- [HarfBuzz::Raw::Defs](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Raw/Defs) - Enumerations and other constants

Installation
-----
This module requires HarfBuzz 2.6.6+ to be fully operational and pass all it's tests, which typically means Debian 11 Bullseye (currently testing).

`$ sudo apt-get install libharfbuzz-dev # Debian 11+`

Or the HarfBuzz library needs to be built from source [its repo](https://github.com/harfbuzz/harfbuzz/releases/):

A source build is required if you are installing this as [HarfBuzz::Subset](https://harfbuzz-raku.github.io/HarfBuzz-Subset-raku/) dependency.

Additional Modules
------

- [HarfBuzz::Font::FreeType](https://harfbuzz-raku.github.io/HarfBuzz-Font-FreeType-raku/) - HarfBuzz / FreeType integration
- [HarfBuzz::Shaper::Cairo](https://harfbuzz-raku.github.io/HarfBuzz-Shaper-Cairo-raku/) - HarfBuzz / Cairo shaping integration
- [HarfBuzz::Subset](https://harfbuzz-raku.github.io/HarfBuzz-Subset-raku/) - Raku bindings to harfbuzz-subset font subsetting library

See Also
--------

- [HarfBuzz::Shaper](https://metacpan.org/pod/HarfBuzz::Shaper) - Perl CPAN module.
