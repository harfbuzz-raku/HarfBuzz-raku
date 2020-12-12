unit class HarfBuzz::Font; #| HarfBuzz core font data-type

use HarfBuzz::Raw;
use HarfBuzz::Raw::Defs :types;
use HarfBuzz::Buffer;
use HarfBuzz::Face;
use HarfBuzz::Feature;
use Font::FreeType::Face;
use NativeCall;

has HarfBuzz::Face $.face handles<Blob>;
has hb_font $.raw is required handles<get-size set-size>;
has HarfBuzz::Feature() @.features;

submethod TWEAK(:@scale, Num() :$size=12e0) {
    $!raw.reference;
    if @scale {
        self.scale = @scale
    }
    else {
        $!raw.get-scale(my uint32 $x, my uint32 $y);
        if $x == 0 || $y == 0 {
            $x ||= 2048;
            $y ||= $x;
            $!raw.set-scale($x, $y);
        }
    }
    self.set-size($size) if $size;
}

submethod DESTROY {
    $!raw.destroy;
}

multi method COERCE(% ( Font::FreeType::Face:D :$ft-face!, :$file, :@features, |opts) ) {
    warn "ignoring ':file' option" with $file;
    my hb_ft_font $raw = hb_ft_font::create($ft-face.raw);
    my HarfBuzz::Face() $face = $raw.get-face();
    (require ::('HarfBuzz::Font::FreeType')).new(:$raw, :$face, :$ft-face, :@features, |opts)
}

multi method COERCE(% ( Str:D :$file!, :@features, |opts) ) {
    my HarfBuzz::Face() $face = $file;
    my hb_font $raw = hb_font::create($face.raw);
    self.new: :$raw, :$face, :@features, |opts;
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

=begin pod

==head2 Synopsis

   use HarfBuzz::Font;
   my HarfBuzz::Font() .= %( :$file, :@features, :$size, :@scale );

=end pod
