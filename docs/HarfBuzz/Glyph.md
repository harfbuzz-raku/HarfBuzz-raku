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

### method x-bearing

```raku
method x-bearing() returns Numeric
```

left side of glyph from origin

### method y-bearing

```raku
method y-bearing() returns Numeric
```

top side of glyph from origin

### method bearing

```raku
method bearing() returns Complex
```

position of glyph from origin

### method size

```raku
method size() returns Complex
```

size of glyph

### has Associative %!ast

Glyph hash digest

Of the form `%( :$ax, :$ay, :$dx, :$dy, :g($gid), :$c)`

where

  * *dx* - pre X offset

  * *dy* - pre Y offset

  * *ax* - post X advance

  * *ay* - post Y advance

  * *g* - Glyph ID

  * *c* - Input character position

