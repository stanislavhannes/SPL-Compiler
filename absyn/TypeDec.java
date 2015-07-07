/*
 * TypeDec.java -- abstract syntax for type declaration
 */


package absyn;

import sym.Sym;


public class TypeDec extends Dec{

    public Sym name;
    public Ty ty;

    public TypeDec(int r, int c, Sym n, Ty t) {
        row = r;
        col = c;
        name = n;
        ty = t;
    }

    public String id(){
        return name.toString();
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
