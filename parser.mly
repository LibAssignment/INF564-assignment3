
/* Syntax Analyzer for Mini Turtle */

%{
open Ast
let minus e = Ebinop (Sub, (Econst 0), e)
%}

/* Declaration of tokens */

%token <int> INT
%token <Turtle.color> COLOR
%token <string> IDENT
%token LP RP
%token ADD MINUS MUL DIV
%token EOF NEWLINE
%token PENUP PENDOWN TURNLEFT TURNRIGHT FORWARD SETCOLOR
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
  s = simple_stmt NEWLINE*
    { s }

simple_stmt:
| PENUP   { Spenup }
| PENDOWN { Spendown }
| TURNLEFT e = expr
    { Sturn e }
| TURNRIGHT e = expr
    { Sturn (minus e) }
| FORWARD e = expr
    { Sforward e }
| SETCOLOR c = COLOR
    { Scolor c }

expr:
| c = INT
    { Econst c }
| e1 = expr op = binop e2 = expr
    { Ebinop (op, e1, e2) }
| MINUS e = expr %prec unary_minus
    { minus e }
| LP e = expr RP
    { e }

%inline binop:
| ADD   { Add }
| MINUS { Sub }
| MUL   { Mul }
| DIV   { Div }
