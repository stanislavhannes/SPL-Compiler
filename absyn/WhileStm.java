/*
 * WhileStm.java -- abstract syntax for while statement
 */


package absyn;

public class WhileStm extends Stm{

    public Exp test;
    public Stm body;

    public WhileStm(int r, int c, Exp t, Stm b) {
        row = r;
        col = c;
        test = t;
        body = b;
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
