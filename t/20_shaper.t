use HarfBuzz::Shaper;
use Test;
plan 6;

my $file = 't/fonts/Lohit-Devanagari.ttf';
my $size = 36;
my $text =
  "\c[DEVANAGARI LETTER TA]"~
  "\c[DEVANAGARI LETTER MA]"~
  "\c[DEVANAGARI VOWEL SIGN AA]"~
  "\c[DEVANAGARI LETTER NGA]"~
  "\c[DEVANAGARI SIGN VIRAMA]"~
  "\c[DEVANAGARI LETTER GA]"~
  "!";
my HarfBuzz::Buffer $buf .= new: :$text;
nok $buf.shaped;
my HarfBuzz::Shaper $hb .= new: :font{ :$file, :$size}, :$buf;
nok $buf.shaped;
my @shape = $hb.shape>>.ast;
ok $buf.shaped;

is-deeply $hb.scale, (1024, 1024);
is-deeply $hb.size, $size.Num;

my @expected = [
  {
    c => 0,
    ax => 21.38,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 341,
    name => 'tadeva',
  },
  {
    c => 1,
    ax => 20.36,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 351,
    name => 'madeva',
  },
  {
    c => 1,
    ax => 9.35,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 367,
    name => 'aasigndeva',
  },
  {
    c => 3,
    ax => 23.91,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 611,
    name => 'ngadeva_viramadeva_gadeva',
  },
  {
    c => 6,
    ax => 10.51,
    ay => 0.0,
    dx => 0.0,
    dy => 0.0,
    g => 4,
    name => "exclam",
  }
];

my $version = HarfBuzz::Shaper.version;

unless $version >= v2.6.4 {
    # advance-x not available older HarfBuzz::Shaper versions
    .<ax>:delete for flat @expected, @shape;
}
unless $version >= v2.6.6 {
    # names not available in older HarfBuzz::Shaper versions
    .<name>:delete for flat @expected, @shape;
}

is-deeply @shape, @expected;
