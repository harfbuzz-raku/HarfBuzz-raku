unit class HarfBuzz::Face;

use HarfBuzz::Raw;
use HarfBuzz::Blob;

has HarfBuzz::Blob $!blob;
has hb_face $.raw is built;

submethod TWEAK(Str:D :$file!) {
    $!blob .= new: :$file;
    $!raw .= new: :blob($!blob.raw);
    $!raw.reference;
}

submethod DESTROY {
    $!raw.destroy;
}

