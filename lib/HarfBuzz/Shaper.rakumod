use HarfBuzz;

#| HarfBuzz shaping object
unit class HarfBuzz::Shaper:ver<0.0.3>
    is HarfBuzz;

use HarfBuzz::Buffer;
use HarfBuzz::Face;
use HarfBuzz::Feature;
use HarfBuzz::Font;
use HarfBuzz::Glyph;
use HarfBuzz::Raw;
use NativeCall;
use Method::Also;
use Cairo;

has HarfBuzz::Buffer() $!buf handles<length language script script-name direction text is-horizontal is-vertical>;
has HarfBuzz::Font() $!font handles<face scale size glyph-name glyph-from-name glyph-extents ft-load-flags features add-features>;
has $!gen = 0; # to detect font/buffer mutation

submethod TWEAK(
    HarfBuzz::Font() :$!font,
    HarfBuzz::Buffer() :$!buf = HarfBuzz::Buffer.new,
) { }

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

#| Returns a set of shaped HarfBuzz::Glyph objects
method shape returns Iterator {
    class Iteration does Iterable does Iterator {
        has UInt $.idx = 0;
        has HarfBuzz::Buffer:D $.buf is required;
        has HarfBuzz::Font:D $.font is required;
        has hb_glyph_position $!Pos = $!buf.raw.get-glyph-positions(0);
        has hb_glyph_info     $!Info = $!buf.raw.get-glyph-infos(0);
        has Numeric @!vec;
        submethod TWEAK {
            @!vec = $!font.scale.map: $!font.raw.get-size / *;
        }
        method iterator { self }
        method pull-one {
            if $!idx < $!buf.length {
                my hb_glyph_position:D $pos = $!Pos[$!idx];
                my hb_glyph_info:D $info = $!Info[$!idx];
                $!idx++;
                my Int:D $codepoint = $info.codepoint;
                my Str:D $name = $!font.glyph-name($codepoint);
                HarfBuzz::Glyph.new: :$pos, :$info, :$name, :$codepoint, :$!buf, :@!vec;
            }
            else {
                IterationEnd;
            }
        }
    }

    Iteration.new: :$.buf, :$!font;
}

#| Return a set of Cairo compatible shaped glyphs
method cairo-glyphs(Numeric :x($x0) = 0e0, Numeric :y($y0) = 0e0, |c) {
    my Cairo::Glyphs $cairo-glyphs .= new: :elems($!buf.length);
    my Cairo::cairo_glyph_t $cairo-glyph;
    my int $i = -1;
    my Num $x = $x0.Num;
    my Num $y = $y0.Num;

    for self.shape(|c) -> $glyph {
        $cairo-glyph = $cairo-glyphs[++$i];
        $cairo-glyph.index = $glyph.codepoint;
        $cairo-glyph.x = $x + $glyph.x-offset;
        $cairo-glyph.y = $y + $glyph.y-offset;
        $x += $glyph.x-advance;
        $y += $glyph.y-advance;
    }

    $cairo-glyphs.x-advance = $x - $x0;
    $cairo-glyphs.y-advance = $y - $y0;

    $cairo-glyphs;
}
=begin pod
=para The return object is typically passed to either the Cairo::Context show_glyphs() or glyph_path() methods
=end pod

#| Returns scaled X and Y displacement of the shaped text
method text-advance returns List {
    my enum <x y>;
    my @vec = @.scale.map: $.size / *;
    my @adv = $.buf.text-advance();
    (
        (@adv[x] * @vec[x]).round(.01),
        (@adv[y] * @vec[y]).round(.01),
    )
}

#| Returns a Hash of scaled glyphs
method ast is also<shaper> returns Seq {
    self.shape.map: *.ast;
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

#| Returns the version of the nativeHarfBuzz library
method version returns Version {
    HarfBuzz::Raw::version();
}

method !reshape {
    $!buf.reset;
    $!font.shape: :$!buf;
    $!gen = $!font.gen + $!buf.gen;
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

=end pod
