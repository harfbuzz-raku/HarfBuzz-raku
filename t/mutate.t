# check that we can update various object properties
use Test;
plan 8;
use HarfBuzz::Shaper;
sub hb(:$size = 24, :$text = 'test', :$file = 't/fonts/NimbusRoman-Regular.otf') {
   HarfBuzz::Shaper.new: :font{ :$file, :$size }, :buf{:$text, :language<epo>};
}

my \case-text_test2 = hb(:text<test2>);

given hb() {
    .text = 'test2';
    is .text, 'test2';
    is-deeply .shape.tail.ast, case-text_test2.shape.tail.ast, '.text update';
}

given hb() {
    .buf = {:text<test2>, :language<epo>};
    is .text, 'test2';
    is-deeply .shape.tail.ast, case-text_test2.shape.tail.ast, '.buf update';
}

my \case-size_36 = hb(:size(36));

given hb() {
    .size = 36;
    is .size, 36;
    is-deeply .shape.tail.ast, case-size_36.shape.tail.ast, '.size update';
}

given hb() {
    .font = { :file<t/fonts/NimbusRoman-Regular.otf> :size(36) };
    is .size, 36;
    is-deeply .shape.tail.ast, case-size_36.shape.tail.ast, '.font update';
}

