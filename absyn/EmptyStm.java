/*
 * EmptyStm.java -- abstract syntax for empty statement
 */


package absyn;

public class EmptyStm extends Stm {

    public EmptyStm(int r, int c) {
        row = r;
        col = c;
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
