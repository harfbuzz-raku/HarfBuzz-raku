unit class HarfBuzz::Map;

use HarfBuzz::Set;
use HarfBuzz::Raw;
use HarfBuzz::Raw::Defs :types;

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

method exists(UInt:D $i --> Int) {
    $!raw.exists($i).so;
}

method AT-POS(UInt:D $i --> Int) {
    $i < $.elems ?? $!raw.get($i) !! Int
}

submethod DESTROY { .destroy with $!raw }
