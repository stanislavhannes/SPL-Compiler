package semant;

import sym.Sym;
import table.*;
import types.*;



class TableInitializer {
	static Type intType = SemanticChecker.intType;
	static Type boolType = SemanticChecker.boolType;

	void intializeSymbolTable(Table globalTable) {
		enterPredefinedTypes(globalTable);
		enterPredefinedProcedures(globalTable);
	}

	
	private void enterPredefinedTypes(Table table) {
		table.enter(Sym.newSym("int"), new TypeEntry(intType));
	}

	@SuppressWarnings("serial")
	private void enterPredefinedProcedures(Table table) {
		ParamTypeList p;

		/* printi(i: int) */
		p = new ParamTypeList(){{
			add(intType, false);
		}};
		table.enter(Sym.newSym("printi"), new ProcEntry(p,table));

		/* printc(i: int) */
		p = new ParamTypeList(){{
			add(intType, false);
		}};
		table.enter(Sym.newSym("printc"), new ProcEntry(p,table));

		/* readi(ref i: int) */
		p = new ParamTypeList(){{
			add(intType, true);
		}};
		table.enter(Sym.newSym("readi"), new ProcEntry(p, table));

		/* readc(ref i: int) */
		p = new ParamTypeList(){{
			add(intType, true);
		}};
		table.enter(Sym.newSym("readc"), new ProcEntry(p, table));

		/* exit() */
		p = new ParamTypeList();
		table.enter(Sym.newSym("exit"), new ProcEntry(p, table));

		/* time(ref i: int) */
		p = new ParamTypeList(){{
			add(intType, true);
		}};
		table.enter(Sym.newSym("time"), new ProcEntry(p, table));

		/* clearAll(color: int) */
		p = new ParamTypeList(){{
			add(intType, false);
		}};
		table.enter(Sym.newSym("clearAll"), new ProcEntry(p, table));

		/* setPixel(x: int, y: int, color: int) */
		p = new ParamTypeList(){{
			add(intType, false);
			add(intType, false);
			add(intType, false);
		}};
		table.enter(Sym.newSym("setPixel"), new ProcEntry(p, table));

		/* drawLine(x1: int, y1: int, x2: int, y2: int, color: int) */
		p = new ParamTypeList(){{
			add(intType, false);
			add(intType, false);
			add(intType, false);
			add(intType, false);
			add(intType, false);
		}};
		table.enter(Sym.newSym("drawLine"), new ProcEntry(p, table));

		/* drawCircle(x0: int, y0: int, radius: int, color: int) */
		p = new ParamTypeList(){{
			add(intType, false);
			add(intType, false);
			add(intType, false);
			add(intType, false);
		}};
		table.enter(Sym.newSym("drawCircle"), new ProcEntry(p, table));
	}

}

