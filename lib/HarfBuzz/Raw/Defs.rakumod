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
    :HB_SCRIPT_COMMON(hb-tag-enc('Zyyy'))
    :HB_SCRIPT_INHERITED(hb-tag-enc('Zinh'))
    :HB_SCRIPT_UNKNOWN(hb-tag-enc('Zzzz'))

    :HB_SCRIPT_ARABIC(hb-tag-enc('Arab'))
    :HB_SCRIPT_ARMENIAN(hb-tag-enc('Armn'))
    :HB_SCRIPT_BENGALI(hb-tag-enc('Beng'))
    :HB_SCRIPT_CYRILLIC(hb-tag-enc('Cyrl'))
    :HB_SCRIPT_DEVANAGARI(hb-tag-enc('Deva'))
    :HB_SCRIPT_GEORGIAN(hb-tag-enc('Geor'))
    :HB_SCRIPT_GREEK(hb-tag-enc('Grek'))
    :HB_SCRIPT_GUJARATI(hb-tag-enc('Gujr'))
    :HB_SCRIPT_GURMUKHI(hb-tag-enc('Guru'))
    :HB_SCRIPT_HANGUL(hb-tag-enc('Hang'))
    :HB_SCRIPT_HAN(hb-tag-enc('Hani'))
    :HB_SCRIPT_HEBREW(hb-tag-enc('Hebr'))
    :HB_SCRIPT_HIRAGANA(hb-tag-enc('Hira'))
    :HB_SCRIPT_KANNADA(hb-tag-enc('Knda'))
    :HB_SCRIPT_KATAKANA(hb-tag-enc('Kana'))
    :HB_SCRIPT_LAO(hb-tag-enc('Laoo'))
    :HB_SCRIPT_LATIN(hb-tag-enc('Latn'))
    :HB_SCRIPT_MALAYALAM(hb-tag-enc('Mlym'))
    :HB_SCRIPT_ORIYA(hb-tag-enc('Orya'))
    :HB_SCRIPT_TAMIL(hb-tag-enc('Taml'))
    :HB_SCRIPT_TELUGU(hb-tag-enc('Telu'))
    :HB_SCRIPT_THAI(hb-tag-enc('Thai'))

    :HB_SCRIPT_TIBETAN(hb-tag-enc('Tibt'))

    :HB_SCRIPT_BOPOMOFO(hb-tag-enc('Bopo'))
    :HB_SCRIPT_BRAILLE(hb-tag-enc('Brai'))
    :HB_SCRIPT_CANADIAN_SYLLABICS(hb-tag-enc('Cans'))
    :HB_SCRIPT_CHEROKEE(hb-tag-enc('Cher'))
    :HB_SCRIPT_ETHIOPIC(hb-tag-enc('Ethi'))
    :HB_SCRIPT_KHMER(hb-tag-enc('Khmr'))
    :HB_SCRIPT_MONGOLIAN(hb-tag-enc('Mong'))
    :HB_SCRIPT_MYANMAR(hb-tag-enc('Mymr'))
    :HB_SCRIPT_OGHAM(hb-tag-enc('Ogam'))
    :HB_SCRIPT_RUNIC(hb-tag-enc('Runr'))
    :HB_SCRIPT_SINHALA(hb-tag-enc('Sinh'))
    :HB_SCRIPT_SYRIAC(hb-tag-enc('Syrc'))
    :HB_SCRIPT_THAANA(hb-tag-enc('Thaa'))
    :HB_SCRIPT_YI(hb-tag-enc('Yiii'))

    :HB_SCRIPT_DESERET(hb-tag-enc('Dsrt'))
    :HB_SCRIPT_GOTHIC(hb-tag-enc('Goth'))
    :HB_SCRIPT_OLD_ITALIC(hb-tag-enc('Ital'))

    :HB_SCRIPT_BUHID(hb-tag-enc('Buhd'))
    :HB_SCRIPT_HANUNOO(hb-tag-enc('Hano'))
    :HB_SCRIPT_TAGALOG(hb-tag-enc('Tglg'))
    :HB_SCRIPT_TAGBANWA(hb-tag-enc('Tagb'))

    :HB_SCRIPT_CYPRIOT(hb-tag-enc('Cprt'))
    :HB_SCRIPT_LIMBU(hb-tag-enc('Limb'))
    :HB_SCRIPT_LINEAR_B(hb-tag-enc('Linb'))
    :HB_SCRIPT_OSMANYA(hb-tag-enc('Osma'))
    :HB_SCRIPT_SHAVIAN(hb-tag-enc('Shaw'))
    :HB_SCRIPT_TAI_LE(hb-tag-enc('Tale'))
    :HB_SCRIPT_UGARITIC(hb-tag-enc('Ugar'))

    :HB_SCRIPT_BUGINESE(hb-tag-enc('Bugi'))
    :HB_SCRIPT_COPTIC(hb-tag-enc('Copt'))
    :HB_SCRIPT_GLAGOLITIC(hb-tag-enc('Glag'))
    :HB_SCRIPT_KHAROSHTHI(hb-tag-enc('Khar'))
    :HB_SCRIPT_NEW_TAI_LUE(hb-tag-enc('Talu'))
    :HB_SCRIPT_OLD_PERSIAN(hb-tag-enc('Xpeo'))
    :HB_SCRIPT_SYLOTI_NAGRI(hb-tag-enc('Sylo'))
    :HB_SCRIPT_TIFINAGH(hb-tag-enc('Tfng'))

    :HB_SCRIPT_BALINESE(hb-tag-enc('Bali'))
    :HB_SCRIPT_CUNEIFORM(hb-tag-enc('Xsux'))
    :HB_SCRIPT_NKO(hb-tag-enc('Nkoo'))
    :HB_SCRIPT_PHAGS_PA(hb-tag-enc('Phag'))
    :HB_SCRIPT_PHOENICIAN(hb-tag-enc('Phnx'))

    :HB_SCRIPT_CARIAN(hb-tag-enc('Cari'))
    :HB_SCRIPT_CHAM(hb-tag-enc('Cham'))
    :HB_SCRIPT_KAYAH_LI(hb-tag-enc('Kali'))
    :HB_SCRIPT_LEPCHA(hb-tag-enc('Lepc'))
    :HB_SCRIPT_LYCIAN(hb-tag-enc('Lyci'))
    :HB_SCRIPT_LYDIAN(hb-tag-enc('Lydi'))
    :HB_SCRIPT_OL_CHIKI(hb-tag-enc('Olck'))
    :HB_SCRIPT_REJANG(hb-tag-enc('Rjng'))
    :HB_SCRIPT_SAURASHTRA(hb-tag-enc('Saur'))
    :HB_SCRIPT_SUNDANESE(hb-tag-enc('Sund'))
    :HB_SCRIPT_VAI(hb-tag-enc('Vaii'))

    :HB_SCRIPT_AVESTAN(hb-tag-enc('Avst'))
    :HB_SCRIPT_BAMUM(hb-tag-enc('Bamu'))
    :HB_SCRIPT_EGYPTIAN_HIEROGLYPHS(hb-tag-enc('Egyp'))
    :HB_SCRIPT_IMPERIAL_ARAMAIC(hb-tag-enc('Armi'))
    :HB_SCRIPT_INSCRIPTIONAL_PAHLAVI(hb-tag-enc('Phli'))
    :HB_SCRIPT_INSCRIPTIONAL_PARTHIAN(hb-tag-enc('Prti'))
    :HB_SCRIPT_JAVANESE(hb-tag-enc('Java'))
    :HB_SCRIPT_KAITHI(hb-tag-enc('Kthi'))
    :HB_SCRIPT_LISU(hb-tag-enc('Lisu'))
    :HB_SCRIPT_MEETEI_MAYEK(hb-tag-enc('Mtei'))
    :HB_SCRIPT_OLD_SOUTH_ARABIAN(hb-tag-enc('Sarb'))
    :HB_SCRIPT_OLD_TURKIC(hb-tag-enc('Orkh'))
    :HB_SCRIPT_SAMARITAN(hb-tag-enc('Samr'))
    :HB_SCRIPT_TAI_THAM(hb-tag-enc('Lana'))
    :HB_SCRIPT_TAI_VIET(hb-tag-enc('Tavt'))

    :HB_SCRIPT_BATAK(hb-tag-enc('Batk'))
    :HB_SCRIPT_BRAHMI(hb-tag-enc('Brah'))
    :HB_SCRIPT_MANDAIC(hb-tag-enc('Mand'))

    :HB_SCRIPT_CHAKMA(hb-tag-enc('Cakm'))
    :HB_SCRIPT_MEROITIC_CURSIVE(hb-tag-enc('Merc'))
    :HB_SCRIPT_MEROITIC_HIEROGLYPHS(hb-tag-enc('Mero'))
    :HB_SCRIPT_MIAO(hb-tag-enc('Plrd'))
    :HB_SCRIPT_SHARADA(hb-tag-enc('Shrd'))
    :HB_SCRIPT_SORA_SOMPENG(hb-tag-enc('Sora'))
    :HB_SCRIPT_TAKRI(hb-tag-enc('Takr'))

# Since: 0.9.30

    :HB_SCRIPT_BASSA_VAH(hb-tag-enc('Bass'))
    :HB_SCRIPT_CAUCASIAN_ALBANIAN(hb-tag-enc('Aghb'))
    :HB_SCRIPT_DUPLOYAN(hb-tag-enc('Dupl'))
    :HB_SCRIPT_ELBASAN(hb-tag-enc('Elba'))
    :HB_SCRIPT_GRANTHA(hb-tag-enc('Gran'))
    :HB_SCRIPT_KHOJKI(hb-tag-enc('Khoj'))
    :HB_SCRIPT_KHUDAWADI(hb-tag-enc('Sind'))
    :HB_SCRIPT_LINEAR_A(hb-tag-enc('Lina'))
    :HB_SCRIPT_MAHAJANI(hb-tag-enc('Mahj'))
    :HB_SCRIPT_MANICHAEAN(hb-tag-enc('Mani'))
    :HB_SCRIPT_MENDE_KIKAKUI(hb-tag-enc('Mend'))
    :HB_SCRIPT_MODI(hb-tag-enc('Modi'))
    :HB_SCRIPT_MRO(hb-tag-enc('Mroo'))
    :HB_SCRIPT_NABATAEAN(hb-tag-enc('Nbat'))
    :HB_SCRIPT_OLD_NORTH_ARABIAN(hb-tag-enc('Narb'))
    :HB_SCRIPT_OLD_PERMIC(hb-tag-enc('Perm'))
    :HB_SCRIPT_PAHAWH_HMONG(hb-tag-enc('Hmng'))
    :HB_SCRIPT_PALMYRENE(hb-tag-enc('Palm'))
    :HB_SCRIPT_PAU_CIN_HAU(hb-tag-enc('Pauc'))
    :HB_SCRIPT_PSALTER_PAHLAVI(hb-tag-enc('Phlp'))
    :HB_SCRIPT_SIDDHAM(hb-tag-enc('Sidd'))
    :HB_SCRIPT_TIRHUTA(hb-tag-enc('Tirh'))
    :HB_SCRIPT_WARANG_CITI(hb-tag-enc('Wara'))

    :HB_SCRIPT_AHOM(hb-tag-enc('Ahom'))
    :HB_SCRIPT_ANATOLIAN_HIEROGLYPHS(hb-tag-enc('Hluw'))
    :HB_SCRIPT_HATRAN(hb-tag-enc('Hatr'))
    :HB_SCRIPT_MULTANI(hb-tag-enc('Mult'))
    :HB_SCRIPT_OLD_HUNGARIAN(hb-tag-enc('Hung'))
    :HB_SCRIPT_SIGNWRITING(hb-tag-enc('Sgnw'))

# Since 1.3.0

    :HB_SCRIPT_ADLAM(hb-tag-enc('Adlm'))
    :HB_SCRIPT_BHAIKSUKI(hb-tag-enc('Bhks'))
    :HB_SCRIPT_MARCHEN(hb-tag-enc('Marc'))
    :HB_SCRIPT_OSAGE(hb-tag-enc('Osge'))
    :HB_SCRIPT_TANGUT(hb-tag-enc('Tang'))
    :HB_SCRIPT_NEWA(hb-tag-enc('Newa'))

# Since 1.6.0

    :HB_SCRIPT_MASARAM_GONDI(hb-tag-enc('Gonm'))
    :HB_SCRIPT_NUSHU(hb-tag-enc('Nshu'))
    :HB_SCRIPT_SOYOMBO(hb-tag-enc('Soyo'))
    :HB_SCRIPT_ZANABAZAR_SQUARE(hb-tag-enc('Zanb'))

# Since 1.8.0

    :HB_SCRIPT_DOGRA(hb-tag-enc('Dogr'))
    :HB_SCRIPT_GUNJALA_GONDI(hb-tag-enc('Gong'))
    :HB_SCRIPT_HANIFI_ROHINGYA(hb-tag-enc('Rohg'))
    :HB_SCRIPT_MAKASAR(hb-tag-enc('Maka'))
    :HB_SCRIPT_MEDEFAIDRIN(hb-tag-enc('Medf'))
    :HB_SCRIPT_OLD_SOGDIAN(hb-tag-enc('Sogo'))
    :HB_SCRIPT_SOGDIAN(hb-tag-enc('Sogd'))

# Since 2.4.0

    :HB_SCRIPT_ELYMAIC(hb-tag-enc('Elym'))
    :HB_SCRIPT_NANDINAGARI(hb-tag-enc('Nand'))
    :HB_SCRIPT_NYIAKENG_PUACHUE_HMONG(hb-tag-enc('Hmnp'))
    :HB_SCRIPT_WANCHO(hb-tag-enc('Wcho'))

# Since 2.6.7

    :HB_SCRIPT_CHORASMIAN(hb-tag-enc('Chrs'))
    :HB_SCRIPT_DIVES_AKURU(hb-tag-enc('Diak'))
    :HB_SCRIPT_KHITAN_SMALL_SCRIPT(hb-tag-enc('Kits'))
    :HB_SCRIPT_YEZIDI(hb-tag-enc('Yezi'))

# No script set.
    :HB_SCRIPT_INVALID(0),
    »;
