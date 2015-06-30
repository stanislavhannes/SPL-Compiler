/*
 * DecList.java -- abstract syntax for a list of declarations
 */


package absyn;

public class DecList extends ListNode implements VisitorElement {


    public DecList() {
        super();
    }

    public DecList(Dec h, DecList t) {
        super(h,t);
    }

    public void show(int n) {
        indent(n);
        ListNode list = this;
        say("DecList(");
        while (!list.isEmpty()) {
            say("\n");
            list.head.show(n + 1);
            list = list.tail();
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
