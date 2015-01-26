/*
 * Var.java -- abstract syntax for variables
 */


package absyn;

import visitor.Visitor;
import visitor.VisitorElement;

public abstract class Var extends Absyn implements VisitorElement {

    public abstract void show(int n);
    public abstract void accept(Visitor v);
}
