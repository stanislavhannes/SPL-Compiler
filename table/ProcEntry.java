/*
 * ProcEntry.java -- table entry for a procedure
 */


package table;

import types.ParamTypeList;


public class ProcEntry extends Entry {

  public ParamTypeList paramTypes;
  public Table localTable;
  public int argAreaSize;   //size of argument area
  public boolean stmCall = false;
  public int varAreaSize;   // size of localvar area
  public int outAreaSize = -1;   // size of outgoing area

  public ProcEntry(ParamTypeList p, Table t) {
    paramTypes = p;
    localTable = t;
  }

  public void show() {
    System.out.print("proc: ");
    paramTypes.show();
  }

}
