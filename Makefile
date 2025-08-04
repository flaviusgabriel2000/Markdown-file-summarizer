# Usturoi Flavius-Gabriel, 336CC 

build:
	flex tema.l
	gcc lex.yy.c -o tema

.PHONY: clean

clean:
	rm tema lex.yy.c