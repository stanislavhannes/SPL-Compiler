package absyn;

public class PrintVisitor extends Visitor {
	int indentation;

	public PrintVisitor(int indentation){
		this.indentation=indentation;
	}


	private static void indent(int n) {
		for (int i = 0; i < n; i++) {
			System.out.print("  ");
		}
	}

	private static void say(String s) {
		System.out.print(s);
	}

	private static void sayInt(int i) {
		System.out.print(i);
	}

	private static void sayBoolean(boolean b) {
			System.out.print(b?"true":"false");
	}

	private static void showListElements(ListNode listNode, int indentation){
		for (Absyn element: listNode) {
			say("\n");
			element.show(indentation + 1);
			if (!listNode.tail().isEmpty())
				say(",");
		}
	}
	
	public void visit(ArrayTy t){
		indent(indentation);
		say("ArrayTy(\n");
		indent(indentation + 1);
		sayInt(t.size);
		say(",\n");
		t.baseTy.show(indentation+1);
		say(")");	
	};

	public void visit(ArrayVar v){
		indent(indentation);
		say("ArrayVar(\n");
		v.var.show(indentation+1);
		say(",\n");
		v.index.show(indentation+1);
		say(")");
	}

	public void visit(AssignStm s){
		indent(indentation);
		say("AssignStm(\n");
		s.var.show(indentation + 1);
		say(",\n");
		s.exp.show(indentation + 1);
		say(")");
	}

	public void visit(CallStm s){
		indent(indentation);
		say("CallStm(\n");
		indent(indentation + 1);
		say(s.name.toString()); 
		say(",\n");
		s.args.show(indentation + 1);
		say(")");
	}

	public void visit(CompStm s){
		indent(indentation);
		say("CompStm(\n");
		s.stms.show(indentation + 1);
		say(")");
	}

	public void visit(DecList d){
		indent(indentation);
		say("DecList(");
		showListElements(d, indentation+1);
		say(")");
	}

	public void visit(EmptyStm s){
		indent(indentation);
		say("EmptyStm()");
	}

	public void visit(ExpList l){
		indent(indentation);
		say("ExpList(");
		showListElements(l, indentation+1);
		say(")");
	}

	public void visit(IfStm s){
		indent(indentation);
		say("IfStm(\n");
		s.test.show(indentation + 1);
		say(",\n");
		s.thenPart.show(indentation + 1);
		say(",\n");
		s.elsePart.show(indentation + 1);
		say(")");
	}

	public void visit(IntExp e){
		indent(indentation);
		say("IntExp(");
		sayInt(e.val);
		say(")");
	}

	public void visit(NameTy t){
		indent(indentation);
		say("NameTy(");
		say(t.name.toString());
		say(")");
	}

	public void visit(OpExp e){
		indent(indentation);
		say("OpExp(\n");
		indent(indentation + 1);
		switch (e.op) {
		case OpExp.EQU: say("EQU");	break;
		case OpExp.NEQ:	say("NEQ");	break;
		case OpExp.LST:	say("LST");	break;
		case OpExp.LSE:	say("LSE");	break;
		case OpExp.GRT:	say("GRT");	break;
		case OpExp.GRE:	say("GRE");	break;
		case OpExp.ADD:	say("ADD");	break;
		case OpExp.SUB:	say("SUB");	break;
		case OpExp.MUL:	say("MUL");	break;
		case OpExp.DIV:	say("DIV");	break;
		default: 
			throw new RuntimeException(
				"unknown operator " + e.op + " in visit(OpExp)"
			);
		}
		say(",\n");
		e.left.show(indentation + 1);
		say(",\n");
		e.right.show(indentation + 1);
		say(")");
	}

	public void visit(ParDec d){
		indent(indentation);
		say("ParDec(\n");
		indent(indentation + 1);
		say(d.name.toString());
		say(",\n");
		d.ty.show(indentation + 1);
		say(",\n");
		indent(indentation + 1);
		sayBoolean(d.isRef);
		say(")");
	}


	public void visit(ProcDec d){
		indent(indentation);
		say("ProcDec(\n");
		indent(indentation + 1);
		say(d.name.toString());
		say(",\n");
		d.params.show(indentation + 1);
		say(",\n");
		d.decls.show(indentation + 1);
		say(",\n");
		d.body.show(indentation + 1);
		say(")");
	}

	public void visit(SimpleVar v){
		indent(indentation);
		say("SimpleVar(");
		say(v.name.toString());
		say(")");
	}


	public void visit(StmList s){
		indent(indentation);
		say("StmList(");
		showListElements(s, indentation+1);
		say(")");
	}

	public void visit(VarDec d){
		indent(indentation);
		say("VarDec(\n");
		indent(indentation + 1);
		say(d.name.toString());
		say(",\n");
		d.ty.show(indentation + 1);
		say(")");
	}

	public void visit(WhileStm s){
		indent(indentation);
		say("WhileStm(\n");
		s.test.show(indentation + 1);
		say(",\n");
		s.body.show(indentation + 1);
		say(")");
	}

	public void visit(VarExp e){
		indent(indentation);
		say("VarExp(\n");
		e.var.show(indentation + 1);
		say(")");
	}


	public void visit(TypeDec d){
		indent(indentation);
		say("TypeDec(\n");
		indent(indentation+1);
		say(d.name.toString());
		say(",\n");
		d.ty.show(indentation + 1);
		say(")");
	}
}



