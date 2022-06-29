unit class HarfBuzz:ver<0.0.14>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
