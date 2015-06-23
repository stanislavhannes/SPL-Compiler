/* Semant.java -- semantic checks */

package semant;

import absyn.*;
import sym.Sym;
import table.*;
import types.*;
import varalloc.*;
import java.lang.Class;

/**
 * A SemanticChecker object defines a method "check" for semantic 
 * analysis and symbol table construction for SPL
 * <br>
 * SemanticChecker is a singleton class
 * <br>
 * author: Michael Jäger
 */

public class SemanticChecker {

	static final Type intType = new PrimitiveType("int", VarAllocator.INTBYTESIZE);
	static final Type boolType = new PrimitiveType("boolean", VarAllocator.BOOLBYTESIZE);

	public Table check(Absyn program, boolean showTables) {
		Table globalTable = new Table;
		new TableInitializer().intializeSymbolTable(globalTable);

		/* do semantic checks in 2 passes */
		new ProcedureBodyChecker().check(program, globalTable);
		checkNode(program, globalTable);


		 /* return global symbol table */
		return globalTable;

           /* hier gibts noch was zu tun: das Meiste kann an Visitor-Objekte delegiert werden */
	}

	static void checkClass (Object object, Class<?> expectedClass, String errorMessage, int lineNo)  {
		checkClass(object, expectedClass, errorMessage + " in line " + lineNo);
	}

	static void checkClass (Object object, Class<?> expectedClass, String errorMessage)  {
		if (object.getClass()!=expectedClass)
			throw new RuntimeException(errorMessage);
	}

	private void checkMainProcedure(Table globalTable) {
		Entry entry = globalTable.lookup(Sym.newSym("main"));

		if (entry == null) {
			throw new RuntimeException(
					"procedure 'main' is missing"
			);
		}

		if (!(entry instanceof ProcEntry)) {
			throw new RuntimeException(
					"'main' is not a procedure"
			);
		}

		if (!(((ProcEntry) entry).paramTypes.isEmpty())) {
			throw new RuntimeException(
					"procedure 'main' must not have any parameters"
			);
		}
	}
}
