unit class HarfBuzz::Glyph;

use HarfBuzz::Raw;

has $.buf is required;
has Str:D $.name is required;
has @.vec is required;
has hb_glyph_position $!pos;
has hb_glyph_info     $!info;

submethod TWEAK(:$!pos!, :$!info!) {}

enum <x y>;
method vec(\i, \n) {
    (n * @!vec[i]).round(.01);
}

method x-advance {
    $.vec(x, $!pos.x-advance);
}
method y-advance {
    $.vec(y, $!pos.y-advance);
}

method x-offset {
    $.vec(x, $!pos.x-offset);
}
method y-offset {
    $.vec(y, $!pos.y-offset);
}

method ast {
    %(
        :$!name, ax => $.x-advance, ay => $.y-advance,
        g => $!info.codepoint, dx => $.x-offset, dy => $.y-offset,
    );
}
