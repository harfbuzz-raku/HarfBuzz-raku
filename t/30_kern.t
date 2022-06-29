use HarfBuzz;
use HarfBuzz::Shaper;
use Test;
plan 2;

my $file := 't/fonts/NimbusRoman-Regular.otf';
my $size := 36;
my $text := 'LVAT';
my HarfBuzz::Shaper $hb .= new: :font{ :$file, :$size,},  :buf{ :$text, :language<epo> };
my @info = $hb.shaper;
my @expected = [
  { c => 0, ax => 17.86, ay => 0.0, dx => 0.0, dy => 0.0, g => 45, name => 'L' },
  { c => 1, ax => 21.67, ay => 0.0, dx => 0.0, dy => 0.0, g => 55, name => 'V' },
  { c => 2, ax => 24.05, ay => 0.0, dx => 0.0, dy => 0.0, g => 34, name => 'A' },
  { c => 3, ax => 22.00, ay => 0.0, dx => 0.0, dy => 0.0, g => 53, name => 'T' },
];

my Version $version = HarfBuzz.version;
if $version < v2.6.6 {
    # name not available in older HarfBuzz::Shaper versions
    .<name>:delete for flat @expected, @info;
}
is-deeply @info, @expected, "content default kern";

$hb .= new: :font{ :$file, :$size, :features[ '-kern' ] }, :buf{ :$text, :language<epo>, };
@info = $hb.shaper;

@expected = [
  { c => 0, ax => 22.00, ay => 0.0, dx => 0.0, dy => 0.0, g => 45, name => 'L' },
  { c => 1, ax => 25.99, ay => 0.0, dx => 0.0, dy => 0.0, g => 55, name => 'V' },
  { c => 2, ax => 25.99, ay => 0.0, dx => 0.0, dy => 0.0, g => 34, name => 'A' },
  { c => 3, ax => 22.00, ay => 0.0, dx => 0.0, dy => 0.0, g => 53, name => 'T' },
];

if HarfBuzz::Shaper.version < v2.6.6 {
    # name not available in older HarfBuzz::Shaper versions
    .<name>:delete for flat @expected, @info;
}
is-deeply @info, @expected, "content default kern";
