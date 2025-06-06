#| A context free HarfBuzz font face
unit class HarfBuzz::Face;

use HarfBuzz::Raw;
use HarfBuzz::Raw::Defs :types, :hb-set-value, :&hb-tag-dec;
use HarfBuzz::Blob;
use HarfBuzz::Map;
use HarfBuzz::Set;
use NativeCall;

has HarfBuzz::Blob $!blob handles<Blob>;
has hb_face $.raw is built handles<get-glyph-count get-units-per-EM> ;
has UInt:D $.index = 0;

multi submethod TWEAK(hb_face:D :$!raw) {
    $!raw.reference;
    given $!raw.reference-blob() {
        $!blob .= new: :raw($_);
    }
}

multi submethod TWEAK(Str:D() :$file!) {
    self!to-blob: $file;
}

multi submethod TWEAK(Blob:D :$buf!) {
    self!to-blob: $buf;
}

multi submethod TWEAK(:$blob!) {
    self!to-blob: $blob;
}

method !to-blob(HarfBuzz::Blob() $!blob) {
    $!raw .= new: :blob($!blob.raw), :$!index;
    $!raw.reference;
}

method units-per-EM { $!raw.get-upem }

method table-tags returns Seq {
    my uint $max-tags = 128;
    my Blob[hb_tag] $tags .= allocate($max-tags);
    $!raw.get-table-tags(0, $max-tags, $tags);
    (^$max-tags).map: { hb-tag-dec($tags[$_]).trim }
}

method unicode-set(::?CLASS:D:) {
    my HarfBuzz::Set $set .= new;
    $!raw.collect-unicode-set($set.raw);
    $set;
}

method unicode-to-gid-map(::?CLASS:D:) {
    my HarfBuzz::Map $map .= new;
    $!raw.collect-unicode-map($map.raw, hb_set);
    $map;
}

multi method COERCE(hb_face:D $raw)  { self.new: :$raw; }
multi method COERCE(Str:D $file)     { self.new: :$file; }
multi method COERCE(Blob:D $buf)     { self.new: :$buf; }
multi method COERCE(%opts where {.<raw file buf>:exists}) { self.new: |%opts }

submethod DESTROY {
    $!raw.destroy;
}

