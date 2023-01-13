#| HarfBuzz Text Buffer
unit class HarfBuzz::Buffer;

=begin pod

=head2 Synopsis

  use HarfBuzz::Buffer;
  use HarfBuzz::Font;
  my HarfBuzz::Buffer $buf .= new: :text("Hello"), :lang<en>;
  say $font.shaped; # False
  my HarfBuzz::Font $font .= new: :file<t/fonts/NimbusRoman-Regular.otf>;
  $font.shape: :$buf;
  say $font.shaped; # True

=head2 Description

A HarfBuzz::Buffer contains text and other shaping context properties, include language, script and writing direction.

It is normally shaped by calling the shape method from a font.

=end pod

use HarfBuzz::Raw;
use HarfBuzz::Raw::Defs :types, :&hb-tag-enc, :&hb-tag-dec, :hb-direction, :hb-buffer-content-type;
use Method::Also;

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
#| get or set the language.
method language is rw returns Str {
    Proxy.new(
        FETCH => { self!get-language },
        STORE => -> $, Str() $_ {
            self!set-language($_);
            self.reset;
        }
    );
}

#| get the length of the buffer
method length is rw returns UInt {
    Proxy.new(
        FETCH => { $!raw.get-length },
        STORE => -> $, Int() $_ {
            $!raw.set-length($_);
            self.reset;
        }
    );
}

method !content-type is rw returns UInt {
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

# Gets or sets the script (alphabet) for shaping.
method script is rw returns Str {
    Proxy.new(
        FETCH => { hb-tag-dec($!raw.get-script) },
        STORE => -> $, Str() $tag {
            self!set-script($tag);
            self.reset;
        }
    );
}
=begin pod

=para script must be a string containing a valid ISO-15924 script code. For example, "Latn" for the Latin (Western European) script, or "Arab" for arabic script.

=end pod

#| Get or set the text direction
method direction is rw {
    Proxy.new(
        FETCH => { $!raw.get-direction },
        STORE => -> $, Int() $!direction {
            self.reset;
        }
    );
}
=begin pod

  use HarfBuzz::Raw::Defs :hb-direction;
  $buf.direction = HB_DIRECTION_RTL; # right-to-left

Direction should be `HB_DIRECTION_LTR` (left-to-right),  `HB_DIRECTION_RTL` (right-to-left), `HB_DIRECTION_TTB` (top-to-bottom), or `HB_DIRECTION_BTT` (bottom-to-top).

=end pod

#| Get or set the text to shape
method text is rw {
    Proxy.new(
        FETCH => { $!text },
        STORE => -> $, Str $!text {
            self.reset
        }
    );
}

#| Check if the buffer has been shaped.
method shaped returns Bool {
    $!raw.get-content-type == HB_BUFFER_CONTENT_TYPE_GLYPHS;
}
=begin pod

=para A buffer is shaped by calling the `shape()` method from a L<HarfBuzz::Font> object.

Note that a buffer needs to be reshaped after updating its properties, including text, language, script or direction.

See also L<HarfBuzz::Shaper>, which manages a font/buffer pairing for you.

=end pod


#| True if the writing direction is left-to-right or right-to-left
method is-horizontal returns Bool { $!raw.get-direction ~~ HB_DIRECTION_LTR | HB_DIRECTION_RTL }

#| True if the writing direction is top-to-bottom or bottom-to-top
method is-vertical returns Bool { $!raw.get-direction ~~ HB_DIRECTION_TTB | HB_DIRECTION_BTT }

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

#| Return the unscaled x and y displacement of the shaped text
method text-advance returns List {
    my uint32 $length;
    die "buffer has not been shaped"
        unless self.shaped;
    my hb_glyph_positions $Pos = self.raw.get-glyph-positions($length);
    my UInt:D $dx = 0;
    my UInt:D $dy = 0;

    for ^$length {
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

