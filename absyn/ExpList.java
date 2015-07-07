/*
 * ExpList.java -- abstract syntax for a list of expressions
 */


package absyn;


import java.util.List;

public class ExpList extends ListNode{

    public boolean isEmpty;
    public Exp head;
    public ExpList tail;

    public ExpList() {
        super();
    }

    public ExpList(Exp head, ExpList tail) {
        super(head, tail);
    }


    public void accept(Visitor v) {
        v.visit(this);
    }
}
