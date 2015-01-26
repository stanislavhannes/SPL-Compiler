/*
 * Dec.java -- abstract syntax for declarations
 */


package absyn;

import visitor.Visitor;
import visitor.VisitorElement;

public abstract class Dec extends Absyn implements VisitorElement{

    public abstract void show(int n);
    public abstract void accept(Visitor v);
}
