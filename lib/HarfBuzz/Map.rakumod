unit class HarfBuzz::Map;

use HarfBuzz::Set;
use HarfBuzz::Raw;
use HarfBuzz::Raw::Defs :types, :hb-set-value;

has hb_map:D $!raw handles<elems> = hb_map::create();
method raw { $!raw }

method keys {
    given HarfBuzz::Set.new {
        $!raw.keys(.raw);
        $_;
    }
}

method values {
    given HarfBuzz::Set.new {
        $!raw.values(.raw);
        $_;
    }
}

method exists(UInt:D() $k --> Int) {
    $!raw.exists($k).so;
}

method AT-KEY(UInt:D() $k --> Int) {
    my $v := $!raw.get($k);
    $v == HB_SET_VALUE_INVALID ?? Int !! $v;
}

submethod DESTROY { .destroy with $!raw }
