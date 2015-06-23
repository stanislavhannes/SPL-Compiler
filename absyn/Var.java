/*
 * Var.java -- abstract syntax for variables
 */


package absyn;

public abstract class Var extends Absyn implements VisitorElement {

    public abstract void show(int n);
    public abstract void accept(Visitor v);
}
