unit class HarfBuzz::Buffer;

use HarfBuzz::Raw;

has hb_buffer $!raw .= new;

submethod TWEAK {
    $!raw.reference;
}

submethod DESTROY {
    $!raw.destroy;
}

