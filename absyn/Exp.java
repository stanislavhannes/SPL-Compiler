/*
 * Exp.java -- abstract syntax for expressions
 */


package absyn;


import types.Type;

public abstract class Exp extends Absyn implements VisitorElement{

    public Type dataType;

    public abstract void show(int n);
    public abstract void accept(Visitor v);

}
