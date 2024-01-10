#| HarfBuzz shaping object
unit class HarfBuzz::Shaper;

use HarfBuzz;
also is HarfBuzz;

use HarfBuzz::Buffer;
use HarfBuzz::Face;
use HarfBuzz::Feature;
use HarfBuzz::Font;
use HarfBuzz::Glyph;
use HarfBuzz::Raw;
use NativeCall;
use Method::Also;

has HarfBuzz::Buffer() $!buf handles<length language script script-name direction text is-horizontal is-vertical>;
has HarfBuzz::Font() $!font handles<face scale size glyph-name glyph-from-name glyph-extents ft-load-flags features add-features>;
has hb_glyph_positions $!Pos;
has uint32 $!Pos-elems;
has hb_glyph_infos     $!Info;
has uint32 $!Info-elems;
has Numeric @!vec;
has $!gen = 0; # to detect font/buffer mutation
has HarfBuzz::Glyph @!glyphs;

submethod TWEAK(
    HarfBuzz::Font() :$!font,
    HarfBuzz::Buffer() :$!buf = HarfBuzz::Buffer.new,
) {
    @!vec = $!font.scale.map: $!font.raw.get-size / *;
}

method elems { $.buf.length }

#| Gets or sets the font
method font is rw returns HarfBuzz::Font {
    Proxy.new(
        FETCH => { $!font },
        STORE => -> $, $!font {
            $!gen = 0;
        }
    )
}

#| Gets or sets the shaping buffer
method buf is rw returns HarfBuzz::Buffer {
    Proxy.new(
        FETCH => {
            self!reshape()
                unless $!gen == $!buf.gen + $!font.gen;
            $!buf;
        },
        STORE => -> $, $!buf {
            $!gen = 0;
        }
    )
}

method AT-POS(UInt $idx) {
    @!glyphs[$idx] //= do {
        self.buf; # enure shaping is up-to-date
        my HarfBuzz::Glyph $glyph;
        if $idx < $.buf.length {
            my hb_glyph_position:D $pos = $!Pos[$idx]
                if $idx < $!Pos-elems;
            my hb_glyph_info:D $info = $!Info[$idx]
                if $idx < $!Info-elems;
            my hb_glyph_extents $extents .= new;
            my Int:D $gid = $info.codepoint;
            my Str:D $name = $!font.glyph-name($gid);
            $!font.raw.get-glyph-extents($gid, $extents);
            $glyph .= new: :$pos, :$info, :$name, :$gid, :$!buf, :$extents, :@!vec;
        }
        $glyph;
    }
}

#| Returns a set of shaped HarfBuzz::Glyph objects
method glyphs(HarfBuzz::Shaper:D $obj:) is also<shape> returns Iterator {
    my class Iteration does Iterable does Iterator {
        has HarfBuzz::Shaper:D $.obj is required;
        has UInt $.elems = $!obj.elems;
        has UInt $.idx = 0;

        method iterator { self }
        method pull-one {
            if $!idx < $!elems {
                $obj.AT-POS: $!idx++;
            }
            else {
                IterationEnd;
            }
        }
    }

    Iteration.new: :$obj;
}

method clusters(HarfBuzz::Shaper:D $obj:) returns Iterator {
    my class Iteration does Iterable does Iterator {
        has HarfBuzz::Shaper:D $.obj is required;
        has UInt $.elems = $!obj.elems;
        has UInt $.idx = 0;

        method iterator { self }
        method pull-one {
            my $c = .cluster with $obj.AT-POS($!idx);
            my HarfBuzz::Glyph @cluster;
            while $!idx < $!elems {
                my HarfBuzz::Glyph $glyph := $obj.AT-POS($!idx++);
                last unless $c == $glyph.cluster;
                @cluster.push: $glyph;
            }
            @cluster || IterationEnd;
        }
    }

    Iteration.new: :$obj;
}

#| Returns scaled X and Y displacement of the shaped text
method text-advance returns List {
    my @vec[2] = @.scale.map: $.size / *;
    my @adv[2] = $.buf.text-advance();
    (@vec Z* @adv)>>.round(.01);
}

#| Returns a Hash sequence of scaled glyphs
method ast is also<shaper> returns List {
    self.shape».ast.List;
}
=begin pod

Entries are:

=item  `ax`:   horizontal advance
=item  `ay`:   vertical advance
=item  `dx`:   horizontal offset
=item  `dy`:   vertical offset
=item  `g`:    glyph index in font (CId)
=item  `name`: glyph name

=end pod

method !reshape {
    $!buf.reset;
    $!font.shape: :$!buf;
    $!gen = $!font.gen + $!buf.gen;
    $!Pos = $!buf.raw.get-glyph-positions($!Pos-elems);
    $!Info = $!buf.raw.get-glyph-infos($!Info-elems);
    @!vec = $!font.scale.map: $!font.raw.get-size / *;
    @!glyphs = ();
}

=begin pod

=head3 size

  method size(--> Num) is rw;

Get or set the font size used for shaping.

Note that the font size will in general affect details of the appearance, A 5 point fontsize magnified 10 times is not identical to 50 point font size.

=head3 text

  method text(--> Str) is rw;

Gets or sets the text to shape.

=head3 features

  method features(--> HarfBuzz::Feature() @)

Get shaping features.

=head3 add-features

  method add-features(HarfBuzz::Feature() @features)

Add specified features are added to the set of persistent features.
Features may be added as HarfBuzz::Feature objects, or coerced from strings as described in https://harfbuzz.github.io/harfbuzz-hb-common.html#hb-feature-from-string and https://css-tricks.com/almanac/properties/f/font-feature-settings/#values.

=head3 language

  method language returns Str is rw

Gets or sets the language for shaping. The language must be a string containing a valid BCP-47 language code.

=head3 script

  method script returns Str is rw

Gets or sets the script (alphabet) for shaping.

script must be a string containing a valid ISO-15924 script code. For example, "Latn" for the Latin (Western European) script, or "Arab" for arabic script.

=head3 direction

  use HarfBuzz::Raw::Defs :hb-direction;
  method direction returns UInt is rw;

Gets or sets the direction for shaping: `HB_DIRECTION_LTR` (left-to-right),  `HB_DIRECTION_RTL` (right-to-left), `HB_DIRECTION_TTB` (top-to-bottom), or `HB_DIRECTION_BTT` (bottom-to-top).

If you don't set a direction, HarfBuzz::Shaper will make a guess based on the text string. This may or may not yield desired results.

=head3 AT-KEY

    method AT-KEY(Int $pos) returns HarfBuzz::Glyph
    say "last glyph: " ~ $shaper[$shaper.elems -1].name;

=end pod
