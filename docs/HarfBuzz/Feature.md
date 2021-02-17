[[Raku HarfBuzz Project]](https://harfbuzz-raku.github.io)
 / [[HarfBuzz Module]](https://harfbuzz-raku.github.io/HarfBuzz-raku)
 / [HarfBuzz](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz)
 :: [Feature](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Feature)

class HarfBuzz::Feature
-----------------------

A HarfBuzz font feature

### method tag

```perl6
method tag() returns Str
```

Font tag (e.g. 'kern')

### method enabled

```perl6
method enabled() returns Bool
```

Whether the feature is enabled

### method Str

```perl6
method Str() returns Mu
```

String representation of the enabled/disabled font feature

E.g. `kern` (enabled), or `-kern` (disabled)

