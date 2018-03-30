
/* Syntax Analyzer for Mini Turtle */

%{
  open Ast

%}

/* Declaration of tokens */

%token <int> INT
%token EOF NEWLINE
%token FORWARD
/* TO COMPLETE */

/* Priorities and associativities of tokens */

/* TO COMPLETE */

/* Point of entry of grammar */
%start prog

/* Type of values returned by the parser */
%type <Ast.program> prog

%%

/* Grammar rules */

prog:
/* TO COMPLETE */
  NEWLINE* b = list(stmt) EOF
    { { defs = []; main = Sblock b } (* TO MODIFY *) }
;

stmt:
  FORWARD e = expr NEWLINE
    { Sforward e }

expr:
  c = INT
    { Econst c }
