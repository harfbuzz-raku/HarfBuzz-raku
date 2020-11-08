use HarfBuzz;
use HarfBuzz::Raw::Defs :&hb-tag-enc, :&hb-tag-dec, :hb-script, :hb-direction;
use Test;
plan 10;
my Version $version;
lives-ok { $version = HarfBuzz.version }, 'got version';
note "HarfBuzz version is $version (bindings {HarfBuzz.^ver})";

if $version < v1.6.0 {
    skip-rest "HarfBuzz version is too old";
    exit;
}

is hb-tag-dec(hb-tag-enc('post')), 'post';

my $file = 't/fonts/NimbusRoman-Regular.otf';
my HarfBuzz $hb .= new: :$file, :size(36), :scale[1000], :text<Hell€!>, :lang<epo>;
is $hb.size, 36;
is $hb.scale[0], 1000;
is $hb.length, 6;
is $hb.lang, 'epo';
is $hb.script, +HB_SCRIPT_LATIN;
is $hb.script.&hb-tag-dec, 'Latn';
is $hb.direction, +HB_DIRECTION_LTR;
my @info = $hb.glyphs>>.ast;
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
