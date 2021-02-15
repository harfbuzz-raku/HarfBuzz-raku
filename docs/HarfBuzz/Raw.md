[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[HarfBuzz Module]](https://pdf-raku.github.io/HarfBuzz-raku)
 / [HarfBuzz](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz)
 :: [Raw](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Raw)

module HarfBuzz::Raw
--------------------

Native HarfBuzz bindings

class HarfBuzz::Raw::hb_glyph_position
--------------------------------------

A relative glyph position

class HarfBuzz::Raw::hb_glyph_positions
---------------------------------------

A contiguous array of glyph positions

class HarfBuzz::Raw::hb_glyph_info
----------------------------------

Additional glyph information

class HarfBuzz::Raw::hb_glyph_infos
-----------------------------------

A contiguous array of glyph information

class HarfBuzz::Raw::hb_glyph_extents
-------------------------------------

Unscaled glyph metrics

class HarfBuzz::Raw::hb_blob
----------------------------

Storage for a HarfBuzz buffer

class HarfBuzz::Raw::hb_language
--------------------------------

HarfBuzz language representation

class HarfBuzz::Raw::hb_buffer
------------------------------

A HarfBuzz buffer

This holds text or glyph transforms, plus context, inlcuding language, script and direction.

class HarfBuzz::Raw::hb_set
---------------------------

HarfBuzz generalized set representation

class HarfBuzz::Raw::hb_feature
-------------------------------

HarfBuzz representation of a font feature

class HarfBuzz::Raw::hb_features
--------------------------------

A contiguous arry of font features

class HarfBuzz::Raw::hb_face
----------------------------

A context free representation of a HarfBuzz font face

class HarfBuzz::Raw::hb_font
----------------------------

A contextual representation of a HarfBuzz font

include font-face, size and scale. A Font can be haped against a buffer.

