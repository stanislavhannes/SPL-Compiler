/*
 * VarEntry.java -- table entry for a variable
 */


package table;

import types.*;


public class VarEntry extends Entry {

  public Type type;
  public boolean isRef;
  public int offset;		/* filled in by variable allocator */

  public VarEntry(Type t, boolean r) {
    type = t;
    isRef = r;
  }

  public void show() {
    System.out.print("var: ");
    if (isRef) {
      System.out.print("ref ");
    }
    type.show();
  }

}
