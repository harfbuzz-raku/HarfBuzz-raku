unit class HarfBuzz::Buffer;

use HarfBuzz::Raw;
use HarfBuzz::Raw::Defs :types, :&hb-tag-enc;
use HarfBuzz::Glyph;
use Method::Also;

has hb_buffer $.raw is built handles<guess-segment-properties length> .= new;

method get-language { $!raw.get-language.to-string }
method set-language(Str:D $tag) {
    my hb_language $lang .= from-string($tag.encode);
    $!raw.set-language($lang);
}
method language is rw is also<lang> {
    Proxy.new(
        FETCH => { self.get-language },
        STORE => -> $, Str() $_ {
            self.set-language($_);
        }
    );
}

method get-script { $!raw.get-script }
multi method set-script(Str:D $script) {
    $!raw.set-script(hb-tag-enc($script));
}
multi method set-script(UInt:D $script) {
    $!raw.set-script($script);
}
method script is rw {
    Proxy.new(
        FETCH => { self.get-script },
        STORE => -> $, $_ {
            self.set-script($_);
        }
    );
}

method get-direction { $!raw.get-direction }
multi method set-direction(UInt:D $direction) {
    $!raw.set-direction($direction);
}
method direction is rw {
    Proxy.new(
        FETCH => { self.get-direction },
        STORE => -> $, $_ {
            self.set-direction($_);
        }
    );
}

method add-text(Str:D $str, UInt :$offset = 0) {
    my $utf8 = $str.encode;
    $!raw.add-utf8($utf8, $utf8.elems, $offset, $utf8.elems);
}

submethod TWEAK {
    $!raw.reference;
}

submethod DESTROY {
    $!raw.destroy;
}

