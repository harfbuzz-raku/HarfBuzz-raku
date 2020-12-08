unit class HarfBuzz:ver<0.0.1>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
