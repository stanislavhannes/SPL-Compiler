/*
 * Table.java -- symbol table
 */


package table;

import sym.Sym;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;


public class Table {

  private Table upperLevel;
  private Map<Object,Object> dict;


  public Table() {
    upperLevel = null;
    dict = new HashMap<Object,Object>();
  }

  public Table(Table u) {
    upperLevel = u;
    dict = new HashMap<Object,Object>();
  }

  public Entry enter(Sym sym, Entry entry) {
    if (dict.get(sym) != null) {
      return null;
    }
    dict.put(sym, entry);
    return entry;
  }

  public Entry lookup(Sym sym) {
    Table table = this;
    while (table != null) {
      Entry entry = (Entry) table.dict.get(sym);
      if (entry != null) {
        return entry;
      }
      table = table.upperLevel;
    }
    return null;
  }

  public void show() {
    Table table = this;
    int level = 0;
    while (table != null) {
      System.out.println("  level " + level);
      Iterator<Map.Entry<Object,Object>> iter =
        table.dict.entrySet().iterator();
      while (iter.hasNext()) {
        Map.Entry<Object,Object> pair = iter.next();
        Sym sym = (Sym) (pair.getKey());
        Entry entry = (Entry) (pair.getValue());
        System.out.format("  %-10s --> ", sym.toString());
        entry.show();
        System.out.println();
      }
      table = table.upperLevel;
      level++;
    }
  }

}
