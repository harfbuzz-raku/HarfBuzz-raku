unit class HarfBuzz:ver<0.0.1>;

use HarfBuzz::Blob;
use HarfBuzz::Buffer;
use HarfBuzz::Face;
use HarfBuzz::Feature;
use HarfBuzz::Font;
use HarfBuzz::Font::FreeType;
use HarfBuzz::Raw;
use NativeCall;
use Method::Also;
use Font::FreeType::Face;

has Str:D $.file is required;
has HarfBuzz::Buffer $!buf handles<length language lang script direction>;
has HarfBuzz::Font $!font handles<face size scale ft-load-flags>;
has HarfBuzz::Feature @!features;
method features { @!features }

method glyphs {
    class Iteration does Iterable does Iterator {
        has UInt $.idx = 0;
        has HarfBuzz::Buffer:D $.buf is required;
        has HarfBuzz::Font:D $.font is required handles<size scale>;
        has hb_glyph_position $!Pos = $!buf.raw.get-glyph-positions(0);
        has hb_glyph_info     $!Info = $!buf.raw.get-glyph-infos(0);
        method iterator { self }
        method pull-one {
            if $!idx < $!buf.length {
                my hb_glyph_position:D $pos = $!Pos[$!idx];
                my hb_glyph_info:D $info = $!Info[$!idx];
                $!idx++;
                my @vec = @.scale.map: $.size / *;
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

method ast is also<shaper> {
    self.glyphs.map: *.ast;
}

method version {
    HarfBuzz::Raw::version();
}

submethod TWEAK( :@scale = [1000, 1000], Numeric :$size, Str :$lang, Str :$text, :@features, Font::FreeType::Face :$ft-face) {
    if $ft-face.defined {
        my hb_ft_font $raw = hb_ft_font::create($ft-face.raw);
        my HarfBuzz::Face $face .= new: raw => $raw.get-face();
        $!font = HarfBuzz::Font::FreeType.new(:$raw, :$face, :$ft-face, :@scale, :$size);
    }
    else {
        my HarfBuzz::Face $face .= new: :$!file, :$ft-face;
        my hb_font $raw = hb_font::create($face.raw);
        $!font = HarfBuzz::Font.new(:$raw, :$face, :@scale, :$size);
    }
    $!buf .= new;
    $!buf.add-text($_) with $text;
    $!buf.guess-segment-properties();
    $!buf.set-language($_) with $lang;

    for @features {
        when HarfBuzz::Feature:D { @!features.push: $_ }
        when hb_feature:D { @!features.push: HarfBuzz::Feature.new: :raw($_) }
        when Str { @!features.push: HarfBuzz::Feature.new: :str($_) }
        default { warn "ignoring unknown feature: {.raku}"; }
    }

    $!font.shape: :$!buf, :@!features;
}
