/*
 * PrimitiveType.java -- primitive type representation
 */


package types;


public class PrimitiveType extends Type {

  public String printName;
  private int byteSize;

  public PrimitiveType(String p, int s) {
    printName = p;
    byteSize = s;
  }

  public void show() {
    System.out.print(printName);
  }

  public int getByteSize() {
    return byteSize;
  }

}
