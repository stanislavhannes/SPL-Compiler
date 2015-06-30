/*
 * Var.java -- abstract syntax for variables
 */


package absyn;
import types.Type;

public abstract class Var extends Absyn implements VisitorElement {
    public Type dataType;

    public abstract void show(int n);
    public abstract void accept(Visitor v);
}
