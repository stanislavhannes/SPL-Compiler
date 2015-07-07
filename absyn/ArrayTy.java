/*
 * ArrayTy.java -- abstract syntax for array type
 */


package absyn;

public class ArrayTy extends Ty {

    public int size;
    public Ty baseTy;

    public ArrayTy(int r, int c, int s, Ty t) {
        row = r;
        col = c;
        size = s;
        baseTy = t;
    }


    public void accept(Visitor v) {
        v.visit(this);
    }
}
