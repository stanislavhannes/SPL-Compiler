/*
 * NameTy.java -- abstract syntax for name type
 */


package absyn;

import sym.Sym;

public class NameTy extends Ty {

    public Sym name;

    public NameTy(int r, int c, Sym n) {
        row = r;
        col = c;
        name = n;
    }

    public String id(){
        return name.toString();
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
