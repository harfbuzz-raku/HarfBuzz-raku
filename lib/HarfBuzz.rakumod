unit class HarfBuzz:ver<0.0.7>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
