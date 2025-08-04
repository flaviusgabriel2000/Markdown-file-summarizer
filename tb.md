An h1 header
============

Paragraphs are separated by a blank line.

2nd paragraph. *Italic*, **bold**, and `monospace`. Itemized lists
look like:

  * this one
  * that one
  * the other one

Note that the actual text
content starts at 4-columns in.

> Block quotes are
> written like so.
>
> They can span multiple paragraphs,
> if you like.
>
> This is the first level of quoting.
>
> > This is nested blockquote.
>
> Back to the first level.


Use 3 dashes for an em-dash. Use 2 dashes for ranges (ex., "it's all
in chapters 12--14"). Three dots ... will be converted to an ellipsis.
Unicode is supported.



An h2 header
------------

Here's a list of code stuffs:

 1. a for cycle here (from [here](python website)):

        # Let me re-iterate ...
        for i in 1 .. 10 { do-something(i) }

 2. a function like this:

        define foobar() {
            print "Welcome to flavor country!";
        }
    
    Note how the function can be declared as _static_.

 3. one last

        import time
        # Quick, count to ten!
        for i in range(10):
            # (but not *too* quick)
            time.sleep(0.5)
            print i

Note again how the actual text starts at 4 columns in (4 characters
from the left side).



### An h3 header ###

Now a new list:

 * First, get these ingredients:
 * Boil some water.
 * Don't get burned because the water *is hot*
 * Dump 
    everything 
    in the pot and follow
    this algorithm:

        find wooden spoon
        uncover pot
        stir
        cover pot
        balance wooden spoon precariously on pot handle
        wait 10 minutes
        goto first step (or shut off burner when done)

    Do not bump wooden spoon or it will fall.

Notice again how text always lines up on 4-space indents (including
that last line which continues item 3 above).

Here's a link to [a website](http://foo.bar), to a [local
doc](local-doc.html), and to a [section heading in the current
doc](#an-h2-header). Here's a footnote [^1].

[^1]: Footnote text goes here.


# Some other markdown flavors support:

Tables can look like this:
Table: Shoes, their sizes, and what they're made of

A horizontal rule follows.

***

Here's a definition list:

apples
  : Good for making applesauce.
oranges
  : Citrus!
tomatoes
  : There's no "e" in tomatoe.

Again, text is indented 4 spaces. (Put a blank line between each
term/definition pair to spread things out more.)

Here's a "line block":

    | Line one
    |   Line too
    | Line tree

and images can be specified like so:

![example image](example-image.jpg "An exemplary image")

Inline math equations go in like so: $\omega = d\phi / dt$. Display
math should get its own line and be put in in double-dollarsigns:

$$I = \int \rho R^{2} dV$$

## Some stuff we don't really care about

And note that you can backslash-escape any punctuation characters
which you wish to be displayed literally.