/*
 * Table.java -- symbol table
 */

package table;

import sym.Sym;
import java.util.*;

public class Table {

	private Table upperLevel;
	private Map<Sym, Entry> dict;

	public Table() {
		upperLevel = null;
		dict = new HashMap<Sym, Entry>();
	}

	public Table(Table u) {
		upperLevel = u;
		dict = new HashMap<Sym, Entry>();
	}

	public Entry enter(Sym sym, Entry entry) {
		/*
		 * This enter-method is for initialisation of the table with predefined
		 * identifiers: redefinitions do not occur here
		 */
		if (dict.get(sym) != null) {
			return null;
		}
		dict.put(sym, entry);
		return entry;
	}

	public Entry enter(Sym sym, Entry entry, String errorMsg) {
		/*
		 * This enter-method is for user-defined identifiers: redefinitions
		 * might occur here
		 */
		if (dict.get(sym) != null)
			throw new RuntimeException(errorMsg);
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

	public Entry getDeclaration(Sym sym, String errorMsg) {
		Entry e = lookup(sym);
		if (e == null)
			throw new RuntimeException(errorMsg);
		return e;
	}

	public void show() {
		Table table = this;
		int level = 0;
		while (table != null) {
			System.out.println("  level " + level);
			Iterator<Map.Entry<Sym, Entry>> iter = table.dict.entrySet()
					.iterator();
			while (iter.hasNext()) {
				Map.Entry<Sym, Entry> pair = iter.next();
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
