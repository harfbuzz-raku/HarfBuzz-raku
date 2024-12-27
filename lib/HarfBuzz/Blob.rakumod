#| HarfBuzz representation of a Blob
unit class HarfBuzz::Blob;

use HarfBuzz::Raw;
use NativeCall;

has hb_blob $.raw is built;

multi submethod TWEAK(Str:D() :$file!) {
    $!raw .= new: :$file;
    $!raw.reference;
}

multi submethod TWEAK(hb_blob:D :$!raw!) {
}

multi submethod TWEAK(Blob:D :$buf!) {
    $!raw .= new: :$buf;
    $!raw.reference;
}

multi method COERCE(IO:D $io!)       { self.new: :file($io.path); }
multi method COERCE(Str:D $file!)    { self.new: :$file; }
multi method COERCE(hb_blob:D $raw!) { self.new: :$raw; }
multi method COERCE(Blob:D $buf!)    { self.new: :$buf; }

#| Convert to a Raku Blob
method Blob {
    my uint32 $len;
    my Pointer $data = $!raw.get-data($len);
    my buf8 $buf .= allocate($len);
    HarfBuzz::Raw::CLib::memcpy(nativecast(Pointer, $buf), $data, $len);
    $buf;
}

submethod DESTROY {
    $!raw.destroy;
}
