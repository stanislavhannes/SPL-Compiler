/*
 * ParamTypeList -- a list of parameter type representations
 */


package types;


public class ParamTypeList {

  public boolean isEmpty;
  public Type type;
  public boolean isRef;
  public ParamTypeList next;
  public int offset;

  public ParamTypeList() {
    isEmpty = true;
  }

  public ParamTypeList(Type t, boolean r, ParamTypeList n) {
    isEmpty = false;
    type = t;
    isRef = r;
    next = n;
  }

  public void show() {
    ParamTypeList list = this;
    System.out.print("(");
    while (!list.isEmpty) {
      if (list.isRef) {
        System.out.print("ref ");
      }
      list.type.show();
      list = list.next;
      if (!list.isEmpty) {
        System.out.print(", ");
      }
    }
    System.out.print(")");
  }

}
