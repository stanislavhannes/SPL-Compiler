/*
 * VarExp.java -- abstract syntax for variable expression
 */


package absyn;


public class VarExp extends Exp {

    public Var var;

    public VarExp(int r, int c, Var v) {
        row = r;
        col = c;
        var = v;
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
