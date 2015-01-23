/*
 * Sym.java -- symbol handling
 */


package sym;


public class Sym {

  private static java.util.Map<Object,Object> dict =
    new java.util.HashMap<Object,Object>();
  private String name;

  private Sym(String n) {
    name = n;
  }

  public String toString() {
    return name;
  }

  public static Sym newSym(String n) {
    String u = n.intern();
    Sym s = (Sym) dict.get(u);
    if (s == null) {
      s = new Sym(u);
      dict.put(u, s);
    }
    return s;
  }

}
