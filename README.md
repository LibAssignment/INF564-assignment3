# INF564 - TD 3 - Mini-Turtle (in OCaml)
The purpose of this TD is to perform the parsing of a small language Logo (graphic turtle) whose interpreter is provided; you do not need to know the Logo language.

It is necessary to install the `menhir` tool for this TD. The easiest way is to do it using `opam` , with the following commands:
```shell
opam init
eval `opam config`
opam install tuareg merlin menhir
```
(and only the last line if you have already installed `opam`).

We provide you with the basic structure (in the form of a set of Caml files and a Makefile) that you can retrieve here: [mini-turtle.tar.gz](https://www.enseignement.polytechnique.fr/informatique/INF564/td/3-ocaml/mini-turtle.tar.gz). Once this archive is uncompressed with `tar zxvf mini-turtle.tar.gz`, you get a `mini-turtle/` directory containing the following files:

filename    | description
------------|---------------------------------------
turtle.ml(i)| the graphic turtle (complete)
ast.mli     | the abstract syntax of **mini-Turtle** (complete)
lexer.mll   | the lexical analyzer (*to be completed*)
parser.mly  | the parser (*to be completed*)
interp.ml   | the interpreter (complete)
main.ml     | the main program (complete)
Makefile    | to automate compilation (complete)

The code provided compiles but is incomplete. The executable is called `mini-turtle` and applies to a **mini-Turtle** file with the suffix `.logo`, as follows:
```shell
./mini-turtle file.logo
```

## Syntax of mini-turtle
### Lexical conventions
Spaces, tabs, and carriage returns are blanks. Comments are of two different forms: starting with `//` and extending to the end of the line, or surrounded by `(*` and `*)` (not nested). The following identifiers are keywords:
```logo
if else defend penup pendown forward turnleft
turnright color black red green blue
```
An identifier `ident` contains letters, numbers, and `_` characters and begins with a letter. A `integer` constant is a sequence of digits.

### Syntax
Names in italics, such as `expr`, denote nonterminals. The notation `stmt*` denotes a zero, one or more times repetition of the non-terminal `stmt`. The notation `expr*,` denotes a repetition of the non-terminal `expr`, the occurrences being separated by the lexeme `,` (a comma).
```
file ::= def* stmt*
 def ::= def ident ( ident*, ) stmt
stmt ::= penup
       | pendown
       | forward expr
       | turnleft expr
       | turnright expr
       | color color
       | ident ( expr*, )
       | if expr stmt
       | if expr stmt else stmt
       | repeat expr stmt
       | { stmt* }
expr ::= integer
       | ident
       | expr + expr
       | expr - expr
       | expr * expr
       | expr / expr
       | - expr
       | ( expr )
color ::= black | white | red | green | blue
```
The priorities of binary arithmetic operations are usual and unary negation has an even higher priority.

## Work to do
Your job is to complete the `lexer.mll` ([ocamllex](https://caml.inria.fr/pub/docs/manual-ocaml/lexyacc.html)) and `parser.mly` ([Menhir](http://gallium.inria.fr/~fpottier/menhir/manual.pdf)) files. The following questions suggest a way to proceed. It is possible to test each time by modifying the `test.logo` file. The `make` command builds the `mini-turtle/` executable and launches it on the `test.logo` file. A graphic window opens and shows the interpretation of the program. We close the window by pressing a key.

### Question 1. Comments
Complete the `lexer.mll` file to ignore the blanks and comments and return the lexeme EOF when the end of the file is reached. The make command must then open an empty window because the provided test.logo file contains only comments.

### Question 2. Arithmetic expressions
Add the grammar rules needed to recognize arithmetic expressions and the only forward statement. The test.logo file containing
```logo
forward 100
```
must then be accepted and the window must open with the drawing of a horizontal line (100 pixels long). Check that the priorities of the arithmetic operators are the right ones, for example with the following command:
```logo
forward 100 + 1 * 0
```
If the priority is not the right one, a point will be displayed instead of a line.

### Question 3. Other Atomic Instructions
Add the syntax of other atomic instructions, namely, `penup`, `hangown`, `turnleft`, `turnright` and `color`.

Test with programs like
```
forward 100
turnleft 90
color red
forward 100
```

### Question 4. Blocks and control structures
Add the syntax of the blocks and the `if` and `repeat` control structures. The two grammar rules for the `if` statement should cause a shift/reduce conflict. Identify it, understand it and solve it in the way that you think is most appropriate.

Test with programs like
```
repeat 4 {
  forward 100
  turnleft 90
}
```

### Question 5. Functions
Finally, add the syntax of the function declarations and the call of a function in the instructions.
We can test with the files provided in the sub-directory `tests`, namely:

* [hilbert.logo](https://www.enseignement.polytechnique.fr/informatique/INF564/td/3-ocaml/mini-turtle/tests/hilbert.logo)
* [poly.logo](https://www.enseignement.polytechnique.fr/informatique/INF564/td/3-ocaml/mini-turtle/tests/poly.logo)
* [von_koch.logo](https://www.enseignement.polytechnique.fr/informatique/INF564/td/3-ocaml/mini-turtle/tests/von_koch.logo)
* [zigzag.logo](https://www.enseignement.polytechnique.fr/informatique/INF564/td/3-ocaml/mini-turtle/tests/zigzag.logo)

The `make tests` command runs `mini-turtle` on each of these files. The following four images must be obtained (by pressing a key after each image):

![](https://www.enseignement.polytechnique.fr/informatique/INF564/td/3-ocaml/hilbert.png)
![](https://www.enseignement.polytechnique.fr/informatique/INF564/td/3-ocaml/poly.png)
![](https://www.enseignement.polytechnique.fr/informatique/INF564/td/3-ocaml/von_koch.png)
![](https://www.enseignement.polytechnique.fr/informatique/INF564/td/3-ocaml/zigzag.png)

## Solution
[lexer.mll](https://www.enseignement.polytechnique.fr/informatique/INF564/td/3-ocaml/corrige/lexer.mll.html) / [parser.mly](https://www.enseignement.polytechnique.fr/informatique/INF564/td/3-ocaml/corrige/parser.mly.html)
