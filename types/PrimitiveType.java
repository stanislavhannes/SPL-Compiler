/*
 * PrimitiveType.java -- primitive type representation
 */


package types;


public class PrimitiveType extends Type {

  public String printName;

  public PrimitiveType(String p, int s) {
    printName = p;
    byteSize = s;
  }

  public void show() {
    System.out.print(printName);
  }

}
