
(* Analyseur lexical pour mini-Turtle *)

{
  open Lexing
  open Parser

  (* exception à lever pour signaler une erreur lexicale *)
  exception Lexing_error of string

  (* note : penser à appeler la fonction Lexing.new_line
     à chaque retour chariot (caractère '\n') *)

}

rule token = parse
  | _ { assert false (* À COMPLÉTER *) }
