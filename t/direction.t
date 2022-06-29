use HarfBuzz;
use HarfBuzz::Shaper;
use HarfBuzz::Raw::Defs :&hb-tag-enc, :&hb-tag-dec, :hb-script, :hb-direction;
use Test;
plan 10;
unless $*RAKU.compiler.version >= v2020.11 {
    die "This version of Raku is too old to use the HarfBuzz semantics";
}
my $file = 't/fonts/NimbusRoman-Regular.otf';
my $direction = HB_DIRECTION_RTL;
my HarfBuzz::Shaper $shaper .= new: :font{ :$file, :size(36), :scale[1000], }, :buf{:text<Hell€!>, :language<epo>, :$direction};
is $shaper.text, 'Hell€!';
is $shaper.size, 36;
is $shaper.scale[0], 1000e0;
is $shaper.length, 6;
is $shaper.language, 'epo';
is $shaper.script, HB_SCRIPT_LATIN;
is $shaper.script, 'Latn';
is $shaper.direction, +HB_DIRECTION_RTL;
my @info = $shaper.shape>>.ast;
my @expected = reverse [
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
    ax => 15.98,
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

my Version $version = HarfBuzz.version;
unless $version >= v2.6.6 {
    # name not available in older HarfBuzz versions
    .<name>:delete for flat @expected, @info;
}
is-deeply @info, @expected;

is-approx $shaper.text-advance[0], @info.map(*<ax>).sum;

