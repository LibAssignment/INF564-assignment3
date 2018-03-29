
/* Analyseur syntaxique pour mini-Turtle */

%{
  open Ast

%}

/* Déclaration des tokens */

%token EOF
/* À COMPLÉTER */

/* Priorités et associativités des tokens */

/* À COMPLÉTER */

/* Point d'entrée de la grammaire */
%start prog

/* Type des valeurs renvoyées par l'analyseur syntaxique */
%type <Ast.program> prog

%%

/* Règles de grammaire */

prog:
  /* À COMPLÉTER */ EOF
    { { defs = []; main = Sblock [] } (* À MODIFIER *) }
;


