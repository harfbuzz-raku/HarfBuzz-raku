[[Raku HarfBuzz Project]](https://harfbuzz-raku.github.io)
 / [[HarfBuzz Module]](https://harfbuzz-raku.github.io/HarfBuzz-raku)
 / [HarfBuzz](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz)
 :: [Face](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Face)

class HarfBuzz::Face
--------------------

A context free HarfBuzz font face

Synopsis
--------

    use HarfBuzz::Face;
    my HarfBuzz::Face() $face
    $face .= new( :$file, :$index );
    $face .= new( :$buf, :$index );

Description
-----------

A font object represents a font face at a specific size and with certain other parameters (pixels-per-em, points-per-em, variation settings) specified. Font objects are created from font face objects, and are used as input for shaping, and subsetting.

An `:$index` number (default `0`) is required to select a font from a True Type Collection (extension `.ttc`) or Open Type Collection (extension `.otc`).

