
/* Syntax Analyzer for Mini Turtle */

%{
open Ast
let minus e = Ebinop (Sub, (Econst 0), e)
%}

/* Declaration of tokens */

%token <int> INT
%token <Turtle.color> COLOR
%token <string> IDENT
%token LP RP LB RB COMMA
%token ADD MINUS MUL DIV
%token EOF
%token IF ELSE DEF REPEAT
%token PENUP PENDOWN TURNLEFT TURNRIGHT FORWARD SETCOLOR

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
  d = list(def) b = list(stmt) EOF
    { { defs = d; main = Sblock b } }
;

def:
  DEF id = IDENT LP args = separated_list(COMMA, IDENT) RP s = stmt
    { { name = id; formals = args; body = s } }

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
| id = IDENT LP params = separated_list(COMMA, expr) RP
    { Scall (id, params) }

expr:
| c = INT
    { Econst c }
| e1 = expr op = binop e2 = expr
    { Ebinop (op, e1, e2) }
| MINUS e = expr %prec unary_minus
    { minus e }
| LP e = expr RP
    { e }
| id = IDENT
    { Evar id }

%inline binop:
| ADD   { Add }
| MINUS { Sub }
| MUL   { Mul }
| DIV   { Div }
