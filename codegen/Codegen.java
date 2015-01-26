/*
 * Codegen.java -- ECO32 code generator
 */


package codegen;

import java.io.*;
import absyn.*;
import table.*;
import types.*;
import varalloc.Varalloc;

public class Codegen implements visitor.Visitor {

  private static final int R_MIN = 8;  // lowest free register
  private static final int R_MAX = 23; // highest free register
  private static final int R_RET = 31; // return address
  private static final int R_FP = 25; // frame pointer
  private static final int R_SP = 29; // stack pointer
  private Table globalTable;
  private PrintWriter outWriter;

  public Codegen(Table t, Writer w) {
    globalTable = t;
    outWriter = new PrintWriter(w);
  }

  private void assemblerProlog() {
    outWriter.format("\t.import\tprinti\n");
    outWriter.format("\t.import\tprintc\n");
    outWriter.format("\t.import\treadi\n");
    outWriter.format("\t.import\treadc\n");
    outWriter.format("\t.import\texit\n");
    outWriter.format("\t.import\ttime\n");
    outWriter.format("\t.import\tclearAll\n");
    outWriter.format("\t.import\tsetPixel\n");
    outWriter.format("\t.import\tdrawLine\n");
    outWriter.format("\t.import\tdrawCircle\n");
    outWriter.format("\t.import\t_indexError\n");
    outWriter.format("\n");
    outWriter.format("\t.code\n");
    outWriter.format("\t.align\t4\n");
  }

  public void genCode(Absyn program) {
    assemblerProlog();
    ((DecList) program).accept(this);


  }


  public void visit(ArrayVar arrayVar) {

  }

  public void visit(AssignStm assignStm) {

  }

  public void visit(CallStm callStm) {

  }

  public void visit(CompStm compStm) {

  }

  public void visit(DecList decList) {
    Dec node;

    while (!decList.isEmpty) {
      node = decList.head;

      if (node.getClass() == ProcDec.class) {
        this.visit((ProcDec) node);
      }

      decList = decList.tail;
    }
  }


  public void visit(ExpList expList) {

  }

  public void visit(IfStm ifStm) {

  }

  public void visit(IntExp intExp) {

  }


  public void visit(OpExp opExp) {

  }

  public void visit(ProcDec procDec) {
    ProcEntry entry = (ProcEntry) globalTable.lookup(procDec.name);
    String name = procDec.name.toString();
    int frameSize, oldFP, oldRET;

    if (entry.stmCall) {
      frameSize = entry.varAreaSize +
              +2 * Varalloc.refByteSize // Frampointer and Returnadress
              + entry.outAreaSize;
      oldFP = entry.outAreaSize + Varalloc.refByteSize;

    } else {
      frameSize = entry.varAreaSize + Varalloc.refByteSize;
      oldFP = 0;
    }

    oldRET = entry.varAreaSize + 2 * Varalloc.refByteSize;

    outWriter.format("\n\t.export\t" + name + "\n");
    outWriter.format(name + ":\n");
    outWriter.format("\tsub\t$" + R_SP + ",$" + R_SP + "," + frameSize + "\t\t; allocate frame\n");
    outWriter.format("\tstw\t$" + R_FP + ",$" + R_SP + "," + oldFP + "\t\t; save old frame pointer\n");
    outWriter.format("\tadd\t$" + R_FP + ",$" + R_SP + "," + frameSize + "\t\t; setup new frame pointer\n");

    if (entry.stmCall)
      outWriter.format("\tstw\t$" + R_RET + ",$" + R_FP + ",-" + oldRET + "\t\t; save return register\n");

    procDec.body.accept(this);

    if (entry.stmCall)
      outWriter.format("\tldw\t$" + R_RET + ",$" + R_FP + ",-" + oldRET + "\t\t; restore return register\n");

    outWriter.format("\tldw\t$" + R_FP + ",$" + R_SP + "," + oldFP + "\t\t; restore old frame pointer\n");
    outWriter.format("\tadd\t$" + R_SP + ",$" + R_SP + "," + frameSize + "\t\t; release frame\n");
    outWriter.format("\tjr\t$%" + R_RET + "\t\t\t; return\n");
  }

  public void visit(SimpleVar simpleVar) {

  }

  public void visit(StmList stmList) {

  }

  public void visit(VarExp varExp) {

  }

  public void visit(WhileStm whileStm) {

  }

  //These Methods are irrelevant for the code generation
  public void visit(NameTy nameTy) {
  }

  public void visit(ArrayTy aarrayTy) {
  }

  public void visit(TypeDec typeDec) {
  }

  public void visit(ParDec parDec) {
  }

  public void visit(EmptyStm emptyStm) {
  }

  public void visit(VarDec varDec) {
  }
}
