
(* Lexical Analyzer for Mini Turtle *)

{
open Lexing
open Parser

(* exception to be raised to report a lexical error *)
exception Lexing_error of string

(* note: think about calling the function Lexing.new_line
    with each carriage return ('\n' character) *)

let binop_of_string = function
  | "+" -> ADD
  | "-" -> MINUS
  | "*" -> MUL
  | "/" -> DIV
  | x -> raise (Lexing_error ("Unknown op: " ^ x))

let kwd_or_id = function
  | "penup" -> PENUP
  | "pendown" -> PENDOWN
  | "forward" -> FORWARD
  | "turnleft" -> TURNLEFT
  | "turnright" -> TURNRIGHT
  | "color" -> SETCOLOR
  | "black" -> COLOR Turtle.black
  | "red" -> COLOR Turtle.red
  | "green" -> COLOR Turtle.green
  | "blue" -> COLOR Turtle.blue
  | x -> IDENT x
}

let letter = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let ident = letter (letter | digit | '_')*
let integer = digit+
let comment_inline = "//" [^'\n']*
let binop = "+" | "-" | "*" | "/"

rule token = parse
  | '\n'      { new_line lexbuf; NEWLINE }
  | ' ' | comment_inline
              { token lexbuf }
  | "(*"      { comment lexbuf }
  | ident as id
              { kwd_or_id id }
  | integer as s
              { try INT (int_of_string s)
                with _ -> raise (Lexing_error ("constant too large: " ^ s)) }
  | binop as o
              { binop_of_string (String.make 1 o) }
  | "("       { LP }
  | ")"       { RP }
  | eof       { EOF }
  | _ { assert false (* TO COMPLETE *) }
and comment = parse
  | "*)"      { token lexbuf }
  | '\n'      { new_line lexbuf; comment lexbuf }
  | _         { comment lexbuf }
