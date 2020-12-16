use Test;
plan 21;
use HarfBuzz;
use HarfBuzz::Feature;

my $version = HarfBuzz.version;
unless $version >= v1.6.0 {
    skip-rest "HarfBuzz version $version is too old to run these tests";
    exit;
}

my HarfBuzz::Feature $feature .= new: :str("kern=1");

is $feature.tag, 'kern';
is $feature.value, 1;
is $feature.start, 0;
is $feature.end, Inf;
is-deeply $feature.enabled, True;

$feature .= new: :str("kern[3;5]");

is $feature.tag, 'kern';
is $feature.value, 1;
is $feature.start, 3;
is $feature.end, 5;

$feature .= new: :tag<kern>, :start(4), :end(6);

is $feature.tag, 'kern';
is $feature.value, 1;
is $feature.start, 4;
is $feature.end, 6;

$feature .= new: :tag<kern>, :!enabled;

is $feature.tag, 'kern';
is $feature.value, 0;
is $feature.start, 0;
is $feature.end, Inf;
is-deeply $feature.enabled, False;
is $feature.Str, '-kern';
$feature.enabled = True;
is-deeply $feature.enabled, True;
is $feature.Str, 'kern';

