/*
 * AssignStm.java -- abstract syntax for assign statement
 */


package absyn;


public class AssignStm extends Stm implements VisitorElement {

    public Var var;
    public Exp exp;

    public AssignStm(int r, int c, Var v, Exp e) {
        row = r;
        col = c;
        var = v;
        exp = e;
    }

    public void show(int n) {
        indent(n);
        say("AssignStm(\n");
        var.show(n + 1);
        say(",\n");
        exp.show(n + 1);
        say(")");
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
