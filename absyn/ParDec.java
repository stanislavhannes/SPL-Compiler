/*
 * ParDec.java -- abstract syntax for parameter declaration
 */


package absyn;

import sym.Sym;

public class ParDec extends Dec {

    public Sym name;
    public Ty ty;
    public boolean isRef;

    public ParDec(int r, int c, Sym n, Ty t, boolean i) {
        row = r;
        col = c;
        name = n;
        ty = t;
        isRef = i;
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
