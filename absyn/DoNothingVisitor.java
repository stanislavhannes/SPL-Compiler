/*
 * visitor.java -- Operationen auf Anweisungen und Ausdruecken
 */
package absyn;

public class DoNothingVisitor extends Visitor {
    public void visit(ArrayTy t) {}
    public void visit(ArrayVar v) {}
    public void visit(AssignStm s) {}
    public void visit(CallStm s) {}
    public void visit(CompStm s) {}
    public void visit(DecList d) {}
    public void visit(EmptyStm s) {}
    public void visit(ExpList l) {}
    public void visit(IfStm s) {}
    public void visit(IntExp e) {}
    public void visit(NameTy t) {}
    public void visit(OpExp e) {}
    public void visit(ParDec d) {}
    public void visit(ProcDec d) {}
    public void visit(SimpleVar v) {}
    public void visit(StmList s) {}
    public void visit(TypeDec d) {}
    public void visit(VarDec d) {}
    public void visit(VarExp e) {}
    public void visit(WhileStm s) {}
}


