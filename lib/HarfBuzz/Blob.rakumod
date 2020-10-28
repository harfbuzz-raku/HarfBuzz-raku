unit class HarfBuzz::Blob;

use HarfBuzz::Raw;
has hb_blob $.raw is built;

submethod TWEAK(Str:D :$file!) {
    $!raw .= new: :$file;
    $!raw.reference;
}

submethod DESTROY {
    $!raw.destroy;
}

