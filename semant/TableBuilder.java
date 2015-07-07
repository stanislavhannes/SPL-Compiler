package semant;

import sym.Sym;
import table.*;
import types.*;
import absyn.*;

class TableBuilder {

	private boolean showTables;
	private Table globalTable = new Table();

	Table buildSymbolTables(Absyn program, boolean showTables) {
		new TableInitializer().intializeSymbolTable(globalTable);
		program.accept(new TableBuilderVisitor());

		if(showTables){
			printSymbolTables(program);
		}

		return globalTable;
	}

	private void printSymbolTables(Absyn program) {
		if(program instanceof DecList){
			ListNodeIterator i = ((DecList) program).iterator();
			while(i.hasNext()){
				Absyn a = i.next();
				if(a instanceof ProcDec){
					ProcEntry e = (ProcEntry)globalTable.lookup(((ProcDec) a).name);
					System.out.println("symbol table at the end of procedure '"
							+ ((ProcDec) a).name + "'");
					e.localTable.show();
				}
			}
		}
	}

	private class TableBuilderVisitor extends DoNothingVisitor {
		Type type;
		Table localTable;
		ParamTypeList paramList;

		@Override
		public void visit(DecList list) {
			for (Absyn aList : list) aList.accept(this);
		}

		@Override
		public void visit(TypeDec node) {
			node.ty.accept(this);
			globalTable.enter(node.name, new TypeEntry(type),
					"redeclaration of '" + node.name + "' as type in line " + node.row);
		}

		@Override
		public void visit(NameTy node) {
			Entry GloEntry = globalTable.lookup(node.name);


			if(GloEntry instanceof TypeEntry) {
				type = ((TypeEntry) GloEntry).type;
			} else {
				Entry LocEntry = localTable.lookup(node.name);
				if (LocEntry != null){
					throw new RuntimeException(
							"'" + node.name + "' is not a type in line "
									+ node.row
					);
				} else {
					throw new RuntimeException(
						"undefined type " + node.name
								+ " in line " + node.row
					);
				}
			}
		}

		@Override
		public void visit(ArrayTy node) {
			node.baseTy.accept(this);
			type = new ArrayType(node.size, type);
		}

		@Override
		public void visit(ProcDec node) {
			paramList = new ParamTypeList();
			localTable = new Table(globalTable);

			node.params.accept(this);
			node.decls.accept(this);

			globalTable.enter(node.name, new ProcEntry(paramList, localTable),
					"redeclaration of '" + node.name + "' as procedure in line " + node.row);
			paramList = null;

		}

		@Override
		public void visit(ParDec node) {
			node.ty.accept(this);
			localTable.enter(node.name, new VarEntry(type,node.isRef),
					"redeclaration of '" + node.name + "' as parameter in line " + node.row);

			if ((type instanceof ArrayType) && !(node.isRef)) {
				throw new RuntimeException(
						"parameter '" + node.name
								+ "' must be a reference parameter in line "
								+ node.row
				);
			}
			paramList.add(type, node.isRef);
		}

		@Override
		public void visit(VarDec node) {
			node.ty.accept(this);
			localTable.enter(node.name, new VarEntry(type, false),
					"Redeclaration of '" + node.name + "' as variable in line " + node.row);

		}
	}
}


