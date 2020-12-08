use HarfBuzz;

unit class HarfBuzz::Shaper:ver<0.0.1>
    is HarfBuzz;

use HarfBuzz::Buffer;
use HarfBuzz::Face;
use HarfBuzz::Feature;
use HarfBuzz::Font;
use HarfBuzz::Glyph;
use HarfBuzz::Raw;
use NativeCall;
use Method::Also;

has HarfBuzz::Buffer() $!buf handles<length language lang script direction get-text cairo-glyphs is-horizontal is-vertical>;
has HarfBuzz::Font() $!font handles<face scale glyph-name glyph-from-name glyph-extents ft-load-flags features>;

submethod TWEAK( HarfBuzz::Font() :$!font, HarfBuzz::Buffer() :$!buf = HarfBuzz::Buffer.new) {
    self.reset
}

method buf is rw {
    Proxy.new(
        FETCH => { $!buf },
        STORE => -> $, $!buf {
            self.reset;
        }
    )
}

method font is rw {
    Proxy.new(
        FETCH => { $!font },
        STORE => -> $, $!font {
            $!buf.reset;
            self.reset;
        }
    )
}

method shape {
    class Iteration does Iterable does Iterator {
        has UInt $.idx = 0;
        has HarfBuzz::Buffer:D $.buf is required;
        has HarfBuzz::Font:D $.font is required;
        has hb_glyph_position $!Pos = $!buf.raw.get-glyph-positions(0);
        has hb_glyph_info     $!Info = $!buf.raw.get-glyph-infos(0);
        method iterator { self }
        method pull-one {
            if $!idx < $!buf.length {
                my hb_glyph_position:D $pos = $!Pos[$!idx];
                my hb_glyph_info:D $info = $!Info[$!idx];
                $!idx++;
                my @vec = $!font.scale.map: $!font.get-size / *;
                my Str:D $name = $!font.glyph-name($info.codepoint);
                HarfBuzz::Glyph.new: :$pos, :$info, :$name, :$!buf, :@vec;
            }
            else {
                IterationEnd;
            }
        }
    }
    Iteration.new: :$!buf, :$!font;
}

method measure {
    my hb_glyph_position $Pos = $!buf.raw.get-glyph-positions(0);
    my UInt:D ($dx, $dy);
    my @vec = @.scale.map: $.size / *;
    my enum <x y>;

    for 0 ..^ $!buf.length {
        given $Pos[$_] {
            $dx += .x-advance;
            $dy += .y-advance;
        }
    }
    Complex.new(($dx * @vec[x]).round(.01), ($dy * @vec[y]).round(.01));
}

method ast is also<shaper> {
    self.shape.map: *.ast;
}

method version {
    HarfBuzz::Raw::version();
}

method reset {
    $!font.shape: :$!buf;
}    

method set-text(Str:D $text) {
    $!buf.set-text: $text;
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

method size is rw {
    Proxy.new(
        FETCH => { $!font.get-size },
        STORE => -> $, Num() $_ {
            $!font.set-size($_);
            $!buf.reset;
            self.reset;
        }
    );
}

