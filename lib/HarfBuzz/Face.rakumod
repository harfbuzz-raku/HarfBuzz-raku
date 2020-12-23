#| A context free HarfBuzz font face
unit class HarfBuzz::Face;

use HarfBuzz::Raw;
use HarfBuzz::Blob;

has HarfBuzz::Blob $!blob handles<Blob>;
has hb_face $.raw is built handles<get-glyph-count> ;

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

multi method COERCE(hb_face:D $raw)  { self.new: :$raw; }
multi method COERCE(Str:D $file)     { self.new: :$file; }
multi method COERCE(Blob:D $buf)     { self.new: :$buf; }
multi method COERCE(%opts where {.<raw file buf>:exists}) { self.new: |%opts }

submethod DESTROY {
    $!raw.destroy;
}

