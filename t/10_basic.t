use HarfBuzz;
use HarfBuzz::Raw::Defs :&hb-tag-enc, :&hb-tag-dec, :hb-script, :hb-direction;
use Test;
plan 22;
my Version $version;
lives-ok { $version = HarfBuzz.version }, 'got version';
note "HarfBuzz version is $version (bindings {HarfBuzz.^ver})";

if $version < v1.6.0 {
    skip-rest "HarfBuzz version is too old";
    exit;
}

is hb-tag-dec(hb-tag-enc('post')), 'post';

my $file = 't/fonts/NimbusRoman-Regular.otf';
my HarfBuzz $hb .= new: :$file, :size(36), :scale[1000], :text<Hell€!>, :language<epo>;
is $hb.size, 36;
is $hb.scale[0], 1000;
is $hb.length, 6;
is $hb.language, 'epo';
is $hb.script, +HB_SCRIPT_LATIN;
is $hb.script.&hb-tag-dec, 'Latn';
is $hb.direction, +HB_DIRECTION_LTR;
my @info = $hb.shape>>.ast;
my @expected = [
  {
    ax => 25.99,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 41,
    name => 'H',
  },
  {
    ax => 15.19,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 70,
    name => 'e',
  },
  {
    ax => 10.01,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 77,
    name => 'l',
  },
  {
    ax => 10.01,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 77,
    name => 'l',
  },
  {
    ax => 18.0,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 347,
    name => 'Euro',
  },
  {
    ax => 11.99,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 2,
    name => 'exclam',
  },
];

unless $version >= v2.6.6 {
    # name not available in older HarfBuzz versions
    .<name>:delete for flat @expected, @info;
}
is-deeply @info, @expected;

my $codepoint = $hb.glyph-from-name('H');
is $codepoint, 41;
is $hb.glyph-name($codepoint), 'H';
my $extents = $hb.glyph-extents($codepoint);
is $extents.x-bearing, 19;
is $extents.y-bearing, 662;
is $extents.width, 683;
is $extents.height, -662;

$codepoint = $hb.glyph-from-name('e');
is $codepoint, 70;
is $hb.glyph-name($codepoint), 'e';
$extents = $hb.glyph-extents($codepoint);
is $extents.x-bearing, 25;
is $extents.y-bearing, 460;
is $extents.width, 399;
is $extents.height, -470;
