use HarfBuzz::Shaper;
use Test;
plan 2;

my $version = HarfBuzz::Shaper.version;
if $version < v1.6.0 {
    skip-rest "HarfBuzz::Shaper version is too old";
    exit;
}

my $file := 't/fonts/NimbusRoman-Regular.otf';
my $size := 36;
my $text := 'LVAT';
my HarfBuzz::Shaper $hb .= new: :font{ :$file, :$size,},  :buf{ :$text, :language<epo> };
my @info = $hb.shaper;
my @expected = [
  { ax => 17.86, ay => 0.0, dx => 0.0, dy => 0.0, g => 45, name => 'L' },
  { ax => 21.67, ay => 0.0, dx => 0.0, dy => 0.0, g => 55, name => 'V' },
  { ax => 24.05, ay => 0.0, dx => 0.0, dy => 0.0, g => 34, name => 'A' },
  { ax => 22.00, ay => 0.0, dx => 0.0, dy => 0.0, g => 53, name => 'T' },
];

if $version < v2.6.6 {
    # name not available in older HarfBuzz::Shaper versions
    .<name>:delete for flat @expected, @info;
}
is-deeply @info, @expected, "content default kern";

$hb .= new: :font{ :$file, :$size, :features[ '-kern' ] }, :buf{ :$text, :language<epo>, };
@info = $hb.shaper;

@expected = [
  { ax => 22.00, ay => 0.0, dx => 0.0, dy => 0.0, g => 45, name => 'L' },
  { ax => 25.99, ay => 0.0, dx => 0.0, dy => 0.0, g => 55, name => 'V' },
  { ax => 25.99, ay => 0.0, dx => 0.0, dy => 0.0, g => 34, name => 'A' },
  { ax => 22.00, ay => 0.0, dx => 0.0, dy => 0.0, g => 53, name => 'T' },
];

if HarfBuzz::Shaper.version < v2.6.6 {
    # name not available in older HarfBuzz::Shaper versions
    .<name>:delete for flat @expected, @info;
}
is-deeply @info, @expected, "content default kern";
