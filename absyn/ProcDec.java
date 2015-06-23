/*
 * ProcDec.java -- abstract syntax for procedure declaration
 */


package absyn;

import sym.Sym;


public class ProcDec extends Dec implements VisitorElement {

    public Sym name;
    public DecList params;
    public DecList decls;
    public StmList body;

    public ProcDec(int r, int c, Sym n, DecList p, DecList d, StmList b) {
        row = r;
        col = c;
        name = n;
        params = p;
        decls = d;
        body = b;
    }

    public void show(int n) {
        indent(n);
        say("ProcDec(\n");
        indent(n + 1);
        say(name.toString());
        say(",\n");
        params.show(n + 1);
        say(",\n");
        decls.show(n + 1);
        say(",\n");
        body.show(n + 1);
        say(")");
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
