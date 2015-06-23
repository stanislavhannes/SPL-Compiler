/*
 * ProcEntry.java -- table entry for a procedure
 */


package table;

import types.*;


public class ProcEntry extends Entry {

  public ParamTypeList paramTypes;
  public Table localTable;
  public int argumentAreaSize;	/* filled in by variable allocator */
  public int localvarAreaSize;	/* filled in by variable allocator */
  public int outgoingAreaSize;	/* filled in by variable allocator */

  public ProcEntry(ParamTypeList p, Table t) {
    paramTypes = p;
    localTable = t;
  }

  public void show() {
    System.out.print("proc: ");
    paramTypes.show();
  }

}
