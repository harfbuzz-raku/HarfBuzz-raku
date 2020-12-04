unit class HarfBuzz::Buffer;

use HarfBuzz::Raw;
use HarfBuzz::Raw::Defs :types, :&hb-tag-enc, :hb-direction;
use Method::Also;
use Cairo;

has hb_buffer $.raw is built handles<guess-segment-properties get-length set-length> .= new;
has hb_language $!lang;
has UInt $!script;
has UInt $!direction;
has Str $.text;

submethod TWEAK(Str :$language, :$script, UInt :$direction) {
    $!raw.reference;
    $!raw.add-text($_) with $!text;
    self.guess-segment-properties();
    self.set-language($_) with $language;
    self.set-script($_) with $script;
    self.set-direction($_) with $direction;
}

multi method COERCE(%opts) { self.new: |%opts }

method clear-contents {
    $!raw.clear-contents;
    $!text = '';
}

method get-language { $!raw.get-language.to-string }
method set-language(Str:D $tag) {
    with hb_language.from-string($tag.encode) -> hb_language:D $!lang {
        $!raw.set-language($!lang);
    }
    else {
        warn "unknown language: $tag";
    }
}
method language is rw {
    Proxy.new(
        FETCH => { self.get-language },
        STORE => -> $, Str() $_ {
            self.set-language($_);
        }
    );
}

method length is rw {
    Proxy.new(
        FETCH => { self.get-length },
        STORE => -> $, Int() $_ {
            self.set-length($_);
        }
    );
}

method get-script { $!raw.get-script }
multi method set-script(Str:D $tag) {
    self.set-script(hb-tag-enc($tag));
}
multi method set-script(UInt:D $!script) {
    $!raw.set-script($!script);
}
method script is rw {
    Proxy.new(
        FETCH => { self.get-script },
        STORE => -> $, Str() $_ {
            self.set-script($_);
        }
    );
}

method get-direction { $!raw.get-direction }
multi method set-direction(UInt:D $direction) {
    $!raw.set-direction($direction);
}
method direction is rw {
    Proxy.new(
        FETCH => { self.get-direction },
        STORE => -> $, Int() $_ {
            self.set-direction($_);
        }
    );
}

method is-horizontal { self.get-direction ~~ HB_DIRECTION_LTR | HB_DIRECTION_RTL }
method is-vertical { self.get-direction ~~ HB_DIRECTION_TTB | HB_DIRECTION_BTT }

method cairo-glyphs(Numeric :x($x0) = 0e0, Numeric :y($y0) = 0e0, Numeric :$scale = 1.0) {
    my $elems = $!raw.get-length;
    my Cairo::Glyphs $glyphs .= new: :$elems;
    my $Pos  = $!raw.get-glyph-positions(0);
    my $Info = $!raw.get-glyph-infos(0);
    my Num $x = $x0.Num;
    my Num $y = $y0.Num;
    my $sc := $scale / 64 || die "font scale has not been set";

    for 0 ..^ $elems {
        my hb_glyph_position:D $pos = $Pos[$_];
        my hb_glyph_info:D $info = $Info[$_];
        my Cairo::cairo_glyph_t $glyph = $glyphs[$_];
        $glyph.index = $info.codepoint;
        $glyph.x = $x  +  $pos.x-offset * $sc;
        $glyph.y = $y  +  $pos.y-offset * $sc;

        $x += $pos.x-advance * $sc;
        $y += $pos.y-advance * $sc;
    }
    $glyphs.x-advance = $x - $x0;
    $glyphs.y-advance = $y - $y0;
    $glyphs;
}

method reset {
    $!raw.clear-contents();
    $!raw.add-text($!text);
    $!raw.guess-segment-properties();
    # reapply any explicit settings
    $!raw.set-language($_) with $!lang;
    $!raw.set-script($_) with $!script;
    $!raw.set-direction($_) with $!direction;
}

method get-text { $!text }

method set-text(Str:D $!text) {
    self.reset();
}

method text is rw {
    Proxy.new(
        FETCH => { self.get-text },
        STORE => -> $, Str:D $str {
            self.set-text: $str;
        }
    );
}

submethod DESTROY {
    $!raw.destroy;
}

