unit module HarfBuzz::Raw;

use HarfBuzz::Raw::Defs :$HB, :$HB-BIND, :$CLIB, :types;
use NativeCall;

role ContiguousArray {
    method AT-POS(UInt:D $idx) {
        my Pointer $base-addr = nativecast(Pointer, self);
        my Pointer $elem-addr = Pointer.new(+$base-addr  +  $idx * nativesizeof(self));
        nativecast(self.WHAT, $elem-addr);
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

class hb_glyph_position is export is repr('CStruct') does ContiguousArray {
    has hb_position  $.x-advance;
    has hb_position  $.y-advance;
    has hb_position  $.x-offset;
    has hb_position  $.y-offset;

    #< private >
    HAS hb_var_int   $!var;
}

class hb_glyph_info is export is repr('CStruct') does ContiguousArray {
    has hb_codepoint $.codepoint;
    #< private >
    has hb_mask      $!mask;
    #< public >
    has uint32       $.cluster;

    #< private >
    HAS hb_var_int   $!var1;
    HAS hb_var_int   $!var2;
    # + more private fields. disable new
    method new(|) {
    }
}

class hb_blob is repr('CPointer') is export {
    sub hb_blob_create_from_file(Str --> hb_blob) is native($HB) {*}
    method new(Str :$file!, --> hb_blob) { hb_blob_create_from_file($file) }
    method reference(--> hb_blob) is native($HB) is symbol('hb_blob_reference') {*}
    method destroy() is native($HB) is symbol('hb_blob_destroy')  {*}
}

class hb_buffer is repr('CPointer') is export {
    sub hb_buffer_create(--> hb_buffer) is native($HB) {*}
    method new(--> hb_buffer) { hb_buffer_create }
    method add-utf8(blob8 $buf, int32 $len, uint32 $offset, int32 $n) is native($HB) is symbol('hb_buffer_add_utf8') {*}
    method guess-segment-properties() is native($HB) is symbol('hb_buffer_guess_segment_properties')  {*}
    method length(--> int32) is native($HB) is symbol('hb_buffer_get_length') {*}
    method get-glyph-positions(uint32 --> hb_glyph_position) is native($HB) is symbol('hb_buffer_get_glyph_positions')  {*}
    method get-glyph-infos(uint32 --> hb_glyph_info) is native($HB) is symbol('hb_buffer_get_glyph_infos')  {*}

    method reference(--> hb_buffer) is native($HB) is symbol('hb_buffer_reference') {*}
    method destroy() is native($HB) is symbol('hb_buffer_destroy')  {*}
}

class hb_face is repr('CPointer') is export {
    sub hb_face_create(hb_blob, uint32 --> hb_face) is native($HB) {*}
    method new(hb_blob :$blob!, UInt:D :$index=0 --> hb_face) { hb_face_create($blob, $index) }
    method reference(--> hb_face) is native($HB) is symbol('hb_face_reference') {*}
    method destroy() is native($HB) is symbol('hb_face_destroy')  {*}
}

class hb_feature is export is repr('CStruct') is rw {
    has hb_tag  $.tag;
    has uint32  $.value;
    has uint32  $.start;
    has uint32  $.end;
    sub from-string(Blob, int32, hb_feature --> hb_bool) is native($HB) is symbol('hb_feature_from_string')  {*}
    method to-string(blob8) is native($HB) is symbol('hb_feature_to_string')  {*}
    method from-string(Blob $buf, $len = $buf.bytes) {
        from-string($buf, $len, self);
    }
    method !memcpy(hb_feature $feature, size_t $len) is native($CLIB) {*}
    method copy(hb_feature $feature) {
        self!memcpy($feature, nativesizeof($feature));
    }
};

class hb_feature_array
    is hb_feature
    is export
    is repr('CStruct')
    does ContiguousArray {
}

class hb_font is repr('CPointer') is export {
    sub hb_font_create(hb_face --> hb_font) is native($HB) {*}
    method new(hb_face :$face! --> hb_font) { hb_font_create($face) }
    method set-size(num32) is native($HB) is symbol('hb_font_set_ptem') {*}
    method get-size(--> num32) is native($HB) is symbol('hb_font_get_ptem') {*}
    method set-scale(int32 $x, int32 $y) is native($HB) is symbol('hb_font_set_scale') {*}
    method get-scale(int32 $x is rw, int32 $y) is native($HB) is symbol('hb_font_get_scale') {*}
    method get-glyph-name(hb_codepoint, Blob, int32 --> hb_bool) is native($HB) is symbol('hb_font_get_glyph_name') {*}
    method shape(hb_buffer, hb_feature_array, uint32 --> hb_font)  is native($HB) is symbol('hb_shape') {*}
    method reference(--> hb_font) is native($HB) is symbol('hb_font_reference') {*}
    method destroy() is native($HB) is symbol('hb_font_destroy')  {*}
}

sub hb_version(uint32 $major is rw, uint32 $minor is rw, uint32 $micro is rw) is export is native($HB) {*}

sub hb_tag_from_string(Blob, int32 --> hb_tag) is export is native($HB) {*}
sub hb_tag_to_string(hb_tag, Blob) is export is native($HB) {*}
