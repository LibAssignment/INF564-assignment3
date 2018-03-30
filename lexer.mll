
(* Lexical Analyzer for Mini Turtle *)

{
open Lexing
open Parser

(* exception to be raised to report a lexical error *)
exception Lexing_error of string

(* note: think about calling the function Lexing.new_line
    with each carriage return ('\n' character) *)

}

let comment_inline = "//" [^'\n']*

rule token = parse
  | '\n'      { new_line lexbuf; NEWLINE }
  | ' ' | comment_inline
              { token lexbuf }
  | "(*"      { comment lexbuf }
  | eof       { EOF }
  | _ { assert false (* TO COMPLETE *) }
and comment = parse
  | "*)"      { token lexbuf }
  | _         { comment lexbuf }
