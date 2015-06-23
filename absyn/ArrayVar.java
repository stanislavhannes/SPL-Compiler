/*
 * ArrayVar.java -- abstract syntax for array variable
 */


package absyn;

public class ArrayVar extends Var implements VisitorElement {

    public Var var;
    public Exp index;

    public ArrayVar(int r, int c, Var v, Exp i) {
        row = r;
        col = c;
        var = v;
        index = i;
    }

    public void show(int n) {
        indent(n);
        say("ArrayVar(\n");
        var.show(n + 1);
        say(",\n");
        index.show(n + 1);
        say(")");
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
