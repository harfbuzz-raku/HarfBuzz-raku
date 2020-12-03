unit class HarfBuzz::Font;

use HarfBuzz::Raw;
use HarfBuzz::Raw::Defs :types;
use HarfBuzz::Buffer;
use HarfBuzz::Face;
use HarfBuzz::Feature;
use Font::FreeType::Face;
use NativeCall;

has HarfBuzz::Face $.face handles<Blob>;
has hb_font $.raw is required;
has HarfBuzz::Feature() @.features;

submethod TWEAK(:@scale, Numeric :$size) {
    $!raw.reference;
    self.scale = @scale if @scale;
    self.size = $size if $size;
}

submethod DESTROY {
    $!raw.destroy;
}

multi method COERCE(%font ( :@scale, Numeric :$size=12, :@features, Str :$file, Font::FreeType::Face :$ft-face) ) {
    if $ft-face.defined {
        warn "ignoring ':file' option" with $file;
        $ft-face.set-char-size($size);
        my hb_ft_font $raw = hb_ft_font::create($ft-face.raw);
        my HarfBuzz::Face() $face = $raw.get-face();
        (require ::('HarfBuzz::Font::FreeType')).new(:$raw, :$face, :$ft-face, :@scale, :$size, :@features);
    }
    else {
        my HarfBuzz::Face() $face = $file;
        my hb_font $raw = hb_font::create($face.raw);
        self.new(:$raw, :$face, :@scale, :$size, :@features);
    }

}

method size is rw {
    Proxy.new(
        FETCH => { $!raw.get-size },
        STORE => -> $, Num() $_ { $!raw.set-size($_) }
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
    $!raw.get-glyph-name($codepoint, $name-buf, $name-buf.elems);
    $name-buf.reallocate: (0 ..^ $name-buf.elems).first: {$name-buf[$_] == 0};

    $name-buf.decode;
}

method glyph-from-name(Str:D $name) {
    my Blob $buf = $name.encode;
    my hb_codepoint $codepoint;
    $!raw.get-glyph-from-name($buf, $buf.bytes, $codepoint);
    $codepoint;
}

method glyph-extents(UInt:D $codepoint) {
    my hb_glyph_extents $glyph-extents .= new;
    $!raw.get-glyph-extents($codepoint, $glyph-extents);
    $glyph-extents;
}

method shape(HarfBuzz::Buffer:D :$buf!) {
    my buf8 $feats-buf .= allocate(nativesizeof(hb_feature) * +@!features);
    my hb_features $feats = nativecast(hb_features, $feats-buf);
    $feats[.key] = .value.raw for @!features.pairs;
    $!raw.shape($buf.raw, $feats, +@!features);
}
