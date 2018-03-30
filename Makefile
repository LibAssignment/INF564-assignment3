CMX=turtle.cmx lexer.cmx parser.cmx interp.cmx main.cmx
GENERATED = lexer.ml parser.ml parser.mli
BIN=mini-turtle
FLAGS=-package gg,vg,vg.cairo -linkpkg
OCAMLOPT=ocamlfind ocamlopt

all: $(BIN)
	./$(BIN) test.logo

.PHONY: tests

tests: $(BIN)
	./run-tests

$(BIN): $(CMX)
	$(OCAMLOPT) $(FLAGS) -o $(BIN) $(CMX)

test_vg: turtle.cmx test.cmx
	$(OCAMLOPT) $(FLAGS) -o $@ $^

out.png: test_vg
	./test_vg > out.png

.SUFFIXES: .mli .ml .cmi .cmx .mll .mly

.mli.cmi:
	$(OCAMLOPT) $(FLAGS) -c $<

.ml.cmx:
	$(OCAMLOPT) $(FLAGS) -c $<

.mll.ml:
	ocamllex $<

.mly.ml:
	menhir --infer -v $<

clean:
	rm -f *.cm[ix] *.o *~ $(BIN) $(GENERATED) parser.automaton *.png test_vg

parser.ml: ast.cmi

.depend depend: $(GENERATED)
	rm -f .depend
	ocamldep *.ml *.mli > .depend

include .depend
