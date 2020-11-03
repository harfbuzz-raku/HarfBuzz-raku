use HarfBuzz;
use Test;
plan 1;

my $version = HarfBuzz.version;
if $version < v1.6.0 {
    skip-rest "HarfBuzz version is too old";
    exit;
}

my $file = 't/fonts/Lohit-Devanagari.ttf';
my $size = 36;
my $text =
  "\c[DEVANAGARI LETTER TA]"~
  "\c[DEVANAGARI LETTER MA]"~
  "\c[DEVANAGARI VOWEL SIGN AA]"~
  "\c[DEVANAGARI LETTER NGA]"~
  "\c[DEVANAGARI SIGN VIRAMA]"~
  "\c[DEVANAGARI LETTER GA]";

my HarfBuzz $hb .= new: :$file, :$size, :$text, :lang<epo>;
my @info = $hb.glyphs>>.ast;

my @expected = [
  {
    ax => 21.35,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 341,
    name => 'tadeva',
  },
  {
    ax => 20.34,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 351,
    name => 'madeva',
  },
  {
    ax => 9.32,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 367,
    name => 'aasigndeva',
  },
  {
    ax => 23.90,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 611,
    name => 'ngadeva_viramadeva_gadeva',
  },
];

unless $version >= v2.6.4 {
    # advance-x older HarfBuzz versions
    .<ax>:delete for flat @expected, @info;
}
unless $version >= v2.6.6 {
    # names not avaiable in older HarfBuzz versions
    .<name>:delete for flat @expected, @info;
}

is-deeply @info, @expected;
