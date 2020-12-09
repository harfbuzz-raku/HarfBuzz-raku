# Ported from https://github.com/harfbuzz/harfbuzz-tutorial/blob/master/hello-harfbuzz-freetype.c

use Font::FreeType;
use Font::FreeType::Face;
use HarfBuzz::Shaper;
use HarfBuzz::Glyph;
use Cairo;

sub MAIN(Str $font-file, Str $text = 'Hello from HarfBuzz', :@features, :$output = 'out.png', UInt :$font-size = 36, Numeric :$margin = $font-size / 2) {
    my Font::FreeType::Face:D $ft-face = Font::FreeType.face($font-file);
    my HarfBuzz::Shaper $shaper .= new: :font{ :$ft-face, :@features, :size($font-size) } :buf{:$text }
    my HarfBuzz::Glyph @glyphs = $shaper.shape;
    my $width  = 2 * $margin + @glyphs>>.x-advance.sum ;
    my $height = 2 * $margin - @glyphs>>.y-advance.sum;
    ($shaper.is-horizontal ?? $height !! $width) += $font-size;
    my Cairo::Image $surface .= create(Cairo::FORMAT_ARGB32, ceiling($width), ceiling($height));
    my Cairo::Context $ctx .= new($surface);

    $ctx.rgba(1, 1, 1, 1);
    $ctx.paint;
    $ctx.rgba(0, 0, 0, 1);
    $ctx.translate($margin, $margin);

    my Cairo::Font $font .= create(
        $ft-face.raw, :free-type,
    );
    $ctx.set_font_face($font);
    $ctx.set_font_size($font-size);
    if $shaper.is-horizontal {
        my Cairo::cairo_font_extents_t \font_extents = $ctx.font_extents;
        my $baseline = ($font-size - font_extents.height) * .5  + font_extents.ascent;
        $ctx.translate(0, $baseline);
    }
    else {
        $ctx.translate($font-size * .5, 0);
    }

    my Cairo::Glyphs $glyphs = $shaper.cairo-glyphs;
    for 0 ..^ $glyphs.elems {
        my $glyph = $glyphs[$_];
        my $glyph-name = $shaper.glyph-name($glyph.index);
        note sprintf("glyph='%s'	position=(%g,%g)", $glyph-name, $glyph.x, $glyph.y);
    }
    $ctx.show_glyphs($glyphs);
    $surface.write_png($output);
}
