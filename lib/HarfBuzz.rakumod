unit class HarfBuzz:ver<0.0.13>;
use HarfBuzz::Raw;

method version {
    HarfBuzz::Raw::version();
}
