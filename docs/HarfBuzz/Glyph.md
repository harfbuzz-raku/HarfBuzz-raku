[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[HarfBuzz Module]](https://pdf-raku.github.io/HarfBuzz-raku)
 / [HarfBuzz](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz)
 :: [Glyph](https://pdf-raku.github.io/HarfBuzz-raku/HarfBuzz/Glyph)

class HarfBuzz::Glyph
---------------------

Represents a shaped glyph

### method x-advance

```perl6
method x-advance() returns Numeric
```

Relative/scaled glyph x-advance

### method y-advance

```perl6
method y-advance() returns Numeric
```

Relative/scaled glyph y-advance

### method advance

```perl6
method advance() returns Complex
```

Relative/scaled glyph x/y advance

### method x-offset

```perl6
method x-offset() returns Numeric
```

Relative/scaled glyph x offset

### method y-offset

```perl6
method y-offset() returns Numeric
```

Relative/scaled glyph y offset

### method offset

```perl6
method offset() returns Complex
```

Relative/scaled glyph x/y offset

### has Associative %!ast

Glyph hash digest

Of the form `%( :$ax, :$ay, :$dx, :$dy, :g($gid))`

