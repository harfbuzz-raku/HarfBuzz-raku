[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[HarfBuzz Module]](https://pdf-raku.github.io/HarfBuzz-raku)
 / [HarfBuzz](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz)
 :: [Font](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Font)
 :: [FreeType](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Font/FreeType)

### has Font::FreeType::Face:D $.ft-face

HarfBuzz FreeType bound font data-type

==head2 Synopsis

    use HarfBuzz::Font::FreeType;
    use Font::FreeType::Face;
    my  Font::FreeType::Face .= new: ...;
    my HarfBuzz::Font::FreeType() .= %( :$ft-face, :@features, :$size, :@scale );

