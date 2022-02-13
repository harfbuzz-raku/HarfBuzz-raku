unit class HarfBuzz:ver<0.0.11>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
