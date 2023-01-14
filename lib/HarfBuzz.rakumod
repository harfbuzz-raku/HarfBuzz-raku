unit class HarfBuzz:ver<0.1.2>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
