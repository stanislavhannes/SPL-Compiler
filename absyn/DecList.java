/*
 * DecList.java -- abstract syntax for a list of declarations
 */


package absyn;

public class DecList extends ListNode {


    public DecList() {
        super();
    }

    public DecList(Dec h, DecList t) {
        super(h,t);
    }

    public void accept(Visitor v) {
        v.visit(this);
    }
}
