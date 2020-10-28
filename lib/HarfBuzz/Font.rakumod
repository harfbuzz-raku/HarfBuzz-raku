unit class HarfBuzz::Font;

use HarfBuzz::Raw;
use HarfBuzz::Face;
has HarfBuzz::Face:D $.face is required;
has hb_font:D $!raw .= new: :face($!face.raw);

submethod TWEAK {
    $!raw.reference;
}

submethod DESTROY {
    $!raw.destroy;
}

method size is rw {
    Proxy.new(
        FETCH => { $!raw.get-size },
        STORE => -> $, Num() $_ {$!raw.set-size($_) }
    );
}
