use HarfBuzz::Font;

unit class HarfBuzz::Font::FreeType
    is HarfBuzz::Font;

use HarfBuzz::Raw;
use Font::FreeType::Face;
has Font::FreeType::Face:D $.ft-face is required;

submethod TWEAK(:$funcs = True, UInt:D :$size = 12) {
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
