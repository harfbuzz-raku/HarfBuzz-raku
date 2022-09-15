SRC=src
DocProj=harfbuzz-raku.github.io
DocRepo=https://github.com/harfbuzz-raku/$(DocProj)
DocLinker=../$(DocProj)/etc/resolve-links.raku

all :

docs/index.md : README.md
	cp $< $@

docs/%.md : lib/%.rakumod
	@raku -I . -c $<
	raku -I . --doc=Markdown $< \
	| TRAIL=$* raku -p -n  $(DocLinker) \
        > $@

$(DocLinker) :
	(cd .. && git clone $(DocRepo) $(DocProj))

Pod-To-Markdown-installed :
	@raku -M Pod::To::Markdown -c

doc : $(DocLinker) Pod-To-Markdown-installed docs/index.md docs/HarfBuzz.md docs/HarfBuzz/Blob.md docs/HarfBuzz/Buffer.md docs/HarfBuzz/Feature.md docs/HarfBuzz/Face.md docs/HarfBuzz/Font.md docs/HarfBuzz/Glyph.md docs/HarfBuzz/Raw.md docs/HarfBuzz/Raw/Defs.md docs/HarfBuzz/Shaper.md

test : all
	@prove6 -I .

loudtest : all
	@prove6 -I . -v

clean :
	@rm -f README.md docs/*.md docs/HarfBuzz/*.md docs/HarfBuzz/*/*.md


