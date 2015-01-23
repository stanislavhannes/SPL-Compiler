/*
 * CompStm.java -- abstract syntax for compound statement
 */


package absyn;

import visitor.Visitor;
import visitor.VisitorElement;

public class CompStm extends Stm implements VisitorElement {

    public StmList stms;

    public CompStm(int r, int c, StmList s) {
        row = r;
        col = c;
        stms = s;
    }

    public void show(int n) {
        indent(n);
        say("CompStm(\n");
        stms.show(n + 1);
        say(")");
    }

    @Override
    public void accept(Visitor v) {
        v.visit(this);
    }
}
