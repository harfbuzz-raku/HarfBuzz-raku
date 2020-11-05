unit module HarfBuzz::Raw::Defs;

our $HB is export(:HB) = 'harfbuzz';
our $HB-BIND is export(:HB-BIND) =  %?RESOURCES<libraries/hb-bind>;
our $CLIB is export(:CLIB) = Rakudo::Internals.IS-WIN ?? 'msvcrt' !! Str;

constant hb_bool      is export(:types) = int32;
constant hb_codepoint is export(:types) = uint32;
constant hb_position  is export(:types) = int32;
constant hb_mask      is export(:types) = uint32;
constant hb_tag       is export(:types) = uint32;
constant hb_script    is export(:types) = uint32;
constant hb_direction is export(:types) = uint32;

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

sub hb-tag-enc(*@c) is export(:hb-tag-enc) {
    my uint32 $enc = 0;
    for @c {
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
    :HB_SCRIPT_COMMON(hb-tag-enc('Z','y','y','y'))
    :HB_SCRIPT_INHERITED(hb-tag-enc('Z','i','n','h'))
    :HB_SCRIPT_UNKNOWN(hb-tag-enc('Z','z','z','z'))

    :HB_SCRIPT_ARABIC(hb-tag-enc('A','r','a','b'))
    :HB_SCRIPT_ARMENIAN(hb-tag-enc('A','r','m','n'))
    :HB_SCRIPT_BENGALI(hb-tag-enc('B','e','n','g'))
    :HB_SCRIPT_CYRILLIC(hb-tag-enc('C','y','r','l'))
    :HB_SCRIPT_DEVANAGARI(hb-tag-enc('D','e','v','a'))
    :HB_SCRIPT_GEORGIAN(hb-tag-enc('G','e','o','r'))
    :HB_SCRIPT_GREEK(hb-tag-enc('G','r','e','k'))
    :HB_SCRIPT_GUJARATI(hb-tag-enc('G','u','j','r'))
    :HB_SCRIPT_GURMUKHI(hb-tag-enc('G','u','r','u'))
    :HB_SCRIPT_HANGUL(hb-tag-enc('H','a','n','g'))
    :HB_SCRIPT_HAN(hb-tag-enc('H','a','n','i'))
    :HB_SCRIPT_HEBREW(hb-tag-enc('H','e','b','r'))
    :HB_SCRIPT_HIRAGANA(hb-tag-enc('H','i','r','a'))
    :HB_SCRIPT_KANNADA(hb-tag-enc('K','n','d','a'))
    :HB_SCRIPT_KATAKANA(hb-tag-enc('K','a','n','a'))
    :HB_SCRIPT_LAO(hb-tag-enc('L','a','o','o'))
    :HB_SCRIPT_LATIN(hb-tag-enc('L','a','t','n'))
    :HB_SCRIPT_MALAYALAM(hb-tag-enc('M','l','y','m'))
    :HB_SCRIPT_ORIYA(hb-tag-enc('O','r','y','a'))
    :HB_SCRIPT_TAMIL(hb-tag-enc('T','a','m','l'))
    :HB_SCRIPT_TELUGU(hb-tag-enc('T','e','l','u'))
    :HB_SCRIPT_THAI(hb-tag-enc('T','h','a','i'))

    :HB_SCRIPT_TIBETAN(hb-tag-enc('T','i','b','t'))

    :HB_SCRIPT_BOPOMOFO(hb-tag-enc('B','o','p','o'))
    :HB_SCRIPT_BRAILLE(hb-tag-enc('B','r','a','i'))
    :HB_SCRIPT_CANADIAN_SYLLABICS(hb-tag-enc('C','a','n','s'))
    :HB_SCRIPT_CHEROKEE(hb-tag-enc('C','h','e','r'))
    :HB_SCRIPT_ETHIOPIC(hb-tag-enc('E','t','h','i'))
    :HB_SCRIPT_KHMER(hb-tag-enc('K','h','m','r'))
    :HB_SCRIPT_MONGOLIAN(hb-tag-enc('M','o','n','g'))
    :HB_SCRIPT_MYANMAR(hb-tag-enc('M','y','m','r'))
    :HB_SCRIPT_OGHAM(hb-tag-enc('O','g','a','m'))
    :HB_SCRIPT_RUNIC(hb-tag-enc('R','u','n','r'))
    :HB_SCRIPT_SINHALA(hb-tag-enc('S','i','n','h'))
    :HB_SCRIPT_SYRIAC(hb-tag-enc('S','y','r','c'))
    :HB_SCRIPT_THAANA(hb-tag-enc('T','h','a','a'))
    :HB_SCRIPT_YI(hb-tag-enc('Y','i','i','i'))

    :HB_SCRIPT_DESERET(hb-tag-enc('D','s','r','t'))
    :HB_SCRIPT_GOTHIC(hb-tag-enc('G','o','t','h'))
    :HB_SCRIPT_OLD_ITALIC(hb-tag-enc('I','t','a','l'))

    :HB_SCRIPT_BUHID(hb-tag-enc('B','u','h','d'))
    :HB_SCRIPT_HANUNOO(hb-tag-enc('H','a','n','o'))
    :HB_SCRIPT_TAGALOG(hb-tag-enc('T','g','l','g'))
    :HB_SCRIPT_TAGBANWA(hb-tag-enc('T','a','g','b'))

    :HB_SCRIPT_CYPRIOT(hb-tag-enc('C','p','r','t'))
    :HB_SCRIPT_LIMBU(hb-tag-enc('L','i','m','b'))
    :HB_SCRIPT_LINEAR_B(hb-tag-enc('L','i','n','b'))
    :HB_SCRIPT_OSMANYA(hb-tag-enc('O','s','m','a'))
    :HB_SCRIPT_SHAVIAN(hb-tag-enc('S','h','a','w'))
    :HB_SCRIPT_TAI_LE(hb-tag-enc('T','a','l','e'))
    :HB_SCRIPT_UGARITIC(hb-tag-enc('U','g','a','r'))

    :HB_SCRIPT_BUGINESE(hb-tag-enc('B','u','g','i'))
    :HB_SCRIPT_COPTIC(hb-tag-enc('C','o','p','t'))
    :HB_SCRIPT_GLAGOLITIC(hb-tag-enc('G','l','a','g'))
    :HB_SCRIPT_KHAROSHTHI(hb-tag-enc('K','h','a','r'))
    :HB_SCRIPT_NEW_TAI_LUE(hb-tag-enc('T','a','l','u'))
    :HB_SCRIPT_OLD_PERSIAN(hb-tag-enc('X','p','e','o'))
    :HB_SCRIPT_SYLOTI_NAGRI(hb-tag-enc('S','y','l','o'))
    :HB_SCRIPT_TIFINAGH(hb-tag-enc('T','f','n','g'))

    :HB_SCRIPT_BALINESE(hb-tag-enc('B','a','l','i'))
    :HB_SCRIPT_CUNEIFORM(hb-tag-enc('X','s','u','x'))
    :HB_SCRIPT_NKO(hb-tag-enc('N','k','o','o'))
    :HB_SCRIPT_PHAGS_PA(hb-tag-enc('P','h','a','g'))
    :HB_SCRIPT_PHOENICIAN(hb-tag-enc('P','h','n','x'))

    :HB_SCRIPT_CARIAN(hb-tag-enc('C','a','r','i'))
    :HB_SCRIPT_CHAM(hb-tag-enc('C','h','a','m'))
    :HB_SCRIPT_KAYAH_LI(hb-tag-enc('K','a','l','i'))
    :HB_SCRIPT_LEPCHA(hb-tag-enc('L','e','p','c'))
    :HB_SCRIPT_LYCIAN(hb-tag-enc('L','y','c','i'))
    :HB_SCRIPT_LYDIAN(hb-tag-enc('L','y','d','i'))
    :HB_SCRIPT_OL_CHIKI(hb-tag-enc('O','l','c','k'))
    :HB_SCRIPT_REJANG(hb-tag-enc('R','j','n','g'))
    :HB_SCRIPT_SAURASHTRA(hb-tag-enc('S','a','u','r'))
    :HB_SCRIPT_SUNDANESE(hb-tag-enc('S','u','n','d'))
    :HB_SCRIPT_VAI(hb-tag-enc('V','a','i','i'))

    :HB_SCRIPT_AVESTAN(hb-tag-enc('A','v','s','t'))
    :HB_SCRIPT_BAMUM(hb-tag-enc('B','a','m','u'))
    :HB_SCRIPT_EGYPTIAN_HIEROGLYPHS(hb-tag-enc('E','g','y','p'))
    :HB_SCRIPT_IMPERIAL_ARAMAIC(hb-tag-enc('A','r','m','i'))
    :HB_SCRIPT_INSCRIPTIONAL_PAHLAVI(hb-tag-enc('P','h','l','i'))
    :HB_SCRIPT_INSCRIPTIONAL_PARTHIAN(hb-tag-enc('P','r','t','i'))
    :HB_SCRIPT_JAVANESE(hb-tag-enc('J','a','v','a'))
    :HB_SCRIPT_KAITHI(hb-tag-enc('K','t','h','i'))
    :HB_SCRIPT_LISU(hb-tag-enc('L','i','s','u'))
    :HB_SCRIPT_MEETEI_MAYEK(hb-tag-enc('M','t','e','i'))
    :HB_SCRIPT_OLD_SOUTH_ARABIAN(hb-tag-enc('S','a','r','b'))
    :HB_SCRIPT_OLD_TURKIC(hb-tag-enc('O','r','k','h'))
    :HB_SCRIPT_SAMARITAN(hb-tag-enc('S','a','m','r'))
    :HB_SCRIPT_TAI_THAM(hb-tag-enc('L','a','n','a'))
    :HB_SCRIPT_TAI_VIET(hb-tag-enc('T','a','v','t'))

    :HB_SCRIPT_BATAK(hb-tag-enc('B','a','t','k'))
    :HB_SCRIPT_BRAHMI(hb-tag-enc('B','r','a','h'))
    :HB_SCRIPT_MANDAIC(hb-tag-enc('M','a','n','d'))

    :HB_SCRIPT_CHAKMA(hb-tag-enc('C','a','k','m'))
    :HB_SCRIPT_MEROITIC_CURSIVE(hb-tag-enc('M','e','r','c'))
    :HB_SCRIPT_MEROITIC_HIEROGLYPHS(hb-tag-enc('M','e','r','o'))
    :HB_SCRIPT_MIAO(hb-tag-enc('P','l','r','d'))
    :HB_SCRIPT_SHARADA(hb-tag-enc('S','h','r','d'))
    :HB_SCRIPT_SORA_SOMPENG(hb-tag-enc('S','o','r','a'))
    :HB_SCRIPT_TAKRI(hb-tag-enc('T','a','k','r'))

# Since: 0.9.30

    :HB_SCRIPT_BASSA_VAH(hb-tag-enc('B','a','s','s'))
    :HB_SCRIPT_CAUCASIAN_ALBANIAN(hb-tag-enc('A','g','h','b'))
    :HB_SCRIPT_DUPLOYAN(hb-tag-enc('D','u','p','l'))
    :HB_SCRIPT_ELBASAN(hb-tag-enc('E','l','b','a'))
    :HB_SCRIPT_GRANTHA(hb-tag-enc('G','r','a','n'))
    :HB_SCRIPT_KHOJKI(hb-tag-enc('K','h','o','j'))
    :HB_SCRIPT_KHUDAWADI(hb-tag-enc('S','i','n','d'))
    :HB_SCRIPT_LINEAR_A(hb-tag-enc('L','i','n','a'))
    :HB_SCRIPT_MAHAJANI(hb-tag-enc('M','a','h','j'))
    :HB_SCRIPT_MANICHAEAN(hb-tag-enc('M','a','n','i'))
    :HB_SCRIPT_MENDE_KIKAKUI(hb-tag-enc('M','e','n','d'))
    :HB_SCRIPT_MODI(hb-tag-enc('M','o','d','i'))
    :HB_SCRIPT_MRO(hb-tag-enc('M','r','o','o'))
    :HB_SCRIPT_NABATAEAN(hb-tag-enc('N','b','a','t'))
    :HB_SCRIPT_OLD_NORTH_ARABIAN(hb-tag-enc('N','a','r','b'))
    :HB_SCRIPT_OLD_PERMIC(hb-tag-enc('P','e','r','m'))
    :HB_SCRIPT_PAHAWH_HMONG(hb-tag-enc('H','m','n','g'))
    :HB_SCRIPT_PALMYRENE(hb-tag-enc('P','a','l','m'))
    :HB_SCRIPT_PAU_CIN_HAU(hb-tag-enc('P','a','u','c'))
    :HB_SCRIPT_PSALTER_PAHLAVI(hb-tag-enc('P','h','l','p'))
    :HB_SCRIPT_SIDDHAM(hb-tag-enc('S','i','d','d'))
    :HB_SCRIPT_TIRHUTA(hb-tag-enc('T','i','r','h'))
    :HB_SCRIPT_WARANG_CITI(hb-tag-enc('W','a','r','a'))

    :HB_SCRIPT_AHOM(hb-tag-enc('A','h','o','m'))
    :HB_SCRIPT_ANATOLIAN_HIEROGLYPHS(hb-tag-enc('H','l','u','w'))
    :HB_SCRIPT_HATRAN(hb-tag-enc('H','a','t','r'))
    :HB_SCRIPT_MULTANI(hb-tag-enc('M','u','l','t'))
    :HB_SCRIPT_OLD_HUNGARIAN(hb-tag-enc('H','u','n','g'))
    :HB_SCRIPT_SIGNWRITING(hb-tag-enc('S','g','n','w'))

# Since 1.3.0

    :HB_SCRIPT_ADLAM(hb-tag-enc('A','d','l','m'))
    :HB_SCRIPT_BHAIKSUKI(hb-tag-enc('B','h','k','s'))
    :HB_SCRIPT_MARCHEN(hb-tag-enc('M','a','r','c'))
    :HB_SCRIPT_OSAGE(hb-tag-enc('O','s','g','e'))
    :HB_SCRIPT_TANGUT(hb-tag-enc('T','a','n','g'))
    :HB_SCRIPT_NEWA(hb-tag-enc('N','e','w','a'))

# Since 1.6.0

    :HB_SCRIPT_MASARAM_GONDI(hb-tag-enc('G','o','n','m'))
    :HB_SCRIPT_NUSHU(hb-tag-enc('N','s','h','u'))
    :HB_SCRIPT_SOYOMBO(hb-tag-enc('S','o','y','o'))
    :HB_SCRIPT_ZANABAZAR_SQUARE(hb-tag-enc('Z','a','n','b'))

# Since 1.8.0

    :HB_SCRIPT_DOGRA(hb-tag-enc('D','o','g','r'))
    :HB_SCRIPT_GUNJALA_GONDI(hb-tag-enc('G','o','n','g'))
    :HB_SCRIPT_HANIFI_ROHINGYA(hb-tag-enc('R','o','h','g'))
    :HB_SCRIPT_MAKASAR(hb-tag-enc('M','a','k','a'))
    :HB_SCRIPT_MEDEFAIDRIN(hb-tag-enc('M','e','d','f'))
    :HB_SCRIPT_OLD_SOGDIAN(hb-tag-enc('S','o','g','o'))
    :HB_SCRIPT_SOGDIAN(hb-tag-enc('S','o','g','d'))

# Since 2.4.0

    :HB_SCRIPT_ELYMAIC(hb-tag-enc('E','l','y','m'))
    :HB_SCRIPT_NANDINAGARI(hb-tag-enc('N','a','n','d'))
    :HB_SCRIPT_NYIAKENG_PUACHUE_HMONG(hb-tag-enc('H','m','n','p'))
    :HB_SCRIPT_WANCHO(hb-tag-enc('W','c','h','o'))

# Since 2.6.7

    :HB_SCRIPT_CHORASMIAN(hb-tag-enc('C','h','r','s'))
    :HB_SCRIPT_DIVES_AKURU(hb-tag-enc('D','i','a','k'))
    :HB_SCRIPT_KHITAN_SMALL_SCRIPT(hb-tag-enc('K','i','t','s'))
    :HB_SCRIPT_YEZIDI(hb-tag-enc('Y','e','z','i'))

# No script set.
    :HB_SCRIPT_INVALID(0),
    »;
