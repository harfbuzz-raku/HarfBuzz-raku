 #| HarfBuzz font data-type
unit class HarfBuzz::Font;

use HarfBuzz::Raw;
use HarfBuzz::Raw::Defs :types;
use HarfBuzz::Buffer;
use HarfBuzz::Face;
use HarfBuzz::Feature;
use NativeCall;

has HarfBuzz::Face $.face handles<Blob>;
has hb_font $.raw is required;
has HarfBuzz::Feature() @.features is built;
has UInt $.gen is built; # mutation generation

=begin pod

=head2 Synopsis

   use HarfBuzz::Font;
   my HarfBuzz::Font() .= %( :$file, :@features, :$size, :@scale );

=head2 Description

A HarfBuzz font is used for shaping text (See class L<HarfBuzz::Shaper>).

Fonts may also be subsetted (Reduced to a smaller set of glyphs; see module L<HarfBuzz::Subset>).

=head2 Methods

=end pod

submethod TWEAK(:@scale, Num() :$size=12e0, :@!features) {
    $!raw.reference;
    if @scale {
        self.scale = @scale
    }
    else {
        $!raw.get-scale(my int32 $x, my int32 $y);
        if $x == 0 || $y == 0 {
            $x ||= 2048;
            $y ||= $x;
            $!raw.set-scale($x, $y);
        }
    }
    $!raw.set-size($size) if $size;
    $!gen = 1;
}

submethod DESTROY {
    $!raw.destroy;
}

multi method COERCE(% ( Str:D :$file!, :$ft-face, :@features, |opts) ) {
    warn "ignoring ':ft-face' option; reserved for HarfBuzz::Font::FreeType" with $ft-face;
    my HarfBuzz::Face() $face = $file;
    my hb_font $raw = hb_font::create($face.raw);
    self.new: :$raw, :$face, :@features, |opts;
}

#| Gets or sets x and y scale
method scale is rw returns List {
    Proxy.new(
        FETCH => { $!raw.get-scale(my int32 $x, my int32 $y); ($x, $y || $x) },
        STORE => -> $, [ $x, $y = $x ] {
            $!gen++;
            $!raw.set-scale($x.Int, $y.Int);
        }
    );
}

#| Gets or sets the font size
method size is rw returns Numeric {
    Proxy.new(
        FETCH => { $!raw.get-size },
        STORE => -> $, Num:D() $_ {
            $!gen++;
            $!raw.set-size($_);
        }
    );
}

#| Add font features
method add-features(HarfBuzz::Feature() @features --> Array[HarfBuzz::Feature]) {
    $!gen++;
    @!features.append: @features;
}

#| Returns the glyph name for a glyph identifier
method glyph-name(UInt:D $gid --> Str) {
    my buf8 $name-buf .= allocate(64);
    $!raw.get-glyph-name($gid, $name-buf, $name-buf.elems);
    $name-buf.reallocate: HarfBuzz::Raw::CLib::strnlen($name-buf, $name-buf.bytes);

    $name-buf.decode;
}

#| Returns the glyph identifier for a given glyph name
method glyph-from-name(Str:D $name --> UInt) {
    my Blob $buf = $name.encode;
    my hb_codepoint $gid;
    $!raw.get-glyph-from-name($buf, $buf.bytes, $gid);
    $gid;
}

#| Returns metrics for a glyph
method glyph-extents(UInt:D $gid --> hb_glyph_extents) {
    my hb_glyph_extents $glyph-extents .= new;
    $!raw.get-glyph-extents($gid, $glyph-extents);
    $glyph-extents;
}
=begin pod
=para Note that `hb_glyph_extents` is a `CStruct` with `Num` attributes `x-advance`, `y-advance`, `x-offset` and `y-offset`.

=end pod

#| Shape a buffer using this font
method shape(HarfBuzz::Buffer:D :$buf!) {
    $buf.reset if $buf.shaped;
    my buf8 $feats-buf .= allocate(nativesizeof(hb_feature) * +@!features);
    my hb_features $feats = nativecast(hb_features, $feats-buf);
    $feats[.key] = .value.raw for @!features.pairs;
    $!raw.shape($buf.raw, $feats, +@!features);
}

