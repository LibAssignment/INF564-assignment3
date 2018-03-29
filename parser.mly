
/* Syntax Analyzer for Mini Turtle */

%{
  open Ast

%}

/* Declaration of tokens */

%token EOF
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
  /* TO COMPLETE */ EOF
    { { defs = []; main = Sblock [] } (* TO MODIFY *) }
;
