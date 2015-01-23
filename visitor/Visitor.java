/**
 * Visitor.java -- Visitor design pattern
 */

package visitor;
import absyn.*;

public interface Visitor {

    public void visit(ArrayTy aarrayTy);
    public void visit(ArrayVar arrayVar);
    public void visit(AssignStm assignStm);
    public void visit(CallStm callStm);
    public void visit(CompStm compStm);
    public void visit(DecList decList);
    public void visit(EmptyStm emptyStm);
    public void visit(ExpList expList);
    public void visit(IfStm ifStm);
    public void visit(IntExp intExp);
    public void visit(NameTy nameTy);
    public void visit(OpExp opExp);
    public void visit(ParDec parDec);
    public void visit(ProcDec procDec);
    public void visit(SimpleVar simpleVar);
    public void visit(StmList stmList);
    public void visit(TypeDec typeDec);
    public void visit(VarDec varDec);
    public void visit(VarExp varExp);
    public void visit(WhileStm whileStm);

}
