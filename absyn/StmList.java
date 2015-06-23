/*
 * StmList.java -- abstract syntax for a list of statements
 */


package absyn;


public class StmList extends Absyn implements VisitorElement {

    public boolean isEmpty;
    public Stm head;
    public StmList tail;

    public StmList() {
        row = -1;
        col = -1;
        isEmpty = true;
    }

    public StmList(Stm h, StmList t) {
        row = -1;
        col = -1;
        isEmpty = false;
        head = h;
        tail = t;
    }

    public void show(int n) {
        indent(n);
        StmList list = this;
        say("StmList(");
        while (!list.isEmpty) {
            say("\n");
            list.head.show(n + 1);
            list = list.tail;
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
