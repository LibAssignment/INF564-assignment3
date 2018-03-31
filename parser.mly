
/* Syntax Analyzer for Mini Turtle */

%{
  open Ast

%}

/* Declaration of tokens */

%token <int> INT
%token LP RP
%token ADD MINUS MUL DIV
%token EOF NEWLINE
%token FORWARD
/* TO COMPLETE */

/* Priorities and associativities of tokens */

%left ADD MINUS
%left MUL DIV
%nonassoc unary_minus
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
| c = INT
    { Econst c }
| e1 = expr op = binop e2 = expr
    { Ebinop (op, e1, e2) }
| MINUS e = expr %prec unary_minus
    { Ebinop (Sub, (Econst 0), e) }
| LP e = expr RP
    { e }

%inline binop:
| ADD   { Add }
| MINUS { Sub }
| MUL   { Mul }
| DIV   { Div }
