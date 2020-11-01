unit class HarfBuzz::Buffer;

use HarfBuzz::Raw;
use HarfBuzz::Glyph;

has hb_buffer $.raw is built handles<guess-segment-properties length> .= new;

method add-text(Str:D $str, UInt :$offset = 0) {
    my $utf8 = $str.encode;
    $!raw.add-utf8($utf8, $utf8.elems, $offset, $utf8.elems);
}

submethod TWEAK {
    $!raw.reference;
}

submethod DESTROY {
    $!raw.destroy;
}

