/*
 * Exp.java -- abstract syntax for expressions
 */


package absyn;


public abstract class Exp extends Absyn implements VisitorElement{

    public abstract void show(int n);
    public abstract void accept(Visitor v);

}
