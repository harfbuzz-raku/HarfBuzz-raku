use HarfBuzz;
use HarfBuzz::Raw::Defs :&hb-tag-dec, :hb-script, :hb-direction;
use Test;
use Font::FreeType;
use Font::FreeType::Face;
use Font::FreeType::Raw::Defs;

plan 9;

if HarfBuzz.version < v1.6.0 {
    skip-rest "HarfBuzz version is too old";
    exit;
}

my $file = 't/fonts/NimbusRoman-Regular.otf';
my Font::FreeType::Face $ft-face = Font::FreeType.new.face($file);
my $size = 36;
my @scale = 1000, 1000;
$ft-face.set-char-size(0, 0, |@scale);
my HarfBuzz $hb .= new: :$file, :text<Hell€!>, :lang<epo>, :$ft-face, :$size, :@scale;
is $hb.size, 36;
is $hb.scale[0], 1000;
is $hb.length, 6;
is $hb.lang, 'epo';
is $hb.script, +HB_SCRIPT_LATIN;
is $hb.script.&hb-tag-dec, 'Latn';
is $hb.direction, +HB_DIRECTION_LTR;
is $hb.ft-load-flags, +FT_LOAD_NO_HINTING;
my @info = $hb.glyphs>>.ast;
my @expected = [
  {
    ax => 23.11,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 41,
    name => 'H',
  },
  {
    ax => 13.43,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 70,
    name => 'e',
  },
  {
    ax => 8.89,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 77,
    name => 'l',
  },
  {
    ax => 8.89,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 77,
    name => 'l',
  },
  {
    ax => 16.02,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 347,
    name => 'Euro',
  },
  {
    ax => 10.66,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 2,
    name => 'exclam',
  },
];

unless HarfBuzz.version >= v2.6.6 {
    # name not available in older HarfBuzz versions
    .<name>:delete for flat @expected, @info;
}
is-deeply @info, @expected;
