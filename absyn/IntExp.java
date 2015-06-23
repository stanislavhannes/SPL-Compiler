/*
 * IntExp.java -- abstract syntax for integer expression
 */


package absyn;

public class IntExp extends Exp implements VisitorElement {

    public int val;

    public IntExp(int r, int c, int v) {
        row = r;
        col = c;
        val = v;
    }

    public void show(int n) {
        indent(n);
        say("IntExp(");
        sayInt(val);
        say(")");
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
