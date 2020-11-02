unit class HarfBuzz::Feature;

use HarfBuzz::Raw;

has hb_feature $.raw handles<value start>;

multi submethod TWEAK(:$!raw!) {}
multi submethod TWEAK(Str:D :$str!) {
    $!raw .= new;
    my Blob $buf = $str.encode;
    $!raw.from-string($buf, $buf.bytes);
}

multi submethod TWEAK(Str:D :$tag!, UInt :$start = 0, :$end = Inf, UInt :$value = 1 ) {
    $!raw .= new;
    my Blob $buf = $tag.encode;
    $!raw.tag = hb_tag_from_string($buf, $buf.bytes);
    self.value = $value;
    self.start = $start;
    self.end = $end;
}

method tag is rw {
    Proxy.new(
        FETCH => {
            my buf8 $buf .= allocate(4);
            hb_tag_to_string($!raw.tag, $buf);
            $buf.decode;
        },
        STORE => -> $, Str:D $_ {
            my Blob $buf = .encode;
            $!raw.tag = hb_tag_from_string($buf, $buf.bytes);
        }
    )
}

method end is rw {
    Proxy.new(
        FETCH => {
            my $end := $!raw.end;
            $end < 0 ?? Inf !! $end
        },
        STORE => -> $, UInt:D $end {
            $!raw.end = ($end === Inf ?? -1 !! $end);
        },
    )
}

method Str {
    my buf8 $buf .= allocate(128);
    $!raw.to-string($buf, $buf.bytes);
    $buf.reallocate: (0 ..^ $buf.elems).first: {$buf[$_] == 0};
    $buf.decode;
}
