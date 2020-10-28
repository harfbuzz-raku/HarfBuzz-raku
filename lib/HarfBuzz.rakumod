unit class HarfBuzz;

use HarfBuzz::Blob;
use HarfBuzz::Buffer;
use HarfBuzz::Face;
use HarfBuzz::Font;

has Str:D $.file is required;
has HarfBuzz::Buffer $!buf;
has HarfBuzz::Font $!font handles<face size>;

submethod TWEAK {
    my HarfBuzz::Face:D $face .= new: :$!file;
    $!font .= new: :$face;
    $!buf .= new;
}
