CMX=turtle.cmx lexer.cmx parser.cmx interp.cmx main.cmx
GENERATED = lexer.ml parser.ml parser.mli
BIN=mini-turtle
FLAGS=

all: $(BIN)
	./$(BIN) test.logo

.PHONY: tests

tests: $(BIN)
	for f in tests/*.logo; do ./$(BIN) $$f; done

$(BIN): $(CMX)
	ocamlopt $(FLAGS) -o $(BIN) graphics.cmxa $(CMX)

.SUFFIXES: .mli .ml .cmi .cmx .mll .mly

.mli.cmi:
	ocamlopt $(FLAGS) -c  $<

.ml.cmx:
	ocamlopt $(FLAGS) -c  $<

.mll.ml:
	ocamllex $<

.mly.ml:
	menhir --infer -v $<

clean:
	rm -f *.cm[ix] *.o *~ $(BIN) $(GENERATED) parser.automaton

parser.ml: ast.cmi

.depend depend: $(GENERATED)
	rm -f .depend
	ocamldep *.ml *.mli > .depend

include .depend



