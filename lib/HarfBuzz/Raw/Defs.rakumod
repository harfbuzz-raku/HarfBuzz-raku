unit module HarfBuzz::Raw::Defs;

our $HB is export(:HB) = 'harfbuzz';
our $HB-BIND is export(:HB-BIND) =  %?RESOURCES<libraries/hb-bind>;

constant hb_bool      is export(:types) = int32;
constant hb_codepoint is export(:types) = uint32;
constant hb_position  is export(:types) = int32;
constant hb_mask      is export(:types) = uint32;
