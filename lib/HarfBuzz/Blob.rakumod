unit class HarfBuzz::Blob;

use HarfBuzz::Raw;
has hb_blob $.raw is built;

multi submethod TWEAK(Str:D :$file!) {
    $!raw .= new: :$file;
    $!raw.reference;
}

multi submethod TWEAK(hb_blob:D :$!raw) {
}

submethod DESTROY {
    $!raw.destroy;
}
