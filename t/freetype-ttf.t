use HarfBuzz;
use HarfBuzz::Shaper;
use HarfBuzz::Raw::Defs :hb-script, :hb-direction;
use Font::FreeType;
use Font::FreeType::Face;
use Cairo;
use Test;
plan 13;
unless $*RAKU.compiler.version >= v2020.11 {
    die "This version of Raku is too old to use the HarfBuzz semantics";
}
my Version $version;
lives-ok { $version = HarfBuzz.version }, 'got version';
note "HarfBuzz version is $version (bindings {HarfBuzz.^ver})";

unless $version >= v1.6.0 {
    skip-rest "HarfBuzz version $version is too old to run these tests";
    exit;
}

my $file = 't/fonts/unifont-subset.ttf';

my HarfBuzz::Shaper $shaper .= new: :font{ :$file, :size(20) }, :buf{:text<Hello>, :language<epo>};

my Font::FreeType::Face $ft-face = Font::FreeType.new.face($file);
my HarfBuzz::Shaper $ft-shaper .= new: :font{ :$ft-face, :size(20) }, :buf{:text<Hello>, :language<epo>};

for <size length language script direction> {
    is $ft-shaper."$_"(), $shaper."$_"(), "FreeType $_ accessor";
}

enum <x y>;
is-approx $shaper.text-advance[x], $ft-shaper.text-advance[x];

my @shape = $shaper.shape;
my @ft-shape = $ft-shaper.shape;

is-approx @ft-shape.tail<ax>, @shape.tail<ax>;

my Cairo::Glyphs $glyphs = $shaper.cairo-glyphs;
my Cairo::Glyphs $ft-glyphs = $ft-shaper.cairo-glyphs;
is  $glyphs.elems, $ft-glyphs.elems;
is-approx $ft-glyphs.x-advance, $glyphs.x-advance;
my Cairo::cairo_glyph_t:D $glyph = $glyphs[1];
my Cairo::cairo_glyph_t:D $ft-glyph = $ft-glyphs[1];

is $ft-glyph.index, $glyph.index, 'glyph index';
is-approx $ft-glyph.x, $glyph.x, 'glyph x';
is-approx $ft-glyph.y, $glyph.y, 'glyph y';
