use HarfBuzz::Buffer;
use HarfBuzz::Glyph;
use HarfBuzz::Shaper;
use Test;
plan 4;

my $file = 't/fonts/NimbusRoman-Regular.otf';
my $size = 36;
my $text = 'Hi';

my HarfBuzz::Buffer $buf .= new: :$text;
nok $buf.shaped;
my HarfBuzz::Shaper $hb .= new: :font{ :$file, :$size}, :$buf;

subtest '"H" glyph', {
    my HarfBuzz::Glyph $g = $hb[0];
    is $g.gid, 41, 'gid';
    is $g.x-advance, 25.99, 'x-advance';
    is $g.x-bearing, 0.68, 'x-bearing';
    is $g.width, 24.59, 'width';
    is $g.height, -23.83, 'height';
    is-deeply $g.offset, 0+0i, 'offset';
    is-deeply $g.advance, 25.99+0i, 'advance';
    is-deeply $g.bearing, 0.68+23.83i, 'bearing';
    is-deeply $g.size, 24.59-23.83i, 'size';
}

subtest '"i" glyph', {
    my HarfBuzz::Glyph $g = $hb[1];
    is $g.gid, 74, 'gid';
    is $g.x-advance, 10.01, 'x-advance';
    is $g.x-bearing, 0.58, 'x-bearing';
    is $g.width, 8.53, 'width';
}
ok $buf.shaped;
