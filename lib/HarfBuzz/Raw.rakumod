#| Native HarfBuzz Raku bindings
unit module HarfBuzz::Raw;

use HarfBuzz::Raw::Defs :$HB, :$CLIB, :types, :hb-memory-mode;
use NativeCall;

module CLib {
    our sub memcpy(Pointer $dest, Pointer $src, size_t $len) is native($CLIB) {*}
}

role ContiguousArray[\elem] {
    multi method Pointer { nativecast(Pointer, self); }
    method AT-POS(UInt:D $idx) {
        my Pointer:D $src .= new(+self.Pointer  +  $idx * nativesizeof(elem));
        given elem.new -> $dest {
            my size_t $len = nativesizeof(elem);
            CLib::memcpy(nativecast(Pointer, $dest), $src, $len);
            $dest
        }
    }

    method ASSIGN-POS(UInt:D $idx, $src) is rw {
        my Pointer:D $dest .= new(+self.Pointer  +  $idx * nativesizeof(elem));
        my size_t $len = nativesizeof(elem);
        CLib::memcpy($dest, nativecast(Pointer, $src), $len);
        nativecast(elem, $dest);
    }
}

class hb_var_int is repr('CUnion') {
  has uint32 $.u32;
  has int32  $.i32;
  has uint16 $!u16a; #[2]
  has int16  $!i16a; #[2]
  has uint8  $!u8a;  #[4]
  has int8   $!i8;   #[4]
}

#| A relative glyph position
class hb_glyph_position is export is repr('CStruct') {
    has hb_position  $.x-advance;
    has hb_position  $.y-advance;
    has hb_position  $.x-offset;
    has hb_position  $.y-offset;

    #< private >
    HAS hb_var_int   $!var;
}

#| A contiguous array of glyph positions
class hb_glyph_positions
    is export
    is repr('CPointer')
    does ContiguousArray[hb_glyph_position] {
}

#| Additional glyph information
class hb_glyph_info is export is repr('CStruct') {
    has hb_codepoint $.codepoint;
    #< private >
    has hb_mask      $!mask;
    #< public >
    has uint32       $.cluster;

    #< private >
    HAS hb_var_int   $!var1;
    HAS hb_var_int   $!var2;

    method get-flags(--> uint32) is native($HB) is symbol('hb_glyph_info_get_glyph_flags') {*}
}

#| A contiguous array of glyph information
class hb_glyph_infos
    is export
    is repr('CPointer')
    does ContiguousArray[hb_glyph_info] {
}

#| Unscaled glyph metrics
class hb_glyph_extents is export is repr('CStruct') {
    # Note that height is negative in coordinate systems that grow up.
    has hb_position $.x-bearing; # left side of glyph from origin.
    has hb_position $.y-bearing; # top side of glyph from origin.
    has hb_position $.width;     # distance from left to right side.
    has hb_position $.height;    # distance from top to bottom side.
}

#| Storage for a HarfBuzz buffer
class hb_blob is repr('CPointer') is export {
    our sub create(Blob, uint32, int32, Pointer, Pointer --> hb_blob) is native($HB) is symbol('hb_blob_create') {*}
    our sub create_from_file(Str --> hb_blob) is native($HB) is symbol('hb_blob_create_from_file') {*}

    multi method new(Str :$file!, --> hb_blob) {
        create_from_file($file);
    }

    multi method new(Blob :$buf!) {
        create($buf, $buf.bytes, HB_MEMORY_MODE_READONLY, Pointer, Pointer);
    }

    method get-data(uint32 $ is rw --> Pointer) is native($HB) is symbol('hb_blob_get_data') {*}

    method reference(--> hb_blob) is native($HB) is symbol('hb_blob_reference') {*}
    method destroy() is native($HB) is symbol('hb_blob_destroy')  {*}
}

#| HarfBuzz language representation
class hb_language is repr('CPointer') is export {
    our sub from_string(Blob, int32 --> hb_language) is native($HB) is symbol('hb_language_from_string') {*}
    method from-string(Blob $tag, UInt $len = $tag.bytes) {
        from_string($tag, $len);
    }
    method to-string(--> Str) is native($HB) is symbol('hb_language_to_string') {*}
    multi method COERCE(Str:D $tag) {
        from_string($tag.encode);
    }
    method Str(hb_language:D:) {
        self.to-string;
    }
}

#| A HarfBuzz buffer
class hb_buffer is repr('CPointer') is export {
    our sub create(--> hb_buffer) is native($HB) is symbol('hb_buffer_create') {*}
    method new(--> hb_buffer) { create() }
    method add-utf8(blob8 $buf, int32 $len, uint32 $offset, int32 $n) is native($HB) is symbol('hb_buffer_add_utf8') {*}
    method add-codepoints(blob32 $buf, int32 $len, uint32 $offset, int32 $n) is native($HB) is symbol('hb_buffer_add_codepoints') {*}
    method guess-segment-properties() is native($HB) is symbol('hb_buffer_guess_segment_properties')  {*}
    method get-length(--> int32) is native($HB) is symbol('hb_buffer_get_length') {*}
    method set-length(int32) is native($HB) is symbol('hb_buffer_set_length') {*}
    method get-glyph-positions(uint32 is rw  --> hb_glyph_positions) is native($HB) is symbol('hb_buffer_get_glyph_positions')  {*}
    method get-glyph-infos(uint32 is rw --> hb_glyph_infos) is native($HB) is symbol('hb_buffer_get_glyph_infos')  {*}
    method set-direction(hb_direction) is native($HB) is symbol('hb_buffer_set_direction') {*}
    method get-direction(--> hb_direction) is native($HB) is symbol('hb_buffer_get_direction') {*}
    method set-language(hb_language) is native($HB) is symbol('hb_buffer_set_language') {*}
    method get-language(--> hb_language) is native($HB) is symbol('hb_buffer_get_language') {*}
    method set-script(hb_script) is native($HB) is symbol('hb_buffer_set_script') {*}
    method get-script(--> hb_script) is native($HB) is symbol('hb_buffer_get_script') {*}
    method clear-contents() is native($HB) is symbol('hb_buffer_clear_contents')  {*}
    method get-content-type(--> int32) is native($HB) is symbol('hb_buffer_get_content_type')  {*}
    method set-content-type(int32) is native($HB) is symbol('hb_buffer_set_content_type')  {*}
    method add-text(Str:D $str, UInt :$offset = 0) {
        my blob32:D $ords .= new: $str.ords;
        self.add-codepoints($ords, $ords.elems, $offset, $ords.elems);
    }

    method reference(--> hb_buffer) is native($HB) is symbol('hb_buffer_reference') {*}
    method destroy() is native($HB) is symbol('hb_buffer_destroy')  {*}
}
=begin pod
=para This holds text or glyph transforms, plus context, inlcuding language, script and direction.
=end pod

#| HarfBuzz generalized set representation
class hb_set is repr('CPointer') is export {
    our sub create(--> hb_set) is native($HB) is symbol('hb_set_create') {*}
    method elems(--> uint32) is native($HB) is symbol('hb_set_get_population') {*}
    method add(hb_codepoint) is native($HB) is symbol('hb_set_add') {*}
    method del(hb_codepoint) is native($HB) is symbol('hb_set_del') {*}
    method add-range (hb_codepoint, hb_codepoint) is native($HB) is symbol('hb_set_add_range') {*}
    method min(--> hb_codepoint) is native($HB) is symbol('hb_set_min') {*}
    method max(--> hb_codepoint) is native($HB) is symbol('hb_set_max') {*}
    method next(hb_codepoint $ is rw --> hb_bool) is native($HB) is symbol('hb_set_next') {*}
    method prev(hb_codepoint $ is rw --> hb_bool) is native($HB) is symbol('hb_set_previous') {*}
    method next-many(hb_codepoint, CArray[hb_codepoint], uint32 --> uint32) is native($HB) is symbol('hb_set_next_many') {*}
    method exists(hb_codepoint --> hb_bool) is native($HB) is symbol('hb_set_has') {*}
    method destroy() is native($HB) is symbol('hb_set_destroy') {*}
}

class hb_map is repr('CPointer') is export {
    our sub create(--> hb_map) is native($HB) is symbol('hb_map_create') {*}
    method get(hb_codepoint --> hb_codepoint) is native($HB) is symbol('hb_map_get') {*}
    method keys(hb_set) is native($HB) is symbol('hb_map_keys') {*}
    method values(hb_set) is native($HB) is symbol('hb_map_values') {*}
    method elems(--> uint32) is native($HB) is symbol('hb_map_get_population') {*}
    method exists(hb_codepoint --> hb_bool) is native($HB) is symbol('hb_map_has') {*}
    method destroy() is native($HB) is symbol('hb_map_destroy') {*}
}

#| HarfBuzz representation  of a font feature
class hb_feature is export is repr('CStruct') is rw {
    has hb_tag  $.tag;
    has uint32  $.value;
    has uint32  $.start;
    has uint32  $.end;
    sub from_string(Blob, int32, hb_feature --> hb_bool) is native($HB) is symbol('hb_feature_from_string')  {*}
    method to-string(blob8, uint32) is native($HB) is symbol('hb_feature_to_string')  {*}
    method from-string(Blob $buf, $len = $buf.bytes) {
        from_string($buf, $len, self);
    }
    multi method COERCE(Str:D $tag) {
        from_string($tag.encode);
    }
    method Str(hb_language:D:) {
        self.to-string;
    }
};

#| A contiguous arry of font features
class hb_features
    is export
    is repr('CPointer')
    does ContiguousArray[hb_feature] {
}

#| A context free representation of a HarfBuzz font face
class hb_face is repr('CPointer') is export {
    our sub create(hb_blob, uint32 --> hb_face) is native($HB) is symbol('hb_face_create') {*}
    method new(hb_blob :$blob!, UInt:D :$index=0 --> hb_face) { create($blob, $index) }
    method reference(--> hb_face) is native($HB) is symbol('hb_face_reference') {*}
    method reference-blob(--> hb_blob)  is native($HB) is symbol('hb_face_reference_blob') {*}
    method get-glyph-count(--> uint32) is native($HB) is symbol('hb_face_get_glyph_count') {*}
    method collect-unicode-set(hb_set) is native($HB) is symbol('hb_face_collect_unicodes') {*}
    method collect-unicode-map(hb_map, hb_set) is native($HB) is symbol('hb_face_collect_nominal_glyph_mapping') {*}
    method get-table-tags(uint32, uint32 is rw, Pointer[hb_tag] is rw --> uint32) is symbol('hb_face_collect_unicodes') is native($HB) is symbol('hb_face_get_table_tags') {*}
    method get-upem(--> uint32) is native($HB) is symbol('hb_face_get_upem') {*}
    method destroy() is native($HB) is symbol('hb_face_destroy')  {*}
}

#| A contextual representation of a HarfBuzz font
class hb_font is repr('CPointer') is export {
    our sub create(hb_face --> hb_font) is native($HB) is symbol('hb_font_create') {*}
    method new(hb_face :$face! --> hb_font) { create($face) }
    method set-face(hb_face) is native($HB) is symbol('hb_font_set_face') {*}
    method get-face(--> hb_face) is native($HB) is symbol('hb_font_get_face') {*}
    method set-size(num32) is native($HB) is symbol('hb_font_set_ptem') {*}
    method get-size(--> num32) is native($HB) is symbol('hb_font_get_ptem') {*}
    method set-scale(int32 $x, int32 $y) is native($HB) is symbol('hb_font_set_scale') {*}
    method get-scale(int32 $x is rw, int32 $y) is native($HB) is symbol('hb_font_get_scale') {*}
    method get-glyph-name(hb_codepoint, Blob, int32 --> hb_bool) is native($HB) is symbol('hb_font_get_glyph_name') {*}
    method get-glyph-from-name(Blob, int32, hb_codepoint $ is rw --> hb_bool) is native($HB) is symbol('hb_font_get_glyph_from_name') {*}
    method get-glyph-extents(hb_codepoint, hb_glyph_extents --> hb_bool) is native($HB) is symbol('hb_font_get_glyph_extents') {*}
    method shape(hb_buffer, Blob, uint32)  is native($HB) is symbol('hb_shape') {*}

    method reference(--> hb_font) is native($HB) is symbol('hb_font_reference') {*}
    method destroy() is native($HB) is symbol('hb_font_destroy')  {*}
}
=begin pod
=para include font-face, size and scale. A Font can be shaped against a buffer.
=end pod

sub hb_version(uint32 $major is rw, uint32 $minor is rw, uint32 $micro is rw) is export is native($HB) {*}

sub hb_tag_from_string(Blob, int32 --> hb_tag) is export is native($HB) {*}
sub hb_tag_to_string(hb_tag, Blob) is export is native($HB) {*}


