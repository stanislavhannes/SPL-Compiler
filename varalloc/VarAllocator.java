/*
 * Varalloc.java -- variable allocation
 */


package varalloc;

import absyn.*;
import sym.Sym;
import table.Entry;
import table.ProcEntry;
import table.Table;
import table.VarEntry;
import types.ParamType;
import types.ParamTypeList;

import java.util.Iterator;


public class VarAllocator extends DoNothingVisitor {

    public static final int INTBYTESIZE = 4;
    public static final int BOOLBYTESIZE = 4;
    public static final int REFBYTESIZE = 4;

    private Table globalTable;
    private boolean showVarAlloc;
    private int varOffset = 0;
    private ProcEntry procEntry = null;
    private boolean firstCompute = true;

    public VarAllocator(Table t, boolean s) {
        globalTable = t;
        showVarAlloc = s;
    }


    public void allocVars(Absyn program) {
     /* compute access information for arguments of predefined procs */
        Entry entry;

        entry = globalTable.lookup(Sym.newSym("exit"));
        calcParamOffset((ProcEntry) entry);
        entry = globalTable.lookup(Sym.newSym("time"));
        calcParamOffset((ProcEntry) entry);
        entry = globalTable.lookup(Sym.newSym("readi"));
        calcParamOffset((ProcEntry) entry);
        entry = globalTable.lookup(Sym.newSym("printi"));
        calcParamOffset((ProcEntry) entry);
        entry = globalTable.lookup(Sym.newSym("printc"));
        calcParamOffset((ProcEntry) entry);
        entry = globalTable.lookup(Sym.newSym("clearAll"));
        calcParamOffset((ProcEntry) entry);
        entry = globalTable.lookup(Sym.newSym("setPixel"));
        calcParamOffset((ProcEntry) entry);
        entry = globalTable.lookup(Sym.newSym("drawCircle"));
        calcParamOffset((ProcEntry) entry);
        entry = globalTable.lookup(Sym.newSym("drawLine"));
        calcParamOffset((ProcEntry) entry);


    /* compute access information for arguments, parameters and local vars */
        program.accept(this);
        firstCompute = false;
        program.accept(this);

    }

    private void calcParamOffset(ProcEntry entry) {
        ParamType param;
        Iterator<ParamType> paramIterator = entry.paramTypes.iterator();
        int size = 0;

        while (paramIterator.hasNext()) {
            param = paramIterator.next();
            param.offset = size;
            size += param.isRef ? REFBYTESIZE : param.type.getByteSize();
        }
        entry.argumentAreaSize = size;  //size of argument area
    }

    public void visit(ArrayTy arrayTy) {
    }

    public void visit(ArrayVar arrayVar) {
    }

    public void visit(AssignStm assignStm) {
    }

    public void visit(CallStm callStm) {

        ProcEntry entry = (ProcEntry) globalTable.lookup(callStm.name);
        int argAreaSize = entry.argumentAreaSize;
        //procEntry.stmCall = true;

        if (procEntry.outgoingAreaSize < argAreaSize)
            procEntry.argumentAreaSize = argAreaSize;

    }

    public void visit(CompStm compStm) {
        compStm.stms.accept(this);
    }

    public void visit(DecList decList) {
        Dec node;
        ParamTypeList param = null;
        if (procEntry != null) param = procEntry.paramTypes;

        // for (Absyn aDl : decList) {
         //   aDl.accept(this);
         // }
       // ListNodeIterator<Absyn> decinter = decList.iterator();

        while (!decList.isEmpty()) {
            node = decList.head;

            if (node.getClass() == ProcDec.class) {
                if ((!firstCompute) && showVarAlloc)
                    System.out.println("Variable allocation for procedure '"
                            + ((ProcDec) node).name.toString() + "'");

                procEntry = ((ProcEntry) globalTable.lookup(((ProcDec) node).name));
                ((ProcDec) node).accept(this);

                procEntry.localvarAreaSize = varOffset;
                varOffset = 0;

                if ((!firstCompute) && showVarAlloc) {
                    System.out.println("size of localvar area = " + procEntry.localvarAreaSize);
                    System.out.println("size of outgoing area = " + procEntry.outgoingAreaSize + "\n");
                }

            } else if (node.getClass() == ParDec.class) {
                ((ParDec) node).accept(this);
                System.out.println("fp + " + param.offset);
                param = param.next;

            } else if (node.getClass() == VarDec.class) {
                ((VarDec) node).accept(this);
            }

            decList = decList.tail;
        }


    }

    public void visit(EmptyStm emptyStm) {
    }

    public void visit(ExpList expList) {
    }

    public void visit(IfStm ifStm) {
        ifStm.thenPart.accept(this);
        ifStm.elsePart.accept(this);

    }

    public void visit(IntExp intExp) {
    }

    public void visit(NameTy nameTy) {
    }

    public void visit(OpExp opExp) {
    }

    public void visit(ParDec parDec) {
        System.out.print("param '" + parDec.name.toString() + "': ");
    }

    public void visit(ProcDec procDec) {


        calcParamOffset(procEntry);


    /*print args, size of arg area and params*/
        if (showVarAlloc && !firstCompute) {
            ParamTypeList param = procEntry.paramTypes;
            int i = 1;
            while (!param.isEmpty()) {
                System.out.println("arg " + i + ":" + " sp + " + param.offset);
                i++;
                param = param.next;
            }

            System.out.println("size of argument area = " + procEntry.argumentAreaSize);

       /*print param's */
            procDec.params.accept(this);
        }

    /* compute access information for local vars*/
        procDec.decls.accept(this);

     /* compute outgoing area sizes */
        if (!firstCompute) procDec.body.accept(this);

    }

    public void visit(SimpleVar simpleVar) {
    }

    public void visit(StmList stmList) {
        Stm head;

        while (!stmList.isEmpty()) {
            head = stmList.head;
            head.accept(this);
            stmList = stmList.tail;

        }
    }

    public void visit(TypeDec typeDec) {
    }

    public void visit(VarDec varDec) {
        Entry entry;

        entry = procEntry.localTable.lookup(varDec.name);

        varOffset = varOffset + (((VarEntry) entry).type).getByteSize();
        ((VarEntry) entry).offset = varOffset;

        if (!(firstCompute) && showVarAlloc) {
            System.out.println("var '" + varDec.name.toString() + "': fp - " + varOffset);
        }

    }

    public void visit(VarExp varExp) {
    }

    public void visit(WhileStm whileStm) {
        whileStm.body.accept(this);
    }


}
