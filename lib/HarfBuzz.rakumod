unit class HarfBuzz:ver<0.0.5>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
