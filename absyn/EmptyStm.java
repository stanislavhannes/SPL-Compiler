/*
 * EmptyStm.java -- abstract syntax for empty statement
 */


package absyn;

import visitor.Visitor;
import visitor.VisitorElement;

public class EmptyStm extends Stm implements VisitorElement {

    public EmptyStm(int r, int c) {
        row = r;
        col = c;
    }

    public void show(int n) {
        indent(n);
        say("EmptyStm()");
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
