/*
 * IfStm.java -- abstract syntax for if statement
 */


package absyn;

public class IfStm extends Stm {

    public Exp test;
    public Stm thenPart;
    public Stm elsePart;

    public IfStm(int r, int c, Exp t, Stm s1, Stm s2) {
        row = r;
        col = c;
        test = t;
        thenPart = s1;
        elsePart = s2;
    }


    public void accept(Visitor v) {
        v.visit(this);
    }
}
