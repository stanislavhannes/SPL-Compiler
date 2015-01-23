/*
 * VarExp.java -- abstract syntax for variable expression
 */


package absyn;

import visitor.Visitor;
import visitor.VisitorElement;

public class VarExp extends Exp implements VisitorElement {

    public Var var;

    public VarExp(int r, int c, Var v) {
        row = r;
        col = c;
        var = v;
    }

    public void show(int n) {
        indent(n);
        say("VarExp(\n");
        var.show(n + 1);
        say(")");
    }


    public void accept(Visitor v) {
        v.visit(this);
    }
}
