unit class HarfBuzz::Set;

use HarfBuzz::Raw;
use HarfBuzz::Raw::Defs :types, :hb-set-value;
use NativeCall;

has hb_set:D $!raw handles<elems> = hb_set::create();
method raw { $!raw }

method exists(UInt:D $i --> Int) {
    $!raw.exists($i).so;
}

method AT-POS(UInt:D $i --> Int) {
    $i < $.elems ?? $!raw.get($i) !! Int
}

method array handles<Array List> {
    my hb_codepoint @to-unicode;
    @to-unicode[$!raw.elems - 1 ] = 0 if $!raw.elems;
    my $buf = nativecast(CArray, @to-unicode);
    $!raw.next-many(HB_SET_VALUE_INVALID, $buf, $!raw.elems);
    @to-unicode;
}

submethod DESTROY { .destroy with $!raw }
