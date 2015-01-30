/*
 * Codegen.java -- ECO32 code generator
 */


package codegen;

import java.io.*;
import absyn.*;
import table.*;
import types.*;
import varalloc.Varalloc;


//TODO: Produziert fehlerhaften AsseblerCode
public class Codegen implements visitor.Visitor {

  private static final int R_MIN = 8;  // lowest free register
  private static final int R_MAX = 23; // highest free register
  private static final int R_RET = 31; // return address
  private static final int R_FP = 25; // frame pointer
  private static final int R_SP = 29; // stack pointer
    private int numLabels = 0;
    private int elseLabel;
  private int freeReg = 8;
  private Table globalTable;
  private Table localTable;
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

  public void visit(DecList decList) {
    Dec head;

    while (!decList.isEmpty) {
      head = decList.head;
      head.accept(this);

      decList = decList.tail;
    }
  }

  public void visit(ProcDec procDec) {
    ProcEntry entry = (ProcEntry) globalTable.lookup(procDec.name);
    localTable = entry.localTable;
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
      outWriter.format("\tjr\t$" + R_RET + "\t\t\t; return\n");
  }

  public void visit(StmList stmList) {
    Stm head;

    while (!stmList.isEmpty) {
      head = stmList.head;
      head.accept(this);
      stmList = stmList.tail;

    }
  }

  public void visit(AssignStm assignStm) {
    if (freeReg + 1 > R_MAX) {
      throw new RuntimeException("Ausdruck zu kompliziert");
    }
      assignStm.var.accept(this);
    freeReg++;
      assignStm.exp.accept(this);

      // outWriter.format("\tldw\t$" + freeReg + ",$" + freeReg + "," + 0 + " \n");  //ldw fraglich
      outWriter.format("\tstw\t$" + freeReg + ",$" + (freeReg - 1) + "," + 0 + "\t\t; AssignStm\n");

    freeReg--;

  }

  public void visit(CallStm callStm) {

    this.visit(callStm.args, callStm.name);
    outWriter.format("\tjal\t" + callStm.name.toString() + "\n");
  }

  public void visit(ExpList expList, sym.Sym procName) {
    Exp head;
    ProcEntry entry = (ProcEntry) globalTable.lookup(procName);
    ParamTypeList paramHead = entry.paramTypes;
    int n = 0;

    while (!expList.isEmpty) {
      head = expList.head;
      head.accept(this);

        if (!paramHead.isRef) {
        outWriter.format("\tldw\t$" + freeReg + ",$" + freeReg + "," + 0 + "\n");
      }

      outWriter.format("\tstw\t$" + freeReg + ",$" + R_SP + "," + (n * Varalloc.intByteSize) + "\n");

      paramHead = paramHead.next;
      expList = expList.tail;
      n++;
    }

  }

  public void visit(CompStm compStm) {
    compStm.stms.accept(this);
  }

  private int newLabel() {
    return numLabels++;
  }

  public void visit(WhileStm whileStm) {
    int label = newLabel();
    elseLabel = newLabel();

      outWriter.format("L" + label + ":\n");
    whileStm.test.accept(this);
    whileStm.body.accept(this);
    outWriter.format("\tj\tL" + label + "\n");
      outWriter.format("L" + elseLabel + ":\n");
  }

  public void visit(IfStm ifStm) {

    int endLabel = 0, elseLabel_old = elseLabel;
    boolean hasElse = true;
    if (ifStm.elsePart.getClass() == EmptyStm.class) hasElse = false;

      elseLabel = newLabel();
    if (hasElse) {
        endLabel = newLabel();
    }

    ifStm.test.accept(this);
    ifStm.thenPart.accept(this);

    if (hasElse) {
        outWriter.format("\tj\tL" + endLabel + "\n");
    }

      outWriter.format("L" + elseLabel + ":\n");
    if (hasElse) {
      ifStm.elsePart.accept(this);
        outWriter.format("L" + endLabel + ":\n");
    }

      elseLabel = elseLabel_old;

  }

  public void visit(OpExp opExp) {

    if (freeReg + 1 > R_MAX) {
      throw new RuntimeException("Ausdruck zu kompliziert");
    }
    opExp.left.accept(this);
      outWriter.format("\tldw\t$" + freeReg + ",$" + freeReg + "," + 0 + " \n");
    freeReg++;
    opExp.right.accept(this);
      outWriter.format("\tldw\t$" + freeReg + ",$" + freeReg + "," + 0 + " \n");

    switch (opExp.op) {
      case OpExp.ADD:
        outWriter.format("\tadd\t$" + (freeReg - 1) + ",$" + (freeReg - 1) + ",$" + freeReg + "\n");
        break;
      case OpExp.SUB:
        outWriter.format("\tsub\t$" + (freeReg - 1) + ",$" + (freeReg - 1) + ",$" + freeReg + "\n");
        break;
      case OpExp.MUL:
        outWriter.format("\tmul\t$" + (freeReg - 1) + ",$" + (freeReg - 1) + ",$" + freeReg + "\n");
        break;
      case OpExp.DIV:
        outWriter.format("\tdiv\t$" + (freeReg - 1) + ",$" + (freeReg - 1) + ",$" + freeReg + "\n");
        break;

      case OpExp.EQU:
        outWriter.format("\tbne\t$" + (freeReg - 1) + ",$" + (freeReg - 1) + ",L" + elseLabel + "\n");
        break;
      case OpExp.NEQ:
        outWriter.format("\tbeq\t$" + (freeReg - 1) + ",$" + (freeReg - 1) + ",L" + elseLabel + "\n");
        break;
      case OpExp.LST:
        outWriter.format("\tbge\t$" + (freeReg - 1) + ",$" + (freeReg - 1) + ",L" + elseLabel + "\n");
        break;
      case OpExp.LSE:
        outWriter.format("\tbgt\t$" + (freeReg - 1) + ",$" + (freeReg - 1) + ",L" + elseLabel + "\n");
        break;
      case OpExp.GRT:
        outWriter.format("\tble\t$" + (freeReg - 1) + ",$" + (freeReg - 1) + ",L" + elseLabel + "\n");
        break;
      case OpExp.GRE:
        outWriter.format("\tblt\t$" + (freeReg - 1) + ",$" + (freeReg - 1) + ",L" + elseLabel + "\n");
        break;

    }

    freeReg--;

  }


  public void visit(IntExp intExp) {
    outWriter.format("\tadd\t$" + freeReg + ",$0," + intExp.val + "\t\t; intExp\n");
  }

  public void visit(VarExp varExp) {
    varExp.var.accept(this);
  }

  public void visit(SimpleVar simpleVar) {
    VarEntry entry = (VarEntry) localTable.lookup(simpleVar.name);
      if (entry.isRef) {
          outWriter.format("\tadd\t$" + freeReg + ",$" + R_FP + "," + entry.offset + "\t\t; Parameter " + simpleVar.name.toString() + " \n");
          outWriter.format("\tldw\t$" + freeReg + ",$" + freeReg + "," + 0 + " \n");
      } else {
          outWriter.format("\tadd\t$" + freeReg + ",$" + R_FP + "," + ((-1) * entry.offset) + "\t\t; SimpleVar " + simpleVar.name.toString() + " \n");
      }

  }

  public void visit(ArrayVar arrayVar) {

    if (freeReg + 2 > R_MAX) throw new RuntimeException("Ausdruck zu kompliziert");

      arrayVar.var.accept(this);
    freeReg++;
      arrayVar.index.accept(this);
    freeReg++;

    SimpleVar var = (SimpleVar)arrayVar.var;
    VarEntry entry = (VarEntry) localTable.lookup(var.name);
    ArrayType aType = (ArrayType)entry.type;


    outWriter.format("\tadd\t$" + freeReg + ",$" + 0 + "," + aType.size + "\n");
    outWriter.format("\tbgeu\t$" + (freeReg - 1) + ",$" + freeReg + ",_indexError\n");
      outWriter.format("\tmul\t$" + (freeReg - 1) + ",$" + (freeReg - 1) + "," + aType.baseType.getByteSize() + " \n");
    outWriter.format("\tadd\t$" + (freeReg - 2) + ",$" + (freeReg - 2) + ",$" + (freeReg - 1) + "\n");

    freeReg = freeReg - 2;
  }


  //These Methods are irrelevant for the code generation
  public void visit(NameTy nameTy) {
  }

  public void visit(ArrayTy arrayTy) {
  }

  public void visit(TypeDec typeDec) {
  }

  public void visit(ParDec parDec) {
  }

  public void visit(EmptyStm emptyStm) {
  }

  public void visit(ExpList expList) {

  }

  public void visit(VarDec varDec) {
  }
}
