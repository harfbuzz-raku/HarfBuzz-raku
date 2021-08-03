[[Raku HarfBuzz Project]](https://harfbuzz-raku.github.io)
 / [[HarfBuzz Module]](https://harfbuzz-raku.github.io/HarfBuzz-raku)
 / [HarfBuzz](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz)
 :: [Glyph](https://harfbuzz-raku.github.io/HarfBuzz-raku/HarfBuzz/Glyph)

class HarfBuzz::Glyph
---------------------

Represents a shaped glyph

### method x-advance

```raku
method x-advance() returns Numeric
```

Relative/scaled glyph x-advance

### method y-advance

```raku
method y-advance() returns Numeric
```

Relative/scaled glyph y-advance

### method advance

```raku
method advance() returns Complex
```

Relative/scaled glyph x/y advance

### method x-offset

```raku
method x-offset() returns Numeric
```

Relative/scaled glyph x offset

### method y-offset

```raku
method y-offset() returns Numeric
```

Relative/scaled glyph y offset

### method offset

```raku
method offset() returns Complex
```

Relative/scaled glyph x/y offset

### has Associative %!ast

Glyph hash digest

Of the form `%( :$ax, :$ay, :$dx, :$dy, :g($gid))`

