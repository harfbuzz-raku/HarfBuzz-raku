#| Represents a shaped glyph
unit class HarfBuzz::Glyph;

use HarfBuzz::Raw;

has $!buf-ref;
has Str:D $.name is required;
has UInt:D $.gid is required;
has @.vec[2] is required;
has hb_glyph_position $!pos;
has hb_glyph_info     $!info handles<cluster>;

submethod TWEAK(:$!pos!, :$!info!, :buf($buf-ref)!) {}

method codepoint is DEPRECATED<gid> { $!gid }

enum <x y>;
method !scale(\i, \n) {
    (n * @!vec[i]).round(.01);
}

#| Relative/scaled glyph x-advance
method x-advance returns Numeric {
    self!scale: x, $!pos.x-advance;
}
#| Relative/scaled glyph y-advance
method y-advance returns Numeric {
    self!scale: y, $!pos.y-advance;
}
#| Relative/scaled glyph x/y advance
method advance returns Complex { Complex.new: $.x-advance, $.y-advance; }

#| Relative/scaled glyph x offset
method x-offset returns Numeric {
    self!scale: x, $!pos.x-offset;
}
#| Relative/scaled glyph y offset
method y-offset returns Numeric {
    self!scale: y, $!pos.y-offset;
}
#| Relative/scaled glyph x/y offset
method offset returns Complex { Complex.new: $.x-offset, $.y-offset; }

method flags { $!info.get-flags }

#| Glyph hash digest
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
=item I<dx> - pre Y offset
=item I<ax> - post X advance
=item I<ay> - post Y advance
=item I<g>  - Glyph ID
=item I<c>  - Input character position

=end pod
