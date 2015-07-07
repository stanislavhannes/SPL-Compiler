/*
 * AssignStm.java -- abstract syntax for assign statement
 */


package absyn;


public class AssignStm extends Stm{

    public Var var;
    public Exp exp;

    public AssignStm(int r, int c, Var v, Exp e) {
        row = r;
        col = c;
        var = v;
        exp = e;
    }


    public void accept(Visitor v) {
        v.visit(this);
    }
}
