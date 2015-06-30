/*
 * StmList.java -- abstract syntax for a list of statements
 */


package absyn;


import java.util.List;

public class StmList extends ListNode implements VisitorElement {

    public StmList() {
        row = -1;
        col = -1;
        isEmpty = true;
    }

    public StmList(Stm h, StmList t) {
        super(h,t);
    }

    public void show(int n) {
        indent(n);
        ListNode list = this;
        say("StmList(");
        while (!list.isEmpty) {
            say("\n");
            list.head.show(n + 1);
            list = list.tail();
            if (!list.isEmpty) {
                say(",");
            }
        }
        say(")");
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
