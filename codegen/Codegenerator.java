/*
 * Codegen.java -- ECO32 code generator
 */

package codegen;

import java.io.*;
import absyn.*;
import table.*;
import types.*;

public class Codegenerator {

	private PrintWriter output;
	private int nextLabel = 0;
	private static final int firstReg = 8;
	private static final int lastReg  = 23;

	public Codegenerator (FileWriter writer) {
		output = new PrintWriter(writer);
	}

	public void genCode(Absyn node, Table t) {
		assemblerProlog();
		node.accept(new CodegenVisitor(t, firstReg));
	}

	private void checkRegister(int reg) {
		if (reg > lastReg)
			throw new RuntimeException
			("expression too complicated, running out of registers");
	}

	private String newLabel() {
		return "L" + nextLabel++;
	}

	private void assemblerProlog() {
		emitImport("printi");
		emitImport("printc");
		emitImport("readi");
		emitImport("readc");
		emitImport("exit");
		emitImport("time");
		emitImport("clearAll");
		emitImport("setPixel");
		emitImport("drawLine");
		emitImport("drawCircle");
		emitImport("_indexError");
		emit("\n\t.code");
		emit("\t.align\t4");
	}

	private void emitImport(String id) {
		output.format("\t.import\t%s\n", id);
	}
	
	private void emit(String line) {
		output.print(line + "\n");
	}

	private void emitRRI(String opcode, int reg1, int reg2, int value, String comment) {
		output.format("\t%s\t$%d,$%d,%d\t\t; %s\n", opcode, reg1, reg2, value, comment);
	}

	private void emitR(String opcode, int reg, String comment) {
		output.format("\t%s\t$%d\t\t\t; %s\n", opcode, reg, comment);
	}

	private void emitRRI(String opcode, int reg1, int reg2, int value) {
		output.format("\t%s\t$%d,$%d,%d\n", opcode, reg1, reg2, value);
	}

	private void emitRRR(String opcode, int reg1, int reg2, int reg3) {
		output.format("\t%s\t$%d,$%d,$%d\n", opcode, reg1, reg2, reg3);
	}

	private void emitRRL(String opcode, int reg1, int reg2, String labelString) {
		output.format("\t%s\t$%d,$%d,%s\n", opcode, reg1, reg2, labelString);
	}

	private void emitLabel(String labelString) {
		output.format("%s:\n", labelString);
	}

	private void emitJump(String labelString) {
		output.format("\tj\t%s\n", labelString);
	}

	private void emitSS(String s1, String s2) {
		output.print("\t" + s1 + "\t" + s2 + "\n");
	}

	/*------------------------------------------------------------------------------------------------*/
	public class CodegenVisitor extends DoNothingVisitor {
		private Table globalTable;
		private int actReg;

		public CodegenVisitor(Table t, int firstReg) {
			this.globalTable = t;
			this.actReg = firstReg;

		}

		public void visit(ProcDec node) {
			/* get symbol table entry for this procedure */
			ProcEntry entry = (ProcEntry) globalTable.lookup(node.name);

			/* prolog */

			/* epilog */
		}


	}
}
