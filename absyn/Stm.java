/*
 * Stm.java -- abstract syntax for statements
 */


package absyn;


public abstract class Stm extends Absyn implements VisitorElement{

    public abstract void show(int n);
    public abstract void accept(Visitor v);

}
