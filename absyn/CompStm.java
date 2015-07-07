/*
 * CompStm.java -- abstract syntax for compound statement
 */


package absyn;

public class CompStm extends Stm{

    public StmList stms;

    public CompStm(int r, int c, StmList s) {
        row = r;
        col = c;
        stms = s;
    }


    @Override
    public void accept(Visitor v) {
        v.visit(this);
    }
}
