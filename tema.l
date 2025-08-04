 /* Usturoi Flavius-Gabriel, 336CC */

%option noyywrap

%{
    #include <stdio.h>

    #define MAX_BLOCKQUOTE_WORDS 5
    #define MAX_LIST_NO_ELEMENTS 3
    #define MAX_HEADER_LEVEL 3
    #define SLASH_COUNT 12

    int header_level = 0, list_no_elements = 0, blockquote_words = 0;

    void print_setext(int level, char *yytext, int yyleng) {
        for (int i = 0; i < level; i++) {
            printf(" ");
        }
        printf("+ ");
        for (int i = 0; i < (yyleng - 1) / 2; i++) {
            printf("%c", yytext[i]);
        }
        printf("\n");
    }
%}

%s ATXHEADER PARAGRAPH FINISH_PARAGRAPH LIST FINISH_LIST BLOCKQUOTE LIST_BLOCKQUOTE FINISH_LIST_BLOCKQUOTE CODEBLOCK LIST_CODEBLOCK FINISH_LIST_CODEBLOCK

text [a-zA-Z0-9': ]+
word [a-zA-Z0-9')(,\"`\</\[\]&-]+
number [0-9]+
space [ ]
tab [\t]

h_word [a-zA-Z0-9')(,\"`</\[\]!&-]+
highlighted_elem \*({h_word}{space}?)*\*|\*\*({h_word}{space}?)*\*\*|_({h_word}{space}?)*_|__({h_word}{space}?)*__

link \[([^\[\]]|\n)*\]\(([^\(\)]|\n)*\)
image !\[.*\]\(.*\)
list {space}{0,3}(\*|\+|\-|{number}\.)({space}+|{tab})
blockquote (>{space})+
blockquote_text [a-zA-Z0-9'\,\*_\\/@#$%^&+\)(-]+
code_block_begin {space}{4,}|\t+
hr (\*{space}?){3,}|(\-{space}?){3,}|(\_{space}?){3,}

%%

 /* The atx header state */
<INITIAL>[#]{1,6}{space} {
    header_level = yyleng - 1; 
    if (header_level > MAX_HEADER_LEVEL) {
        header_level = MAX_HEADER_LEVEL;
    } 
    BEGIN(ATXHEADER);
}
<ATXHEADER>{text} {
    for (int i = 0; i < 3 * header_level; i++) {
        printf(" ");
    }
    printf("+ %s\n", yytext);
    BEGIN(INITIAL);
}

 /* The Setext header */
<INITIAL>{text}\n[=]+ {
    // Same length underlining
    if ((yyleng - 1) % 2 == 0) {
        header_level = 1;
        print_setext(3 * header_level, yytext, yyleng);
    }
}

<INITIAL>{text}\n[-]+ {
    if ((yyleng - 1) % 2 == 0) {
        header_level = 2;
        print_setext(3 * header_level, yytext, yyleng);
    }
}

<INITIAL>{hr} {
    for (int i = 0; i < 3 * header_level; i++) {
        printf(" ");
    }
    for (int i = 0; i < SLASH_COUNT; i++) {
        printf("/");
    }
    printf("\n");
}

<INITIAL>[\^$~].* ;

 /* Paragraphs should normally be unindented */
<INITIAL>{word}{space}? {
    for (int i = 0; i < 3 * header_level; i++) {
        printf(" ");
    }
    printf(":%s", yytext);
    BEGIN(PARAGRAPH);
}

 /* Print the paragraph text */
<PARAGRAPH>{word}{space}?>? {
    printf("%s", yytext);
}

<PARAGRAPH>\*|_ {
    printf("%s", yytext);
}

<PARAGRAPH>\n {
    printf(" ");
}


 /* End of the paragraph */
<PARAGRAPH>\n\n {
    printf (":\n");
    BEGIN(INITIAL);
}

 /* Just a solitary highlighted element */
<INITIAL>{highlighted_elem} {
    for (int i = 0; i < 3 * header_level; i++) {
        printf(" ");
    }
    printf("<");
    for (int i = 0; i < yyleng; i++) {
        if (yytext[i] != '*' && yytext[i] != '_') {
            printf("%c", yytext[i]);
        }
    }
    printf(">\n");
}

 /* A highlighted element is at the beginning of the paragraph */
<INITIAL>{highlighted_elem}{space} {
    yytext[yyleng - 1] = '\0';
    for (int i = 0; i < 3 * header_level; i++) {
        printf(" ");
    }
    printf(":<");
    for (int i = 0; i < yyleng; i++) {
        if (yytext[i] != '*' && yytext[i] != '_') {
            printf("%c", yytext[i]);
        }
    }
    printf("> ");
    BEGIN(PARAGRAPH);
}

<PARAGRAPH>{highlighted_elem} {
    printf("<");
    for (int i = 0; i < yyleng; i++) {
        if (yytext[i] != '*' && yytext[i] != '_') {
            printf("%c", yytext[i]);
        }
    }
    printf(">");
}

<PARAGRAPH>{highlighted_elem}{space} {
    printf("<");
    for (int i = 0; i < yyleng - 1; i++) {
        if (yytext[i] != '*' && yytext[i] != '_') {
            printf("%c", yytext[i]);
        }
    }
    printf("> ");
}

 /* Punctuation mark other than comma or a blank line
    means the end of the paragraph */
<PARAGRAPH>[\.?!;:]+ {
    BEGIN(FINISH_PARAGRAPH);
}

 /* We finished the current paragraph or the current list
    item, but there may be some extra highlighted elements */
<FINISH_PARAGRAPH,FINISH_LIST>{highlighted_elem} {
    printf(" <");
    for (int i = 0; i < yyleng; i++) {
        if (yytext[i] != '*' && yytext[i] != '_') {
            printf("%c", yytext[i]);
        }
    }
    printf(">");
}

<FINISH_PARAGRAPH>\n\n {
    printf(":\n");
    BEGIN(INITIAL);
}


 /* Links and images */
<INITIAL>{link} {
    for (int i = 0; i < 3 * header_level; i++) {
        printf(" ");
    }
    printf(":[@");
    for (int i = 1; i < yyleng; i++) {
        if (yytext[i] == ']') {
            printf("]");
            break;
        } else if (yytext[i] != '\n') {
            printf("%c", yytext[i]);
        } else {
            printf(" ");
        }
    }
    printf (" ");
    BEGIN(PARAGRAPH);
    
}

<PARAGRAPH,LIST>{link} {
    printf("[@");
    for (int i = 1; i < yyleng; i++) {
        if (yytext[i] == ']') {
            printf("]");
            break;
        } else if (yytext[i] != '\n') {
            printf("%c", yytext[i]);
        } else {
            printf(" ");
        }
    }
}

<FINISH_PARAGRAPH,FINISH_LIST>{link} {
    printf(" [@");
    for (int i = 1; i < yyleng; i++) {
        if (yytext[i] == ']') {
            printf("]");
            break;
        } else if (yytext[i] != '\n') {
            printf("%c", yytext[i]);
        } else {
            printf(" ");
        }
    }
}

{image} {
    for (int i = 0; i < 3 * header_level; i++) {
        printf(" ");
    }
    printf("[!");
    for (int i = 2; i < yyleng; i++) {
        if (yytext[i] == ']') {
            printf("]");
            break;
        }
        printf("%c", yytext[i]);
    }
    printf ("\n");
}

 /* Lists */
<INITIAL>{list} {
    for (int i = 0; i < 3 * (header_level + 1); i++) {
        printf(" ");
    }
    printf("[");
    BEGIN(LIST);
}

<LIST>{word} {
    printf("%s", yytext);
    list_no_elements++;

    // We summarized the current list item, but we still need to look for
    // highlighted elements, code blocks, blockquotes, links etc
    if (list_no_elements == MAX_LIST_NO_ELEMENTS) {
        BEGIN(FINISH_LIST);
    }
}

 /* Go to the next list item */
<LIST,FINISH_LIST>{list} {
    list_no_elements = 0;
    printf("; ");
    BEGIN(LIST);
}

<LIST>{highlighted_elem} {
    printf("<");
    for (int i = 0; i < yyleng; i++) {
        if (yytext[i] != '*' && yytext[i] != '_') {
            printf("%c", yytext[i]);
        }
    }
    printf(">");
    list_no_elements++;
    if (list_no_elements == MAX_LIST_NO_ELEMENTS) {
        BEGIN(FINISH_LIST);
    }
}

 /* Possible subsequent paragraph of the current list item */
<LIST,FINISH_LIST>\n+{space}{3,} {
    if (list_no_elements == MAX_LIST_NO_ELEMENTS) {
        BEGIN(FINISH_LIST);
    } else {
        BEGIN(LIST);
    }
}

<LIST>. {
    printf("%s", yytext);
}

<LIST,FINISH_LIST>\n\n {
    list_no_elements = 0;
    printf("]\n");
    BEGIN(INITIAL);
}

 /* Blockquotes */
<INITIAL>{blockquote} {
    for (int i = 0; i < 3 * (header_level + 1); i++) {
        printf(" ");
    }
    printf("\"");
    BEGIN(BLOCKQUOTE);
}

<BLOCKQUOTE>{blockquote_text} {
    blockquote_words++;
    if (blockquote_words == MAX_BLOCKQUOTE_WORDS) {
        printf("%s\"\n", yytext);
    } else if (blockquote_words < MAX_BLOCKQUOTE_WORDS) {
        printf("%s ", yytext);
    }
}

<BLOCKQUOTE>\n\n {
    blockquote_words = 0;
    BEGIN(INITIAL);
}

 /* Blockquotes within a list */

 /* To put a blockquote within a list item, the blockquote's `>`
    delimiters need to be indented: */
<LIST>\n+({space}{4,}|\t+){blockquote} {
    printf(" \"");
    BEGIN(LIST_BLOCKQUOTE);
}

<FINISH_LIST>\n+({space}{4,}|\t+){blockquote} {
    printf(" \"");
    BEGIN(FINISH_LIST_BLOCKQUOTE);
}

<LIST_BLOCKQUOTE>{blockquote_text} {
    blockquote_words++;
    if (blockquote_words == MAX_BLOCKQUOTE_WORDS) {
        printf("%s\"", yytext);
        blockquote_words = 0;
        BEGIN(LIST);
    } else if (blockquote_words < MAX_BLOCKQUOTE_WORDS) {
        printf("%s ", yytext);
    }
}

<FINISH_LIST_BLOCKQUOTE>{blockquote_text} {
    blockquote_words++;
    if (blockquote_words == MAX_BLOCKQUOTE_WORDS) {
        printf("%s\"", yytext);
        blockquote_words = 0;
        BEGIN(FINISH_LIST);
    } else if (blockquote_words < MAX_BLOCKQUOTE_WORDS) {
        printf("%s ", yytext);
    }
}

<LIST_BLOCKQUOTE>\n {
    blockquote_words = 0;
    BEGIN(LIST);
}

<FINISH_LIST_BLOCKQUOTE>\n\n {
    blockquote_words = 0;
    BEGIN(FINISH_LIST);
}

 /* Code blocks */
<INITIAL>{code_block_begin}.+\n {
    for (int i = 0; i < 3 * header_level; i++) {
        printf(" ");
    }
    printf("[code]\n");
    BEGIN(CODEBLOCK);
}

<CODEBLOCK>{code_block_begin}.+\n ;

 /* Unindented line or a blank line means the end of the code block */
<CODEBLOCK>{space}{0,3}{word}|\n\n {
    yyless(-1);
    BEGIN(INITIAL);   
}

 /* Code blocks within a list */

 /* At least one blank line to be considered a code block */
<LIST>\n{2,}{code_block_begin}[^>].* {
    printf(" [code]");
    BEGIN(LIST_CODEBLOCK);
}

<FINISH_LIST>\n{2,}{code_block_begin}[^>].* { 
    printf(" [code]");
    BEGIN(FINISH_LIST_CODEBLOCK);
}

<LIST_CODEBLOCK,FINISH_LIST_CODEBLOCK>{code_block_begin}^{highlighted_elem} ;

<LIST_CODEBLOCK,FINISH_LIST_CODEBLOCK>{highlighted_elem} {
    printf(" <");
    for (int i = 0; i < yyleng; i++) {
        if (yytext[i] != '*' && yytext[i] != '_') {
            printf("%c", yytext[i]);
        }
    }
    printf(">");
}

 /* Used to make a sure a subsequent paragraph is not interpreted as a code block */
<LIST_CODEBLOCK,FINISH_LIST_CODEBLOCK>\n\n{code_block_begin}.* {
    list_no_elements = 0;
    BEGIN(LIST);
}

<LIST_CODEBLOCK,FINISH_LIST_CODEBLOCK>\n\n {
    printf("]\n");
    list_no_elements = 0;
    BEGIN(INITIAL);
}

<LIST_CODEBLOCK>\n\n{list} {
    yyless(-1);
    list_no_elements = 0;
    BEGIN(LIST);   
}

<FINISH_LIST_CODEBLOCK>\n\n{list} {
    yyless(1);
    list_no_elements = 0;
    BEGIN(FINISH_LIST);   
}



.|\n ;

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        return -1;
    }

    yyin = fopen(argv[1],"r");
    if (!yyin) {
        fprintf(stderr, "Could not open file!\n");
        exit(1);
    }

	yylex();
    printf("\n");

	fclose(yyin);
}