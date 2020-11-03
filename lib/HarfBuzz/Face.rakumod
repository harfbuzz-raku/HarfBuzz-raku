unit class HarfBuzz::Face;

use HarfBuzz::Raw;
use HarfBuzz::Blob;

has HarfBuzz::Blob $!blob;
has hb_face $.raw is built handles<get-glyph-count> ;

multi submethod TWEAK(Str:D :$file!) {
    $!blob .= new: :$file;
    $!raw .= new: :blob($!blob.raw);
    $!raw.reference;
}

multi submethod TWEAK(hb_face:D :$!raw) {
    $!raw.reference;
    given $!raw.reference-blob() {
        $!blob .= new: :raw($_);
    }
}
submethod DESTROY {
    $!raw.destroy;
}

