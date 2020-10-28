unit module HarfBuzz::Raw;

use HarfBuzz::Raw::Defs :$HB, :$HB-BIND;
use NativeCall;

class hb_blob is repr('CPointer') is export {
    sub hb_blob_create_from_file(Str) is native($HB) returns hb_blob {*}
    method new(Str :$file!, --> hb_blob) { hb_blob_create_from_file($file) }
    method reference() is native($HB) is symbol('hb_blob_reference') returns hb_blob {*}
    method destroy() is native($HB) is symbol('hb_blob_destroy')  {*}
}

class hb_buffer is repr('CPointer') is export {
    sub hb_buffer_create() is native($HB) returns hb_buffer {*}
    method new(--> hb_buffer) { hb_buffer_create }
    method reference() is native($HB) is symbol('hb_buffer_reference') returns hb_buffer {*}
    method destroy() is native($HB) is symbol('hb_buffer_destroy')  {*}
}

class hb_face is repr('CPointer') is export {
    sub hb_face_create(hb_blob, uint32) is native($HB) returns hb_face {*}
    method new(hb_blob :$blob!, UInt:D :$index=0 --> hb_face) { hb_face_create($blob, $index) }
    method reference() is native($HB) is symbol('hb_face_reference') returns hb_face {*}
    method destroy() is native($HB) is symbol('hb_face_destroy')  {*}
}

class hb_font is repr('CPointer') is export {
    sub hb_font_create(hb_face) is native($HB) returns hb_font {*}
    method new(hb_face :$face! --> hb_font) { hb_font_create($face) }
    method set-size(num32) is native($HB) is symbol('hb_font_set_ptem') {*}
    method get-size(--> num32) is native($HB) is symbol('hb_font_get_ptem') {*}
    method reference() is native($HB) is symbol('hb_font_reference') returns hb_font {*}
    method destroy() is native($HB) is symbol('hb_font_destroy')  {*}
}
