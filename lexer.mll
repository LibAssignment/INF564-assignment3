
(* Lexical Analyzer for Mini Turtle *)

{
  open Lexing
  open Parser

  (* exception to be raised to report a lexical error *)
  exception Lexing_error of string

  (* note: think about calling the function Lexing.new_line
     with each carriage return ('\n' character) *)

}

rule token = parse
  | _ { assert false (* TO COMPLETE *) }
