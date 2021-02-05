#| Represents a shaped glyph
unit class HarfBuzz::Glyph;

use HarfBuzz::Raw;

has $.buf is required;
has Str:D $.name is required;
has UInt:D $.codepoint is required;
has @.vec[2] is required;
has hb_glyph_position $!pos;
has hb_glyph_info     $!info;

submethod TWEAK(:$!pos!, :$!info!) {}

enum <x y>;
method !scale(\i, \n) {
    (n * @!vec[i]).round(.01);
}

#| Relative/scaled glyph x-advance
method x-advance returns Numeric {
    self!scale(x, $!pos.x-advance);
}
#| Relative/scaled glyph y-advance
method y-advance returns Numeric {
    self!scale(y, $!pos.y-advance);
}
#| Relative/scaled glyph x/y advance
method advance returns Complex { Complex.new( $.x-advance, $.y-advance ); }

#| Relative/scaled glyph x offset
method x-offset returns Numeric {
    self!scale(x, $!pos.x-offset);
}
#| Relative/scaled glyph y offset
method y-offset returns Numeric {
    self!scale(y, $!pos.y-offset);
}
#| Relative/scaled glyph x/y offset
method offset returns Complex { Complex.new( $.x-offset, $.y-offset ); }

#| Glyph hash digest
has %!ast;
method ast handles<AT-KEY keys> {
    %!ast ||= %(
        :$!name, ax => $.x-advance, ay => $.y-advance,
        g => $!info.codepoint, dx => $.x-offset, dy => $.y-offset,
    );
}
=begin pod
=para Of the form `%( :$ax, :$ay, :$dx, :$dy, :g($gid))`
=end pod
