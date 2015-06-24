package semant;

import table.*;
import types.*;
import absyn.*;

class ProcedureBodyChecker {

	protected Table globalTable;

	void check(Absyn program, Table globalTable) {
		program.accept(new CheckVisitor(globalTable));
	}

	private class CheckVisitor extends DoNothingVisitor {

		private Table globalTable;

		public CheckVisitor(Table globalTable) {
			this.globalTable = globalTable;
		}

		public void visit(ProcDec procDec) {

		}

		public void visit(CompStm node) {

		}

	}
}
