#| A context free HarfBuzz font face
unit class HarfBuzz::Face;

use HarfBuzz::Raw;
use HarfBuzz::Raw::Defs :types, :hb-set-value;
use HarfBuzz::Blob;
use HarfBuzz::Map;
use HarfBuzz::Set;
use NativeCall;

has HarfBuzz::Blob $!blob handles<Blob>;
has hb_face $.raw is built handles<get-glyph-count get-units-per-EM> ;

multi submethod TWEAK(hb_face:D :$!raw) is default {
    $!raw.reference;
    given $!raw.reference-blob() {
        $!blob .= new: :raw($_);
    }
}

multi submethod TWEAK(Str:D :$file!) {
    self!to-blob: $file;
}

multi submethod TWEAK(Blob:D :$buf!) {
    self!to-blob: $buf;
}

method !to-blob(HarfBuzz::Blob() $!blob) {
    $!raw .= new: :blob($!blob.raw);
    $!raw.reference;
}

method units-per-EM { $!raw.get-upem }

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

