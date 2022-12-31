unit class HarfBuzz:ver<0.1.1>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
