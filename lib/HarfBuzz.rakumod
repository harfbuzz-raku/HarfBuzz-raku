unit class HarfBuzz:ver<0.0.8>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
