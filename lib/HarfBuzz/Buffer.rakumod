unit class HarfBuzz::Buffer;

use HarfBuzz::Raw;
use HarfBuzz::Raw::Defs :types, :&hb-tag-enc, :&hb-tag-dec, :hb-direction, :hb-buffer-content-type;
use Method::Also;
use Cairo;

has hb_buffer $.raw is built .= new;
has hb_language $!lang;
has UInt $!script;
has UInt $!direction;
has Str $.text;
has UInt $.gen is built;

submethod TWEAK(Str :$language, Str :$script, UInt :$!direction) {
    $!raw.reference;
    self!set-language($_) with $language;
    self!set-script($_) with $script;
    self.reset;
}

multi method COERCE(%opts) { self.new: |%opts }

method clear-contents {
    $!text = '';
    self.reset;
}

method !get-language { $!raw.get-language.to-string }
method !set-language(Str:D $tag) {
    with hb_language.from-string($tag.encode) -> hb_language:D $_ {
        $!lang = $_;
    }
    else {
        warn "unknown language: $tag";
    }
}
method language is rw returns Str {
    Proxy.new(
        FETCH => { self!get-language },
        STORE => -> $, Str() $_ {
            self!set-language($_);
            self.reset;
        }
    );
}

method length is rw returns UInt {
    Proxy.new(
        FETCH => { $!raw.get-length },
        STORE => -> $, Int() $_ {
            $!raw.set-length($_);
            self.reset;
        }
    );
}

method content-type is rw returns UInt {
    Proxy.new(
        FETCH => { $!raw.get-content-type },
        STORE => -> $, Int() $_ {
            $!raw.set-content-type($_);
            self.reset;
        }
    );
}

method !set-script(Str $tag) {
    $!script = hb-tag-enc($tag);
    $!raw.set-script($!script);
}

method script is rw returns Str {
    Proxy.new(
        FETCH => { hb-tag-dec($!raw.get-script) },
        STORE => -> $, Str() $tag {
            self!set-script($tag);
            self.reset;
        }
    );
}

method direction is rw {
    Proxy.new(
        FETCH => { $!raw.get-direction },
        STORE => -> $, Int() $!direction {
            self.reset;
        }
    );
}

method text is rw {
    Proxy.new(
        FETCH => { $!text },
        STORE => -> $, Str $!text {
            self.reset
        }
    );
}

method shaped {
    self.content-type == HB_BUFFER_CONTENT_TYPE_GLYPHS;
}

method is-horizontal { self.get-direction ~~ HB_DIRECTION_LTR | HB_DIRECTION_RTL }
method is-vertical { self.get-direction ~~ HB_DIRECTION_TTB | HB_DIRECTION_BTT }

method cairo-glyphs(Numeric :x($x0) = 0e0, Numeric :y($y0) = 0e0, Numeric :$scale = 1.0) {
    die "buffer has not been shaped"
        unless self.shaped;
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

#| reset the buffer, ready for shaping
method reset {
    $!raw.clear-contents();
    $!raw.add-text($!text);
    $!raw.guess-segment-properties();
    # re-apply any explicit settings
    $!raw.set-language($_) with $!lang;
    $!raw.set-script($_) with $!script;
    $!raw.set-direction($_) with $!direction;
    $!gen++;
}

method text-advance {
    my hb_glyph_position $Pos = self.raw.get-glyph-positions(0);
    my UInt:D $dx = 0;
    my UInt:D $dy = 0;

    for 0 ..^ self.length {
        given $Pos[$_] {
            $dx += .x-advance;
            $dy += .y-advance;
        }
    }

    ($dx, $dy);
}

submethod DESTROY {
    $!raw.destroy;
}

