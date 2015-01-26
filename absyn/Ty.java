/*
 * Ty.java -- abstract syntax for types
 */


package absyn;

import visitor.Visitor;
import visitor.VisitorElement;

public abstract class Ty extends Absyn implements VisitorElement{

    public abstract void show(int n);
    public abstract void accept(Visitor v);

}
