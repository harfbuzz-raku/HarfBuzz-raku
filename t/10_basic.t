use HarfBuzz;
use HarfBuzz::Shaper;
use HarfBuzz::Raw::Defs :&hb-tag-enc, :&hb-tag-dec, :hb-script, :hb-direction;
constant Min-HarfBuzz-Version = v2.6.6;
use Test;
plan 26;
unless $*RAKU.compiler.version >= v2020.11 {
    die "This version of Raku is too old to use the HarfBuzz semantics";
}
my Version $version;
lives-ok { $version = HarfBuzz.version }, 'got version';
note "HarfBuzz version is $version (bindings {HarfBuzz.^ver})";

ok($version >= Min-HarfBuzz-Version, "HarfBuzz version is suppported")
    or diag "sorry this version of HarfBuzz is not supported ($version < {Min-HarfBuzz-Version})";

is hb-tag-dec(hb-tag-enc('post')), 'post';

my $file = 't/fonts/NimbusRoman-Regular.otf';
my HarfBuzz::Shaper $shaper .= new: :font{ :$file, :size(36), :scale[1000], }, :buf{:text<test>, :language<epo>};
is $shaper.text, 'test';
$shaper.text = 'Hell€!';
is $shaper.text, 'Hell€!';
is $shaper.size, 36;
is $shaper.scale[0], 1000e0;
is $shaper.length, 6;
is $shaper.language, 'epo';
is $shaper.script, HB_SCRIPT_LATIN;
is $shaper.script, 'Latn';
is $shaper.direction, +HB_DIRECTION_LTR;
my @shape = $shaper.shape>>.ast;
my @expected = [
  {
    c => 0,
    ax => 25.99,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 41,
    name => 'H',
  },
  {
    c => 1,
    ax => 15.19,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 70,
    name => 'e',
  },
  {
    c => 2,
    ax => 10.01,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 77,
    name => 'l',
  },
  {
    c => 3,
    ax => 10.01,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 77,
    name => 'l',
  },
  {
    c => 4,
    ax => 18.0,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 347,
    name => 'Euro',
  },
  {
    c => 5,
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
    .<name>:delete for flat @expected, @shape;
}
is-deeply @shape, @expected;

is-approx $shaper.text-advance[0], @shape.map(*<ax>).sum;

constant H_Gid = 41;
my $codepoint = $shaper.glyph-from-name('H');
todo "HarfBuzz 2.6.6+ required for reliable glyph names", 2
    unless $version >= v2.6.6;
is $codepoint, H_Gid;
$codepoint ||= H_Gid;
is $shaper.glyph-name($codepoint), 'H';
my $extents = $shaper.glyph-extents($codepoint);
is $extents.x-bearing, 19;
is $extents.y-bearing, 662;
is $extents.width, 683;
is $extents.height, -662;

constant e_Gid = 70;
$codepoint = $shaper.glyph-from-name('e');
todo "HarfBuzz 2.6.6+ required for reliable glyph names", 2
    unless $version >= v2.6.6;
is $codepoint, e_Gid;
$codepoint ||= e_Gid;
is $shaper.glyph-name($codepoint), 'e';
$extents = $shaper.glyph-extents($codepoint);
is $extents.x-bearing, 25;
is $extents.y-bearing, 460;
is $extents.width, 399;
is $extents.height, -470;
