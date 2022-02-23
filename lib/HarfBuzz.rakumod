unit class HarfBuzz:ver<0.0.12>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
