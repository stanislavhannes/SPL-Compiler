/*
 * NameTy.java -- abstract syntax for name type
 */


package absyn;

import sym.Sym;

public class NameTy extends Ty implements VisitorElement {

    public Sym name;

    public NameTy(int r, int c, Sym n) {
        row = r;
        col = c;
        name = n;
    }

    public void show(int n) {
        indent(n);
        say("NameTy(");
        say(name.toString());
        say(")");
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
