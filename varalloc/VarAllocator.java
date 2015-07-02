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
    private Iterator<ParamType> paramIterator;

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

    public void visit(CallStm callStm) {
        ProcEntry entry = (ProcEntry) globalTable.lookup(callStm.name);
        int argAreaSize = entry.argumentAreaSize;

        if (procEntry.outgoingAreaSize < argAreaSize)
            procEntry.outgoingAreaSize = argAreaSize;
    }

    public void visit(CompStm compStm) {
        compStm.stms.accept(this);
    }

    public void visit(DecList decList) {
        ListNodeIterator decListIterator = decList.iterator();
        if (procEntry != null) paramIterator = procEntry.paramTypes.iterator();

        while (decListIterator.hasNext()) {
            decListIterator.next().accept(this);
        }
    }

    public void visit(IfStm ifStm) {
        ifStm.thenPart.accept(this);
        ifStm.elsePart.accept(this);
    }

    public void visit(ParDec parDec) {
        ParamType parameter;
        System.out.print("param '" + parDec.name.toString() + "': ");
        if(paramIterator.hasNext()) {
            parameter = paramIterator.next();
            System.out.println("fp + " + parameter.offset);
        }
    }

    public void visit(ProcDec procDec) {
        /*prints headtitle for the procedure*/
        if ((!firstCompute) && showVarAlloc) {
            System.out.println("Variable allocation for procedure '"
                    + procDec.name.toString() + "'");
        }
        procEntry = ((ProcEntry) globalTable.lookup(procDec.name));

        calcParamOffset(procEntry);

        /*print arguments and size of arg area*/

        if (showVarAlloc && !firstCompute) {
            Iterator<ParamType> argIterator = procEntry.paramTypes.iterator();
            ParamType parameter;
            int i = 1;
            while (argIterator.hasNext()) {
                parameter = argIterator.next();
                System.out.println("arg " + i + ":" + " sp + " + parameter.offset);
                i++;
            }
            System.out.println("size of argument area = " + procEntry.argumentAreaSize);

       /*print param's */
            procDec.params.accept(this);
        }

    /* compute access information for local vars*/
        procDec.decls.accept(this);

     /* compute outgoing area sizes */
        if (!firstCompute) procDec.body.accept(this);

        procEntry.localvarAreaSize = varOffset;
        varOffset = 0;

        if ((!firstCompute) && showVarAlloc) {
            System.out.println("size of localvar area = " + procEntry.localvarAreaSize);
            System.out.println("size of outgoing area = " + procEntry.outgoingAreaSize + "\n");
        }

    }

    public void visit(StmList stmList) {
        for (Absyn aSl : stmList) aSl.accept(this);
    }

    public void visit(VarDec varDec) {
        Entry entry = procEntry.localTable.lookup(varDec.name);

        varOffset = varOffset + (((VarEntry) entry).type).getByteSize();
        ((VarEntry) entry).offset = varOffset;

        if (!(firstCompute) && showVarAlloc) {
            System.out.println("var '" + varDec.name.toString() + "': fp - " + varOffset);
        }
    }

    public void visit(WhileStm whileStm) {
        whileStm.body.accept(this);
    }

}
