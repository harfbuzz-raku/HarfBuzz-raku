unit class HarfBuzz:ver<0.0.2>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
