/*
 * Type.java -- type representation
 */


package types;


public abstract class Type {

  public int byteSize;

  public int getByteSize(){ return byteSize;}
  public abstract void show();

}
