/*
 * visitor.java -- Operationen auf Anweisungen und Ausdruecken
 */
package absyn;

public abstract class Visitor {
    public abstract void visit(ArrayVar v);
    public abstract void visit(AssignStm s);
    public abstract void visit(CallStm s);
    public abstract void visit(CompStm s);
    public abstract void visit(DecList d);
    public abstract void visit(EmptyStm s);
    public abstract void visit(ExpList l);
    public abstract void visit(IfStm s);
    public abstract void visit(IntExp e);
    public abstract void visit(NameTy t);
    public abstract void visit(ArrayTy t);
    public abstract void visit(OpExp e);
    public abstract void visit(ParDec d);
    public abstract void visit(ProcDec d);
    public abstract void visit(SimpleVar v);
    public abstract void visit(StmList s);
    public abstract void visit(TypeDec d);
    public abstract void visit(VarDec d);
    public abstract void visit(VarExp e);
    public abstract void visit(WhileStm s);
}
