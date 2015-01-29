/*
 * Semant.java -- semantic checks
 */


package semant;

import absyn.*;
import sym.Sym;
import table.*;
import types.ArrayType;
import types.ParamTypeList;
import types.PrimitiveType;
import types.Type;
import varalloc.Varalloc;


//TODO:Reihenfolge beachten
public class Semant {

    PrimitiveType builtinType_int, builtinType_bool;
    private boolean showTables;


    public Semant(boolean s) {
        showTables = s;
    }

    public Type checkNode(Absyn node, Table table) {
        switch (node.getClass().getName()) {

            case "absyn.NameTy":
                return checkNameTy(node, table);

            case "absyn.ArrayTy":
                return checkArrayTy(node, table);

            case "absyn.TypeDec":
                // already done in 1st run
                break;

            case "absyn.ProcDec":
                checkProcDec(node, table);
                break;

            case "absyn.ParDec":
                return checkParDec(node, table);

            case "absyn.VarDec":
                return checkVarDec(node, table);

            case "absyn.EmptyStm":
                //empty
                break;

            case "absyn.CompStm":
                return checkCompStm(node, table);

            case "absyn.AssignStm":
                checkAssignStm(node, table);
                break;

            case "absyn.IfStm":
                checkIfStm(node, table);
                break;

            case "absyn.WhileStm":
                checkWhileStm(node, table);
                break;
            case "absyn.CallStm":
                checkCallStm(node, table);
                break;

            case "absyn.OpExp":
                return checkOpExp(node, table);

            case "absyn.VarExp":
                return checkVarExp(node, table);

            case "absyn.IntExp":
                return builtinType_int;

            case "absyn.SimpleVar":
                return checkSimpleVar(node, table);

            case "absyn.ArrayVar":
                return checkArrayVar(node, table);

            case "absyn.DecList":
                checkDecList(node, table);
                break;

            case "absyn.StmList":
                checkStmList(node, table);
                break;

            case "absyn.ExpList":
                checkExpList(node, table);
                break;

            default:
                throw new RuntimeException(
                        "unknown node type " + node.getClass().getName()
                                + " in checkNode, line " + node.row
                );
        }

        return null;
    }

    public Type checkNameTy(Absyn node, Table table) {
        Sym name = ((NameTy) node).name;
        Entry entry;

        entry = table.lookup(name);
        if (entry == null) {
            throw new RuntimeException(
                    "undefined type " + name
                            + " in line " + ((NameTy) node).row
            );
        }

        if (!(entry instanceof TypeEntry)) {
            throw new RuntimeException(
                    name + " is not a type in line "
                            + ((NameTy) node).row
            );
        }
        return ((TypeEntry) entry).type;
    }

    public Type checkArrayTy(Absyn node, Table table) {
        Type baseType = checkNode(((ArrayTy) node).ty, table);
        return new ArrayType(((ArrayTy) node).size, baseType);
    }

    public void checkTypeDec(Absyn node, Table table) {
        Type type = checkNode(((TypeDec) node).ty, table);
        Entry entry = new TypeEntry(type);

        if (table.enter(((TypeDec) node).name, entry) == null) {
            throw new RuntimeException(
                    "redeclaration of " + ((TypeDec) node).name
                            + " as type in line " + ((TypeDec) node).row
            );
        }
    }

    public void checkProcDec(Absyn node, Table table) {

        Table localTable;
        Entry entry;

        // lookup procs in local table
        entry = table.lookup(((ProcDec) node).name);
        localTable = ((ProcEntry) entry).localTable;

        // compute local declarations
        checkNode(((ProcDec) node).decls, localTable);

        // compute procedure body
        checkNode(((ProcDec) node).body, localTable);

        //show table
        if (showTables) {
            System.out.println("symbol table at end of procedure '" +
                    ((ProcDec) node).name.toString() + "' :");
            localTable.show();
            System.out.println("\n");
        }

    }

    public Type checkParDec(Absyn node, Table table) {
        Type type = checkNode(((ParDec) node).ty, table);

        if ((type instanceof ArrayType) && !(((ParDec) node).isRef)) {

            throw new RuntimeException(
                    "parameter '" + ((ParDec) node).name
                            + "' must be a reference parameter in line "
                            + ((ParDec) node).row
            );
        }

        return type;
    }

    public Type checkVarDec(Absyn node, Table table) {
        Type type = checkNode(((VarDec) node).ty, table);
        Entry entry = new VarEntry(type, false);

        if (table.enter(((VarDec) node).name, entry) == null) {
            throw new RuntimeException(
                    "redeclaration of '" + ((VarDec) node).name
                            + "' as variable in line " + ((VarDec) node).row
            );
        }
        return type;
    }

    public Type checkCompStm(Absyn node, Table table) {
        return checkNode(((CompStm) node).stms, table);
    }

    public void checkAssignStm(Absyn node, Table table) {
        Type lhs, rhs;

        lhs = checkNode(((AssignStm) node).var, table);
        rhs = checkNode(((AssignStm) node).exp, table);
        if (lhs != rhs) {
            throw new RuntimeException(
                    "assignment has different types in line "
                            + ((AssignStm) node).row
            );
        }
        if (lhs != builtinType_int) {
            throw new RuntimeException(
                    "assignment requires integer variable in line "
                            + ((AssignStm) node).row
            );
        }
    }

    public void checkIfStm(Absyn node, Table table) {

        if (checkNode(((IfStm) node).test, table) != builtinType_bool) {
            throw new RuntimeException(
                    "'if' test expression must be of type boolean in line "
                            + ((IfStm) node).row
            );
        }

        checkNode(((IfStm) node).thenPart, table);
        checkNode(((IfStm) node).elsePart, table);

    }

    public void checkWhileStm(Absyn node, Table table) {
        if (checkNode(((WhileStm) node).test, table) != builtinType_bool) {
            throw new RuntimeException(
                    "'while' test expression must be of type boolean in line "
                            + ((WhileStm) node).row
            );
        }

        checkNode(((WhileStm) node).body, table);
    }

    public void checkCallStm(Absyn node, Table table) {
        Entry entry;
        ParamTypeList paramsList;
        Absyn arg;
        int i = 0;

        entry = table.lookup(((CallStm) node).name);
        if (entry == null)
            throw new RuntimeException(
                    "undefined procedure '"
                            + ((CallStm) node).name.toString()
                            + "' in line " + ((CallStm) node).row
            );
        if (!(entry instanceof ProcEntry))
            throw new RuntimeException(
                    "call of non-procedure '"
                            + ((CallStm) node).name.toString()
                            + "' in line " + ((CallStm) node).row
            );

        paramsList = ((ProcEntry) entry).paramTypes;
        arg = ((CallStm) node).args;

        while (!paramsList.isEmpty) {
            i++;

            if (((ExpList) arg).isEmpty) {
                throw new RuntimeException(
                        "procedure '" + ((CallStm) node).name.toString()
                                + "' called with too few arguments in line "
                                + ((CallStm) node).row
                );
            }

            checkNode(((ExpList) arg).head, table); //check if variable is defined

            if (paramsList.isRef && !(((ExpList) arg).head instanceof VarExp)) {
                throw new RuntimeException(
                        "procedure '" + ((CallStm) node).name.toString()
                                + "' argument " + i
                                + " must be a variable in line "
                                + ((CallStm) node).row
                );
            }

            if (paramsList.type != checkNode(((ExpList) arg).head, table)) {
                throw new RuntimeException(
                        "procedure '" + ((CallStm) node).name.toString()
                                + "' argument " + i
                                + " type mismatch in line "
                                + ((CallStm) node).row
                );
            }

            arg = ((ExpList) arg).tail;
            paramsList = paramsList.next;
        }

        if (!((ExpList) arg).isEmpty)
            throw new RuntimeException(
                    "procedure '" + ((CallStm) node).name.toString()
                            + "' called with too many arguments in line "
                            + ((CallStm) node).row
            );

    }

    public Type checkOpExp(Absyn node, Table table) {
        Type leftType, rightType, expType;

        leftType = checkNode(((OpExp) node).left, table);
        rightType = checkNode(((OpExp) node).right, table);

        if (leftType != rightType) {
            throw new RuntimeException(
                    "expression combines different types in line "
                            + ((OpExp) node).row
            );
        }
        switch (((OpExp) node).op) {
            case OpExp.EQU:    // case fall-through, following cases same type
            case OpExp.NEQ:
            case OpExp.LST:
            case OpExp.LSE:
            case OpExp.GRT:
            case OpExp.GRE:
                if (leftType != builtinType_int) {
                    throw new RuntimeException(
                            "comparison requires integer operands in line "
                                    + ((OpExp) node).row
                    );
                }
                expType = builtinType_bool;
                break;
            case OpExp.ADD:    // case fall-through, following cases same type
            case OpExp.SUB:
            case OpExp.MUL:
            case OpExp.DIV:
                if (leftType != builtinType_int) {
                    throw new RuntimeException(
                            "arithmetic operation requires integer operands in line "
                                    + ((OpExp) node).row
                    );
                }
                expType = builtinType_int;
                break;
            default:
                throw new RuntimeException(
                        "undefined operation expression in line  "
                                + ((OpExp) node).row
                );
        }
        return expType;
    }

    public Type checkVarExp(Absyn node, Table table) {
        return checkNode(((VarExp) node).var, table);
    }

    public Type checkSimpleVar(Absyn node, Table table) {

        Entry entry = table.lookup(((SimpleVar) node).name);

        if (entry == null) {
            throw new RuntimeException(
                    "undefined variable '" + ((SimpleVar) node).name.toString()
                            + "' in line " + ((SimpleVar) node).row
            );
        }
        if (!(entry instanceof VarEntry)) {
            throw new RuntimeException(
                    "'" + ((SimpleVar) node).name.toString() +
                            "' is not a variable in line "
                            + ((SimpleVar) node).row
            );
        }

        return ((VarEntry) entry).type;
    }

    public Type checkArrayVar(Absyn node, Table table) {
        Type type;

        if (checkNode(((ArrayVar) node).index, table) != builtinType_int) {
            throw new RuntimeException(
                    "illegal indexing with a non-integer in line "
                            + ((ArrayVar) node).row
            );
        }

        type = checkNode(((ArrayVar) node).var, table);

        if (!(type instanceof ArrayType)) {
            throw new RuntimeException(
                    "illegal indexing a non-array in line "
                            + ((ArrayVar) node).row
            );
        }

        return ((ArrayType) type).baseType;
    }

    public void checkDecList(Absyn node, Table table) {
        if (((DecList) node).isEmpty) return;

        checkNode(((DecList) node).head, table);
        checkNode(((DecList) node).tail, table);
    }

    public void checkStmList(Absyn node, Table table) {
        if (((StmList) node).isEmpty) return;

        checkNode(((StmList) node).head, table);
        checkNode(((StmList) node).tail, table);
    }

    public void checkExpList(Absyn node, Table table) {
        if (((ExpList) node).isEmpty) return;

        checkNode(((ExpList) node).head, table);
        checkNode(((ExpList) node).tail, table);
    }

    public void enterProcDecs(DecList program, Table globalTable) {
        Absyn node;
        DecList programDecList = program;
        DecList nodeProcDec;
        Entry entry;
        Sym name;
        Table localTable;
        ParamTypeList paramsTypeList, newParam, prevParam = null;


        while (!programDecList.isEmpty) {  //while (program) DecList is not empty (empty == false)
            node = programDecList.head;

            if (node.getClass().getName().equals("absyn.ProcDec")) {

                //create a ParamTypeList
                nodeProcDec = ((ProcDec) node).params;  //DecList params -> head=ParDec
                paramsTypeList = null;
                if (nodeProcDec.isEmpty) {
                    paramsTypeList = new ParamTypeList();
                } else {
                    while (!nodeProcDec.isEmpty) {

                        newParam = new ParamTypeList(checkNode(nodeProcDec.head, globalTable),
                                ((ParDec) nodeProcDec.head).isRef, null);
                        if (paramsTypeList == null) {
                            paramsTypeList = newParam;
                        } else {
                            prevParam.next = newParam;
                        }
                        prevParam = newParam;
                        nodeProcDec = nodeProcDec.tail;
                    }
                    prevParam.next = new ParamTypeList();
                }

                localTable = new Table(globalTable);
                entry = new ProcEntry(paramsTypeList, localTable);

                // check redeclaration of proc and enter into globalTable
                if (globalTable.enter(((ProcDec) node).name, entry) == null) {
                    throw new RuntimeException(
                            "redeclaration of '" + ((ProcDec) node).name
                                    + "' as procedure in line " + ((ProcDec) node).row
                    );
                }

                // check redeclaration of params and enter into localTable
                nodeProcDec = ((ProcDec) node).params;
                while (!nodeProcDec.isEmpty) {

                    name = ((ParDec) nodeProcDec.head).name;
                    entry = new VarEntry(checkNode(((ParDec) nodeProcDec.head).ty, globalTable),
                            ((ParDec) nodeProcDec.head).isRef);
                    if (localTable.enter(name, entry) == null) {
                        throw new RuntimeException(
                                "redeclaration of '" + name
                                        + "' as parameter in line "
                                        + ((ParDec) nodeProcDec.head).row
                        );
                    }

                    nodeProcDec = nodeProcDec.tail;
                }


            } else if (node.getClass().getName().equals("absyn.TypeDec")) {
                checkTypeDec(node, globalTable);
            }

            programDecList = programDecList.tail;
        }
    }

    public Table check(Absyn program) {

        Table globalTable = new Table();
        Entry entry;

    /* generate built-in types */
        builtinType_int = new PrimitiveType("int", Varalloc.intByteSize);
        builtinType_bool = new PrimitiveType("bool", Varalloc.boolByteSize);
        ParamTypeList oneIntParam = new ParamTypeList(builtinType_int, false, new ParamTypeList());
        ParamTypeList oneRefIntParam = new ParamTypeList(builtinType_int, true, new ParamTypeList());
        ParamTypeList threeIntParam = new ParamTypeList(
                builtinType_int, false, new ParamTypeList(
                builtinType_int, false, new ParamTypeList(
                builtinType_int, false, new ParamTypeList(

        ))));
        ParamTypeList fourIntParam = new ParamTypeList(
                builtinType_int, false, new ParamTypeList(
                builtinType_int, false, new ParamTypeList(
                builtinType_int, false, new ParamTypeList(
                builtinType_int, false, new ParamTypeList(

        )))));
        ParamTypeList fiveIntParam = new ParamTypeList(
                builtinType_int, false, new ParamTypeList(
                builtinType_int, false, new ParamTypeList(
                builtinType_int, false, new ParamTypeList(
                builtinType_int, false, new ParamTypeList(
                builtinType_int, false, new ParamTypeList(

        ))))));

        ProcEntry builtinProc_printi = new ProcEntry(oneIntParam, globalTable);
        ProcEntry builtinProc_printc = new ProcEntry(oneIntParam, globalTable);
        ProcEntry builtinProc_readi = new ProcEntry(oneRefIntParam, globalTable);
        ProcEntry builtinProc_exit = new ProcEntry(new ParamTypeList(), globalTable);
        ProcEntry builtinProc_time = new ProcEntry(oneRefIntParam, globalTable);
        ProcEntry builtinProc_clearAll = new ProcEntry(oneIntParam, globalTable);
        ProcEntry builtinProc_setPixel = new ProcEntry(threeIntParam, globalTable);
        ProcEntry builtinProc_drawLine = new ProcEntry(fiveIntParam, globalTable);
        ProcEntry builtinProc_drawCircle = new ProcEntry(fourIntParam, globalTable);

    /* setup global symbol table */
        globalTable.enter(Sym.newSym("int"), new TypeEntry(builtinType_int));
        globalTable.enter(Sym.newSym("printi"), builtinProc_printi);
        globalTable.enter(Sym.newSym("printc"), builtinProc_printc);
        globalTable.enter(Sym.newSym("readi"), builtinProc_readi);
        globalTable.enter(Sym.newSym("exit"), builtinProc_exit);
        globalTable.enter(Sym.newSym("time"), builtinProc_time);
        globalTable.enter(Sym.newSym("clearAll"), builtinProc_clearAll);
        globalTable.enter(Sym.newSym("setPixel"), builtinProc_setPixel);
        globalTable.enter(Sym.newSym("drawLine"), builtinProc_drawLine);
        globalTable.enter(Sym.newSym("drawCircle"), builtinProc_drawCircle);



    /* do semantic checks in 2 passes */
        enterProcDecs((DecList) program, globalTable);
        checkNode(program, globalTable);

    /* check if "main()" is present */
        entry = globalTable.lookup(Sym.newSym("main"));

        if (entry == null) {
            throw new RuntimeException(
                    "procedure 'main' is missing"
            );
        }

        if (!(entry instanceof ProcEntry)) {
            throw new RuntimeException(
                    "'main' is not a procedure"
            );
        }

        if (!(((ProcEntry) entry).paramTypes.isEmpty)) {
            throw new RuntimeException(
                    "procedure 'main' must not have any parameters"
            );
        }

    /* return global symbol table */
        return globalTable;
    }

}
