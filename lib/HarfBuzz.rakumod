unit class HarfBuzz:ver<0.0.4>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
