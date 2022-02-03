#| Native Enums and constants
unit module HarfBuzz::Raw::Defs;

our $HB is export(:HB) = 'harfbuzz';
our $CLIB is export(:CLIB) = Rakudo::Internals.IS-WIN ?? 'msvcrt' !! Str;

constant hb_bool      is export(:types) = int32;
constant hb_codepoint is export(:types) = uint32;
constant hb_position  is export(:types) = int32;
constant hb_mask      is export(:types) = uint32;
constant hb_tag       is export(:types) = uint32;
constant hb_script    is export(:types) = uint32;
constant hb_direction is export(:types) = uint32;

constant HB_SET_VALUE_INVALID is export(:hb-set-value) = (my uint32 $ -1);

enum hb-memory-mode is export(:hb-memory-mode) «
    :HB_MEMORY_MODE_DUPLICATE(0)
    :HB_MEMORY_MODE_READONLY(1)
    :HB_MEMORY_MODE_WRITABLE(2)
    :HB_MEMORY_MODE_READONLY_MAY_MAKE_WRITABLE(3)
    »;

enum hb-direction is export(:hb-direction) «
    :HB_DIRECTION_INVALID(0)
    :HB_DIRECTION_LTR(4)
    HB_DIRECTION_RTL
    HB_DIRECTION_TTB
    HB_DIRECTION_BTT
    »;

enum hb-buffer-content-type is export(:hb-buffer-content-type) «
    HB_BUFFER_CONTENT_TYPE_INVALID
    HB_BUFFER_CONTENT_TYPE_UNICODE
    HB_BUFFER_CONTENT_TYPE_GLYPHS
    »;

enum hb-glyph-flag is export(:hb-glyph-flag) (
    :HB_GLYPH_FLAG_UNSAFE_TO_BREAK(1)
    :HB_GLYPH_FLAG_UNSAFE_TO_CONCAT(2)
    );    

sub hb-tag-enc(Str:D $tag) is export(:hb-tag-enc) {
    my uint32 $enc = 0;
    for $tag.comb {
        $enc *= 256;
        $enc += .ord;
    }
    $enc;
}

sub hb-tag-dec(UInt $enc is copy) is export(:hb-tag-dec) {
    my @c;
    for 1..4 {
        @c.unshift: ($enc mod 256).chr
            if $enc;
        $enc div= 256;
    }
    @c.join;
}

enum hb-script is export(:hb-script) «
    :HB_SCRIPT_COMMON('Zyyy')
    :HB_SCRIPT_INHERITED('Zinh')
    :HB_SCRIPT_UNKNOWN('Zzzz')

    :HB_SCRIPT_ARABIC('Arab')
    :HB_SCRIPT_ARMENIAN('Armn')
    :HB_SCRIPT_BENGALI('Beng')
    :HB_SCRIPT_CYRILLIC('Cyrl')
    :HB_SCRIPT_DEVANAGARI('Deva')
    :HB_SCRIPT_GEORGIAN('Geor')
    :HB_SCRIPT_GREEK('Grek')
    :HB_SCRIPT_GUJARATI('Gujr')
    :HB_SCRIPT_GURMUKHI('Guru')
    :HB_SCRIPT_HANGUL('Hang')
    :HB_SCRIPT_HAN('Hani')
    :HB_SCRIPT_HEBREW('Hebr')
    :HB_SCRIPT_HIRAGANA('Hira')
    :HB_SCRIPT_KANNADA('Knda')
    :HB_SCRIPT_KATAKANA('Kana')
    :HB_SCRIPT_LAO('Laoo')
    :HB_SCRIPT_LATIN('Latn')
    :HB_SCRIPT_MALAYALAM('Mlym')
    :HB_SCRIPT_ORIYA('Orya')
    :HB_SCRIPT_TAMIL('Taml')
    :HB_SCRIPT_TELUGU('Telu')
    :HB_SCRIPT_THAI('Thai')

    :HB_SCRIPT_TIBETAN('Tibt')

    :HB_SCRIPT_BOPOMOFO('Bopo')
    :HB_SCRIPT_BRAILLE('Brai')
    :HB_SCRIPT_CANADIAN_SYLLABICS('Cans')
    :HB_SCRIPT_CHEROKEE('Cher')
    :HB_SCRIPT_ETHIOPIC('Ethi')
    :HB_SCRIPT_KHMER('Khmr')
    :HB_SCRIPT_MONGOLIAN('Mong')
    :HB_SCRIPT_MYANMAR('Mymr')
    :HB_SCRIPT_OGHAM('Ogam')
    :HB_SCRIPT_RUNIC('Runr')
    :HB_SCRIPT_SINHALA('Sinh')
    :HB_SCRIPT_SYRIAC('Syrc')
    :HB_SCRIPT_THAANA('Thaa')
    :HB_SCRIPT_YI('Yiii')

    :HB_SCRIPT_DESERET('Dsrt')
    :HB_SCRIPT_GOTHIC('Goth')
    :HB_SCRIPT_OLD_ITALIC('Ital')

    :HB_SCRIPT_BUHID('Buhd')
    :HB_SCRIPT_HANUNOO('Hano')
    :HB_SCRIPT_TAGALOG('Tglg')
    :HB_SCRIPT_TAGBANWA('Tagb')

    :HB_SCRIPT_CYPRIOT('Cprt')
    :HB_SCRIPT_LIMBU('Limb')
    :HB_SCRIPT_LINEAR_B('Linb')
    :HB_SCRIPT_OSMANYA('Osma')
    :HB_SCRIPT_SHAVIAN('Shaw')
    :HB_SCRIPT_TAI_LE('Tale')
    :HB_SCRIPT_UGARITIC('Ugar')

    :HB_SCRIPT_BUGINESE('Bugi')
    :HB_SCRIPT_COPTIC('Copt')
    :HB_SCRIPT_GLAGOLITIC('Glag')
    :HB_SCRIPT_KHAROSHTHI('Khar')
    :HB_SCRIPT_NEW_TAI_LUE('Talu')
    :HB_SCRIPT_OLD_PERSIAN('Xpeo')
    :HB_SCRIPT_SYLOTI_NAGRI('Sylo')
    :HB_SCRIPT_TIFINAGH('Tfng')

    :HB_SCRIPT_BALINESE('Bali')
    :HB_SCRIPT_CUNEIFORM('Xsux')
    :HB_SCRIPT_NKO('Nkoo')
    :HB_SCRIPT_PHAGS_PA('Phag')
    :HB_SCRIPT_PHOENICIAN('Phnx')

    :HB_SCRIPT_CARIAN('Cari')
    :HB_SCRIPT_CHAM('Cham')
    :HB_SCRIPT_KAYAH_LI('Kali')
    :HB_SCRIPT_LEPCHA('Lepc')
    :HB_SCRIPT_LYCIAN('Lyci')
    :HB_SCRIPT_LYDIAN('Lydi')
    :HB_SCRIPT_OL_CHIKI('Olck')
    :HB_SCRIPT_REJANG('Rjng')
    :HB_SCRIPT_SAURASHTRA('Saur')
    :HB_SCRIPT_SUNDANESE('Sund')
    :HB_SCRIPT_VAI('Vaii')

    :HB_SCRIPT_AVESTAN('Avst')
    :HB_SCRIPT_BAMUM('Bamu')
    :HB_SCRIPT_EGYPTIAN_HIEROGLYPHS('Egyp')
    :HB_SCRIPT_IMPERIAL_ARAMAIC('Armi')
    :HB_SCRIPT_INSCRIPTIONAL_PAHLAVI('Phli')
    :HB_SCRIPT_INSCRIPTIONAL_PARTHIAN('Prti')
    :HB_SCRIPT_JAVANESE('Java')
    :HB_SCRIPT_KAITHI('Kthi')
    :HB_SCRIPT_LISU('Lisu')
    :HB_SCRIPT_MEETEI_MAYEK('Mtei')
    :HB_SCRIPT_OLD_SOUTH_ARABIAN('Sarb')
    :HB_SCRIPT_OLD_TURKIC('Orkh')
    :HB_SCRIPT_SAMARITAN('Samr')
    :HB_SCRIPT_TAI_THAM('Lana')
    :HB_SCRIPT_TAI_VIET('Tavt')

    :HB_SCRIPT_BATAK('Batk')
    :HB_SCRIPT_BRAHMI('Brah')
    :HB_SCRIPT_MANDAIC('Mand')

    :HB_SCRIPT_CHAKMA('Cakm')
    :HB_SCRIPT_MEROITIC_CURSIVE('Merc')
    :HB_SCRIPT_MEROITIC_HIEROGLYPHS('Mero')
    :HB_SCRIPT_MIAO('Plrd')
    :HB_SCRIPT_SHARADA('Shrd')
    :HB_SCRIPT_SORA_SOMPENG('Sora')
    :HB_SCRIPT_TAKRI('Takr')

# Since: 0.9.30

    :HB_SCRIPT_BASSA_VAH('Bass')
    :HB_SCRIPT_CAUCASIAN_ALBANIAN('Aghb')
    :HB_SCRIPT_DUPLOYAN('Dupl')
    :HB_SCRIPT_ELBASAN('Elba')
    :HB_SCRIPT_GRANTHA('Gran')
    :HB_SCRIPT_KHOJKI('Khoj')
    :HB_SCRIPT_KHUDAWADI('Sind')
    :HB_SCRIPT_LINEAR_A('Lina')
    :HB_SCRIPT_MAHAJANI('Mahj')
    :HB_SCRIPT_MANICHAEAN('Mani')
    :HB_SCRIPT_MENDE_KIKAKUI('Mend')
    :HB_SCRIPT_MODI('Modi')
    :HB_SCRIPT_MRO('Mroo')
    :HB_SCRIPT_NABATAEAN('Nbat')
    :HB_SCRIPT_OLD_NORTH_ARABIAN('Narb')
    :HB_SCRIPT_OLD_PERMIC('Perm')
    :HB_SCRIPT_PAHAWH_HMONG('Hmng')
    :HB_SCRIPT_PALMYRENE('Palm')
    :HB_SCRIPT_PAU_CIN_HAU('Pauc')
    :HB_SCRIPT_PSALTER_PAHLAVI('Phlp')
    :HB_SCRIPT_SIDDHAM('Sidd')
    :HB_SCRIPT_TIRHUTA('Tirh')
    :HB_SCRIPT_WARANG_CITI('Wara')

    :HB_SCRIPT_AHOM('Ahom')
    :HB_SCRIPT_ANATOLIAN_HIEROGLYPHS('Hluw')
    :HB_SCRIPT_HATRAN('Hatr')
    :HB_SCRIPT_MULTANI('Mult')
    :HB_SCRIPT_OLD_HUNGARIAN('Hung')
    :HB_SCRIPT_SIGNWRITING('Sgnw')

# Since 1.3.0

    :HB_SCRIPT_ADLAM('Adlm')
    :HB_SCRIPT_BHAIKSUKI('Bhks')
    :HB_SCRIPT_MARCHEN('Marc')
    :HB_SCRIPT_OSAGE('Osge')
    :HB_SCRIPT_TANGUT('Tang')
    :HB_SCRIPT_NEWA('Newa')

# Since 1.6.0

    :HB_SCRIPT_MASARAM_GONDI('Gonm')
    :HB_SCRIPT_NUSHU('Nshu')
    :HB_SCRIPT_SOYOMBO('Soyo')
    :HB_SCRIPT_ZANABAZAR_SQUARE('Zanb')

# Since 1.8.0

    :HB_SCRIPT_DOGRA('Dogr')
    :HB_SCRIPT_GUNJALA_GONDI('Gong')
    :HB_SCRIPT_HANIFI_ROHINGYA('Rohg')
    :HB_SCRIPT_MAKASAR('Maka')
    :HB_SCRIPT_MEDEFAIDRIN('Medf')
    :HB_SCRIPT_OLD_SOGDIAN('Sogo')
    :HB_SCRIPT_SOGDIAN('Sogd')

# Since 2.4.0

    :HB_SCRIPT_ELYMAIC('Elym')
    :HB_SCRIPT_NANDINAGARI('Nand')
    :HB_SCRIPT_NYIAKENG_PUACHUE_HMONG('Hmnp')
    :HB_SCRIPT_WANCHO('Wcho')

# Since 2.6.7

    :HB_SCRIPT_CHORASMIAN('Chrs')
    :HB_SCRIPT_DIVES_AKURU('Diak')
    :HB_SCRIPT_KHITAN_SMALL_SCRIPT('Kits')
    :HB_SCRIPT_YEZIDI('Yezi')

# No script set.
    :HB_SCRIPT_INVALID(''),
    »;
