
/* Syntax Analyzer for Mini Turtle */

%{
open Ast
let minus e = Ebinop (Sub, (Econst 0), e)
%}

/* Declaration of tokens */

%token <int> INT
%token <Turtle.color> COLOR
%token <string> IDENT
%token LP RP LB RB
%token ADD MINUS MUL DIV
%token EOF
%token IF ELSE REPEAT
%token PENUP PENDOWN TURNLEFT TURNRIGHT FORWARD SETCOLOR
/* TO COMPLETE */

/* Priorities and associativities of tokens */
%nonassoc IF
%nonassoc ELSE
%left ADD MINUS
%left MUL DIV
%nonassoc unary_minus

/* Point of entry of grammar */
%start prog

/* Type of values returned by the parser */
%type <Ast.program> prog

%%

/* Grammar rules */

prog:
/* TO COMPLETE */
  b = list(stmt) EOF
    { { defs = []; main = Sblock b } (* TO MODIFY *) }
;

stmt:
| s = simple_stmt
    { s }
| LB b = list(stmt) RB
    { Sblock b }
| IF e = expr s1 = stmt
    { Sif (e, s1, Sblock []) }
| IF e = expr s1 = stmt ELSE s2 = stmt
    { Sif (e, s1, s2) }
| REPEAT e = expr s = stmt
    { Srepeat (e, s) }

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
