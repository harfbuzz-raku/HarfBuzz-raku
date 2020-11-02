unit class HarfBuzz::Font;

use HarfBuzz::Raw;
use HarfBuzz::Buffer;
use HarfBuzz::Face;
use HarfBuzz::Feature;
use NativeCall;

has HarfBuzz::Face:D $.face is required;
has hb_font:D $!raw .= new: :face($!face.raw);

submethod TWEAK(:@scale) {
    $!raw.reference;
    self.scale = @scale if @scale;
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

method scale is rw {
    Proxy.new(
        FETCH => { $!raw.get-scale(my uint32 $x, my uint32 $y); ($x, $y || $x) },
        STORE => -> $, [ $x, $y = $x ] { $!raw.set-scale($x.Int, $y.Int) }
    );
}

method glyph-name(UInt:D $codepoint --> Str) {
    my buf8 $name-buf .= allocate(64);
    my $rv := $!raw.get-glyph-name($codepoint, $name-buf, $name-buf.elems);
    $name-buf.reallocate: (0 ..^ $name-buf.elems).first: {$name-buf[$_] == 0};

    $name-buf.decode;
}

method shape(HarfBuzz::Buffer:D :$buf!, HarfBuzz::Feature :@features) {
    my buf8 $feats-buf .= allocate(nativesizeof(hb_feature) * +@features);
    my hb_feature_array $feats = nativecast(hb_feature_array, $feats-buf);
    for 0 ..^ +@features {
        $feats[$_].copy: @features[$_].raw;
    }
    $!raw.shape($buf.raw, $feats, +@features);
}
