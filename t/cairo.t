use HarfBuzz;
use HarfBuzz::Shaper;
use HarfBuzz::Font;
use HarfBuzz::Buffer;
use Cairo;
use Font::FreeType;
use Font::FreeType::Face;
use Test;
plan 42;

my $version = HarfBuzz.version;
unless $version >= v1.6.0 {
    skip-rest "HarfBuzz version $version is too old to run these tests";
    exit;
}

my $file = 't/fonts/NimbusRoman-Regular.otf';
my $ft-face = Font::FreeType.new.face($file);
my $text = 'Hell€!';
my @scale = 1000;
my HarfBuzz::Shaper $hb .= new: :font{:$file, :size(16)}, :buf{:$text, :language<epo>, };
my HarfBuzz::Shaper $hb-ft .= new: :buf{:$text, :language<epo>}, :font{ :$ft-face, :size(16)};

for $hb, $hb-ft {
    my Cairo::Glyphs $glyphs = .cairo-glyphs;
    is $glyphs.elems, $text.chars;
    enum <index x y>;
    my Array @expected = [41, 0, 0 ], [70, 11.55, 0], [77, 18.3, 0], [77, 22.75, 0], [347, 27.2, 0], [2, 35.2, 0];

    for 0 ..^ @expected {
        my Cairo::cairo_glyph_t:D $glyph = $glyphs[$_];

        is $glyph.index, @expected[$_][index], "glyph $_ index";
        is $glyph.x.round(.01), @expected[$_][x],  "glyph $_ x";
        is $glyph.y.round(.01), @expected[$_][y],  "glyph $_ y";
    }

    is-approx $glyphs.x-advance.round(0.01), 40.53, :abs-tol(0.02);
    is $glyphs.y-advance.round(0.001), 0;
}

