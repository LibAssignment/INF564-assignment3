
(* Syntaxe abstraite pour mini-Turtle

   Note : La syntaxe abstraite ci-dessous contient volontairement moins
   de constructions que la syntaxe concrète. Il faudra donc traduire
   certaines constructions au moment de l'analyse syntaxique (sucre).
*)

(* expressions entières *)

type binop = Add | Sub | Mul | Div

type expr =
  | Econst of int
  | Evar   of string
  | Ebinop of binop * expr * expr

(* instructions *)

type stmt =
  | Spenup
  | Spendown
  | Sforward of expr
  | Sturn    of expr (* tourne à gauche *)
  | Scolor   of Turtle.color
  | Sif      of expr * stmt * stmt
  | Srepeat  of expr * stmt
  | Sblock   of stmt list
  | Scall    of string * expr list

(* définition de procédure *)

type def = {
  name    : string;
  formals : string list; (* arguments *)
  body    : stmt; }

(* programme *)

type program = {
  defs : def list;
  main : stmt; }



