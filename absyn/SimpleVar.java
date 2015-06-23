/*
 * SimpleVar.java -- abstract syntax for simple variable
 */


package absyn;

import  sym.Sym;

public class SimpleVar extends Var implements VisitorElement {

    public Sym name;

    public SimpleVar(int r, int c, Sym n) {
        row = r;
        col = c;
        name = n;
    }

    public void show(int n) {
        indent(n);
        say("SimpleVar(");
        say(name.toString());
        say(")");
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
