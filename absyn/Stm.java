/*
 * Stm.java -- abstract syntax for statements
 */


package absyn;

import visitor.Visitor;
import visitor.VisitorElement;

public abstract class Stm extends Absyn implements VisitorElement{

    public abstract void show(int n);
    public abstract void accept(Visitor v);

}
