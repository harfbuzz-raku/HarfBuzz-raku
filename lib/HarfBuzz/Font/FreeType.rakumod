use HarfBuzz::Font;

unit class HarfBuzz::Font::FreeType
    is HarfBuzz::Font; #| HarfBuzz FreeType bound font data-type

use HarfBuzz::Raw;
use Font::FreeType::Face;
has Font::FreeType::Face:D $.ft-face is required;

submethod TWEAK(:$funcs = True, Num:D() :$size = 12e0, :@scale) {
    unless @scale {
        my uint32 $sc = ($!ft-face.units-per-EM * $size / 32).round;
        self.raw.set-scale($sc, $sc);
    }
    $!ft-face.set-char-size($size);
    self.raw.ft-set-funcs()
        if $funcs;
}

method raw(--> hb_ft_font) handles <ft-set-load-flags ft-get-load-flags ft-font-has-changed> {
    callsame();
}

method ft-load-flags is rw {
    Proxy.new(
        FETCH => { self.ft-get-load-flags },
        STORE => -> $, UInt:D $flags {
            self.ft-set-load-flags($flags);
        }
    );
}

=begin pod

==head2 Synopsis

   use HarfBuzz::Font::FreeType;
   use Font::FreeType::Face;
   my  Font::FreeType::Face .= new: ...;
   my HarfBuzz::Font::FreeType() .= %( :$ft-face, :@features, :$size, :@scale );

=end pod
