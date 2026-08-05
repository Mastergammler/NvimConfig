#rg -noPu md '(?!\s)\[\[^\]*\]\]' -t md -debug lua/mg/test/vault  > .index_links
rg -o --no-filename '\[\[[^\]]*\]\]' -t md lua/mg/test/vault  > .index_links

    #local altQM = "rg -o '\\[\\[[^\\]]*\\]\\]' -t md"
