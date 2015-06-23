/*
 * VarDec.java -- abstract syntax for variable declaration
 */


package absyn;

import sym.Sym;



public class VarDec extends Dec implements VisitorElement {

    public Sym name;
    public Ty ty;

    public VarDec(int r, int c, Sym n, Ty t) {
        row = r;
        col = c;
        name = n;
        ty = t;
    }

    public void show(int n) {
        indent(n);
        say("VarDec(\n");
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

