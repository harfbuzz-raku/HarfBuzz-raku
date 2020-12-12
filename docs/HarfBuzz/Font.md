[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[HarfBuzz Module]](https://pdf-raku.github.io/HarfBuzz-raku)
 / [HarfBuzz](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz)
 :: [Font](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Font)

class Attribute+{<anon|2>}.new(handles => "Blob")
-------------------------------------------------

HarfBuzz core font data-type

==head2 Synopsis

    use HarfBuzz::Font;
    my HarfBuzz::Font() .= %( :$file, :@features, :$size, :@scale );

