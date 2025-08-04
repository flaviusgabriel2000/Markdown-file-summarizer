// Usturoi Flavius-Gabriel, 336CC
// Sumarizator de fisiere Markdown


	Ideea generala a codului meu in vederea rezolvarii temei a fost
utilizarea facilitatilor oferite de Flex in limbajul C pentru a analiza
fisierele de intrare Markdown primite. Astfel, mi-am definit cateva stari
care descriu elementele de baza ce trebuie analizate, cum ar fi: ATXHEADER,
PARAGRAPH, LIST, BLOCKQUOTE si CODEBLOCK. Din numele lor, bineinteles, dedu-
cem de ce elemente ale fisierului Markdown se ocupa fiecare in parte.
	Exista si cateva stari suplimentare prefixate cu "FINISH_", care sunt
responsabile de prelucrarea anumitor cazuri particulare ale starilor princi-
pale. De exemplu, FINISH_PARAGRAPH trateaza cazul in care, dupa ce am sumari-
zat paragraful curent prin prima propozitie a acestuia, sa mai existe elemen-
te de accentuare, link-uri sau imagini ce vor trebui afisate si ele la output.
Un alt exemplu este FINISH_LIST_CODEBLOCK, care dupa sumarizarea elementului
de lista curent prin primele 3 cuvinte ale acestuia, sa mai existe tot
in cadrul lui un bloc de cod care, bineinteles, nu va fi ignorat.
	Fisierele de intrare Markdown se paseaza ca argumente in linia de co-
manda, astfel fiind simplu de analizat orice fisier de input numai prin enu-
merarea argumentelor corespunzatoare. De asemenea, am adaugat comentarii
suplimentare in sursa, pentru o intelegere mai buna a codului cand acesta
devine mai greu de urmarit.
