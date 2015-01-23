/*
 * ArrayType.java -- array type representation
 */


package types;


public class ArrayType extends Type {

  public int size;
  public Type baseType;
  private int byteSize;

  public ArrayType(int s, Type t) {
    size = s;
    baseType = t;
    byteSize = baseType.getByteSize() * size;

  }

  public void show() {
    System.out.print("array [");
    System.out.print(size);
    System.out.print("] of ");
    baseType.show();
  }

  public int getByteSize() {
    return byteSize;
  }

}
