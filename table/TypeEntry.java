/*
 * TypeEntry.java -- table entry for a type
 */


package table;

import types.*;


public class TypeEntry extends Entry {

  public Type type;

  public TypeEntry(Type t) {
    type = t;
  }

  public void show() {
    System.out.print("type: ");
    type.show();
  }

}
