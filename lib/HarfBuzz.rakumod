unit class HarfBuzz:ver<0.1.0>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
