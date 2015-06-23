/*
 * ParamType -- a parameter type representation
 */


package types;


public class ParamType {
  public Type type;
  public boolean isRef;
  public int offset;		/* filled in by variable allocator */

  public ParamType(Type t, boolean r) {
    type = t;
    isRef = r;
  }

  public void show() {
      if (isRef)
        System.out.print("ref ");
      type.show();
  }
}

