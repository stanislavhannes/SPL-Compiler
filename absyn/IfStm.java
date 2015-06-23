/*
 * IfStm.java -- abstract syntax for if statement
 */


package absyn;

public class IfStm extends Stm implements VisitorElement {

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

    public void show(int n) {
        indent(n);
        say("IfStm(\n");
        test.show(n + 1);
        say(",\n");
        thenPart.show(n + 1);
        say(",\n");
        elsePart.show(n + 1);
        say(")");
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
