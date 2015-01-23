/*
 * TypeDec.java -- abstract syntax for type declaration
 */


package absyn;

import sym.Sym;
import visitor.Visitor;
import visitor.VisitorElement;


public class TypeDec extends Dec implements VisitorElement {

    public Sym name;
    public Ty ty;

    public TypeDec(int r, int c, Sym n, Ty t) {
        row = r;
        col = c;
        name = n;
        ty = t;
    }

    public void show(int n) {
        indent(n);
        say("TypeDec(\n");
        indent(n + 1);
        say(name.toString());
        say(",\n");
        ty.show(n + 1);
        say(")");
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
