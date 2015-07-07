/*
 * ProcDec.java -- abstract syntax for procedure declaration
 */


package absyn;

import sym.Sym;


public class ProcDec extends Dec {

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

    public String id(){
        return name.toString();
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
