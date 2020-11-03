unit module HarfBuzz::Raw::Defs;

our $HB is export(:HB) = 'harfbuzz';
our $HB-BIND is export(:HB-BIND) =  %?RESOURCES<libraries/hb-bind>;
our $CLIB is export(:CLIB) = Rakudo::Internals.IS-WIN ?? 'msvcrt' !! Str;

constant hb_bool      is export(:types) = int32;
constant hb_codepoint is export(:types) = uint32;
constant hb_position  is export(:types) = int32;
constant hb_mask      is export(:types) = uint32;
constant hb_tag       is export(:types) = uint32;

enum hb-memory-mode is export(:hb-memory-mode) «
    :HB_MEMORY_MODE_DUPLICATE(0)
    :HB_MEMORY_MODE_READONLY(1)
    :HB_MEMORY_MODE_WRITABLE(2)
    :HB_MEMORY_MODE_READONLY_MAY_MAKE_WRITABLE(3)
    »;
