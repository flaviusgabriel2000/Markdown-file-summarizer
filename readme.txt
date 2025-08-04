// Markdown file summarizer


	The idea of my code to implement the project was to use the facilities provided
by Flex in the C language to analyze the received Markdown input files.
Thus, I defined several states that describe the basic elements that need
to be analyzed, such as: ATXHEADER, PARAGRAPH, LIST, BLOCKQUOTE and CODEBLOCK.
From their names, of course, we can deduce which elements of the Markdown file
each one deals with.
	There are also some additional states prefixed with "FINISH_", which are
responsible for processing certain special cases of the main states. For example,
FINISH_PARAGRAPH handles the case where, after summarizing the current paragraph
by its first sentence, there are still emphasis elements, links or images that will
also need to be displayed in the output. Another example is FINISH_LIST_CODEBLOCK,
which after summarizing the current list item by its first 3 words, there is still 
a code block within it that, of course, will not be ignored.
	Markdown input files are passed as arguments on the command line, making it
easy to parse any input file just by listing the appropriate arguments. I've also
added additional comments in the source, for better understanding when the code
gets harder to follow.