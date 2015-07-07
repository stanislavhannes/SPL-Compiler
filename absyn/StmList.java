/*
 * StmList.java -- abstract syntax for a list of statements
 */


package absyn;

public class StmList extends ListNode {

    public StmList() {
        row = -1;
        col = -1;
        isEmpty = true;
    }

    public StmList(Stm h, StmList t) {
        super(h,t);
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
