/*
 * ArrayVar.java -- abstract syntax for array variable
 */


package absyn;

public class ArrayVar extends Var{

    public Var var;
    public Exp index;

    public ArrayVar(int r, int c, Var v, Exp i) {
        row = r;
        col = c;
        var = v;
        index = i;
    }


    public void accept(Visitor v) {
        v.visit(this);
    }
}
