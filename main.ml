
(* Main file of the mini-Turtle interpreter *)

open Format
open Lexing

(* Compilation option, to stop at the end of the parser *)
let parse_only = ref false
let output_filename = ref "out.png"

(* Names of source and target files *)
let ifile = ref ""
let ofile = ref ""

let set_file f s = f := s

(* The compiler options that are displayed with --help *)
let options =
  ["--parse-only", Arg.Set parse_only,
   "  To do only the parsing phase";
   "-o", Arg.String (fun s -> ofile:=s),
   "  Output filename"]

let usage = "usage: mini-turtle [option] file.logo"

(* locate an error by indicating the row and the column *)
let localisation pos =
  let l = pos.pos_lnum in
  let c = pos.pos_cnum - pos.pos_bol + 1 in
  eprintf "File \"%s\", line %d, characters %d-%d:\n" !ifile l (c-1) c

let () =
  (* Parsing the command line *)
  Arg.parse options (set_file ifile) usage;

  (* We check that the name of the source file has been indicated *)
  if !ifile="" then begin eprintf "No files to compile\n@?"; exit 1 end;

  (* This file must have the extension .logo *)
  if not (Filename.check_suffix !ifile ".logo") then begin
    eprintf "The input file must have the extension .logo\n@?";
    Arg.usage options usage;
    exit 1
  end;

  if !ofile="" then begin ofile := (Filename.chop_suffix !ifile ".logo") ^ ".png" end;

  (* Opening the source file for reading *)
  let fi = open_in !ifile in
  let fo = open_out !ofile in

  (* Creating a lexical analysis buffer *)
  let buf = Lexing.from_channel fi in

  try
    (* Parsing: The Parser.prog function transforms the lexical buffer into a
       abstract syntax tree if no error (lexical or syntactical)
       is detected.
       The Lexer.token function is used by Parser.prog to get
       the next token. *)
    let p = Parser.prog Lexer.token buf in
    close_in fi;

    (* We stop here if we only want to do parsing *)
    if !parse_only then exit 0;

    Interp.prog fo p;
    close_out fo;
  with
    | Lexer.Lexing_error c ->
        (* Lexical error. We recover its absolute position and
           we convert it to a line number *)
        localisation (Lexing.lexeme_start_p buf);
        eprintf "Lexical error: %s@." c;
        exit 1
    | Parser.Error ->
        (* Syntax error. We recover its absolute position and we
           converts to line number *)
        localisation (Lexing.lexeme_start_p buf);
        eprintf "Syntax error@.";
        exit 1
    | Interp.Error s->
        (* Error during interpretation *)
        eprintf "Error : %s@." s;
        exit 1
