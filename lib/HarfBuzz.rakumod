unit class HarfBuzz:ver<0.1.7>;
use HarfBuzz::Raw;

#| Returns the version of the nativeHarfBuzz library
method version returns Version {
    hb_version(my uint32 $major, my uint32 $minor, my uint32 $micro);
    Version.new: [$major, $minor, $micro];
}
