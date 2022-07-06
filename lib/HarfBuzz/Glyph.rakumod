#| Represents a shaped glyph
unit class HarfBuzz::Glyph;

use HarfBuzz::Raw;

has $!buf-ref;
has Str:D $.name is required;
has UInt:D $.gid is required;
has @.vec[2] is required;
has hb_glyph_position:D $.pos is required;
has hb_glyph_info:D     $.info is required handles<cluster>;
has hb_glyph_extents:D  $.extents is required;

submethod TWEAK(:buf($buf-ref)!) {}

method codepoint is DEPRECATED<gid> { $!gid }

enum <x y>;
method !x-scale(\n) {
    (n * @!vec[x]).round(.01);
}
method !y-scale(\n) {
    (n * @!vec[y]).round(.01);
}

#| Relative/scaled glyph x-advance
method x-advance returns Numeric {
    self!x-scale: $!pos.x-advance;
}
#| Relative/scaled glyph y-advance
method y-advance returns Numeric {
    self!y-scale: $!pos.y-advance;
}
#| Relative/scaled glyph x/y advance
method advance returns Complex { Complex.new: $.x-advance, $.y-advance; }

#| Relative/scaled glyph x offset
method x-offset returns Numeric {
    self!x-scale: $!pos.x-offset;
}
#| Relative/scaled glyph y offset
method y-offset returns Numeric {
    self!y-scale: $!pos.y-offset;
}

#| Relative/scaled glyph x/y offset
method offset returns Complex { Complex.new: $.x-offset, $.y-offset; }

#| left side of glyph from origin
method x-bearing returns Numeric {
    self!x-scale: $!extents.x-bearing;
}

#| top side of glyph from origin
method y-bearing returns Numeric {
    self!y-scale: $!extents.y-bearing;
}

#| position of glyph from origin
method bearing returns Complex { Complex.new: $.x-bearing, $.y-bearing; }

method width returns Numeric {
    self!x-scale: $!extents.width;
}

method height returns Numeric {
    self!y-scale: $!extents.height;
}

#| size of glyph
method size returns Complex { Complex.new: $.width, $.height; }

method flags { $!info.get-flags }

#| Glyph summary hash
has %!ast;
method ast handles<AT-KEY keys> {
    %!ast ||= %(
        :$!name, ax => $.x-advance, ay => $.y-advance,
        g => $!info.codepoint, dx => $.x-offset, dy => $.y-offset,
        c => $!info.cluster,
    );
}
=begin pod
=para Of the form `%( :$ax, :$ay, :$dx, :$dy, :g($gid), :$c)`

where

=item I<dx> - pre X offset
=item I<dy> - pre Y offset
=item I<ax> - post X advance
=item I<ay> - post Y advance
=item I<g>  - Glyph ID
=item I<c>  - Input character position

=end pod
