/*
 * Ty.java -- abstract syntax for types
 */


package absyn;


public abstract class Ty extends Absyn implements VisitorElement{

    public abstract void show(int n);
    public abstract void accept(Visitor v);

}
