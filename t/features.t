use Test;
plan 12;
use HarfBuzz::Feature;

my HarfBuzz::Feature $feature .= new: :str("kern=1");

is $feature.tag, 'kern';
is $feature.value, 1;
is $feature.start, 0;
is $feature.end, Inf;

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

