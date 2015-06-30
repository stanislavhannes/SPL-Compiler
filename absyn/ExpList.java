/*
 * ExpList.java -- abstract syntax for a list of expressions
 */


package absyn;


import java.util.List;

public class ExpList extends ListNode implements VisitorElement {

    public boolean isEmpty;
    public Exp head;
    public ExpList tail;

    public ExpList() {
        super();
    }

    public ExpList(Exp head, ExpList tail) {
        super(head, tail);
    }

    public void show(int n) {
        indent(n);
        ExpList list = this;
        say("ExpList(");
        while (!list.isEmpty()) {
            say("\n");
            list.head.show(n + 1);
            list = list.tail;
            if (!list.isEmpty()) {
                say(",");
            }
        }
        say(")");
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
