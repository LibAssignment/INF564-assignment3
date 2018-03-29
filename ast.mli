
(* Abstract Syntax for Mini Turtle

   Note: The abstract syntax below intentionally contains less
   of constructions that the concrete syntax. It will therefore be necessary to translate
   some constructions at the time of syntactic analysis (sugar).
*)

(* whole expressions *)

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
  | Sturn    of expr (* turn left *)
  | Scolor   of Turtle.color
  | Sif      of expr * stmt * stmt
  | Srepeat  of expr * stmt
  | Sblock   of stmt list
  | Scall    of string * expr list

(* procedure definition *)

type def = {
  name    : string;
  formals : string list; (* arguments *)
  body    : stmt; }

(* program *)

type program = {
  defs : def list;
  main : stmt; }
