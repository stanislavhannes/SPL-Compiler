/*
 * Codegen.java -- ECO32 code generator
 */

package codegen;

import java.io.*;
import java.util.Iterator;

import absyn.*;
import table.*;
import types.*;
import varalloc.VarAllocator;

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
		private String label;
		private ProcEntry procEntry;

		public CodegenVisitor(Table t, int firstReg) {
			this.globalTable = t;
			this.actReg = firstReg;
		}

		@Override
		public void visit(ProcDec node) {
			int retByteSize = VarAllocator.INTBYTESIZE;
			int frameByteSize = VarAllocator.INTBYTESIZE;
			int oldRetOffset;
			int oldFrameOffset;
			int frameRange;

			/* get symbol table entry for this procedure */
			procEntry = (ProcEntry) globalTable.lookup(node.name);
			emit("");
			emitSS(".export", node.id());
			emitLabel(node.id());

			/* prolog */
			// calc Frame Range to allocate the Frame
			frameRange = procEntry.localvarAreaSize + frameByteSize + retByteSize;
			frameRange += (procEntry.outgoingAreaSize < 0) ? 0 : procEntry.outgoingAreaSize;
			emitRRI("sub",29,29,frameRange, "allocate frame");

			//save old frame pointer
			oldFrameOffset = retByteSize;
			oldFrameOffset += (procEntry.outgoingAreaSize < 0) ? 0 : procEntry.outgoingAreaSize;
			emitRRI("stw",25,29,oldFrameOffset,"save old frame pointer");

			//setup new frame pointer
			emitRRI("add",25,29,frameRange, "setup new frame pointer");

			//save old return register
			oldRetOffset = procEntry.localvarAreaSize + frameByteSize + retByteSize;
			emitRRI("stw",31,25,-oldRetOffset, "save return register");

			/* rumpf */
			node.body.accept(this);

			/* epilog */
			if(procEntry.outgoingAreaSize >= 0) {
				emitRRI("ldw", 31, 25, -oldRetOffset, "restore return register");
			}
			emitRRI("ldw", 25, 29, oldFrameOffset, "restore old frame pointer");
			emitRRI("add", 29, 29, frameRange, "release frame");
			emitR("jr", 31, "return");

		}

		@Override
		public void visit(StmList sl){
			for (Absyn aDl : sl) aDl.accept(this);
		}

		@Override
		public void visit(IntExp ie){
			checkRegister(actReg);
			emitRRI("add", actReg, 0, ie.val);
			actReg++;
		}

		@Override
		public void visit(OpExp oe){
			oe.left.accept(this);
			oe.right.accept(this);

			switch(oe.op){
				case OpExp.ADD:
					emitRRR("add", actReg-2, actReg-2, actReg-1);
					break;
				case OpExp.SUB:
					emitRRR("sub", actReg-2, actReg-2, actReg-1);
					break;
				case OpExp.MUL:
					emitRRR("mul", actReg-2, actReg-2, actReg-1);
					break;
				case OpExp.DIV:
					emitRRR("div", actReg-2, actReg-2, actReg-1);
					break;
				case OpExp.EQU:
					emitRRL("beq", actReg-2, actReg-1, label);
					break;
				case OpExp.NEQ:
					emitRRL("bne", actReg-2, actReg-1, label);
					break;
				case OpExp.GRT:
					emitRRL("bgt", actReg-2, actReg-1, label);
					break;
				case OpExp.LST:
					emitRRL("blt", actReg-2, actReg-1, label);
					break;
				case OpExp.GRE:
					emitRRL("bge", actReg-2, actReg-1, label);
					break;
				case OpExp.LSE:
					emitRRL("ble", actReg-2, actReg-1, label);
					break;
			}
			actReg--;
		}

		@Override
		public void visit(SimpleVar sv){
			VarEntry entryVar = (VarEntry) procEntry.localTable.lookup(sv.name);
			checkRegister(actReg);

			System.out.println("offset von " + sv.name.toString() + " : " + entryVar.offset);

			if (entryVar.isRef) {
				emitRRI("add", actReg, 25, entryVar.offset);
				emitRRI("ldw", actReg, actReg, 0);
			} else
				emitRRI("add",actReg,25, -entryVar.offset);

			actReg++;
		}

		@Override
		public void visit(VarExp ve){
			ve.var.accept(this);
			emitRRI("ldw", actReg-1, actReg-1, 0);
		}

		@Override
		public void visit(AssignStm as){
			as.var.accept(this); // actReg - 1;
			as.exp.accept(this); // actReg;
			emitRRI("stw", actReg-1, actReg-2, 0);  // speichert wert von actReg-2($8) + 0 in actReg-1($9)
			actReg = actReg - 2;  // release register
		}

		@Override
		public void visit(ArrayVar av){
			av.var.accept(this);
			av.index.accept(this);
			emitRRI("add", actReg, 0, ((ArrayType) av.var.dataType).size);

			--actReg;
			emitRRL("bgeu", actReg, actReg+1, "_indexError");

			//berechnet offset innerhalb array
			emitRRI("mul", actReg, actReg, av.dataType.byteSize);

			//neue adresse von array pos innerhalb arrays in actReg-1 speichern
			emitRRR("add", actReg - 1, actReg - 1, actReg);
		}

		@Override
		public void visit(WhileStm ws){
			String l1 = newLabel();
			String l2 = newLabel();
			String l3 = newLabel();

			label = l2;
			emitLabel(l1);
			ws.test.accept(this);

			emitJump(l3);
			emitLabel(l2);

			ws.body.accept(this);

			emitJump(l1);
			emitLabel(l3);
		}

		@Override
		public void visit(IfStm is){
			String l1 = newLabel();
			String l2 = newLabel();
			label = l1;

			is.test.accept(this);

			if(is.elsePart != null)
				is.elsePart.accept(this);

			emitJump(l2);
			emitLabel(l1);

			is.thenPart.accept(this);

			emitLabel(l2);
		}

		@Override
		public void visit(CallStm cs){
			int i = 0;
			ListNodeIterator ArgsIt = cs.args.iterator();
			Iterator<ParamType> ParamsIt = ((ProcEntry)globalTable.lookup(cs.name)).paramTypes.iterator();

			while(ArgsIt.hasNext()){
				Absyn a = ArgsIt.next();
				ParamType p = ParamsIt.next();

				if(p.isRef)
					((VarExp)a).var.accept(this);
				else
					a.accept(this);

				emitRRI("stw", actReg-1, 29, p.offset, "store arg #" + i++);
				actReg--;
			}

			emitSS("jal", cs.id());
		}

		@Override
		public void visit(DecList dl) {
			for (Absyn aDl : dl) aDl.accept(this);
		}

	}
}
