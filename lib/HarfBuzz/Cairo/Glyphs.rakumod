unit class HarfBuzz::Cairo::Glyphs;

use Cairo;
use NativeCall;
use HarfBuzz::Buffer;

has int32 $.elems is built;
has buf8 $.raw; #  a contigous array of cairo_glyph_t records;
constant Size = nativesizeof(cairo_glyph_t);


method AT-POS(UInt:D $idx) {
    nativecast(cairo_glyph_t, $buf.subbuf(Size * $idx, Size));
}
