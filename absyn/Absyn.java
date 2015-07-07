/*
 * Absyn.java -- abstract syntax for SPL
 */


package absyn;


public abstract class Absyn {

    public int row;
    public int col;

    public abstract void accept(Visitor v);

    public void show(int indentation){
        this.accept(new PrintVisitor(indentation));
    }
}
