unit class HarfBuzz:ver<0.0.9>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
