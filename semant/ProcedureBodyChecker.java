package semant;

import table.*;
import types.*;
import absyn.*;

import java.util.Iterator;

class ProcedureBodyChecker {

	void check(Absyn program, Table globalTable) {
        program.accept(new CheckVisitor(globalTable));
	}

	private class CheckVisitor extends DoNothingVisitor {
		private Table localTable;
		private Table globalTable;
		private Type type;


		public CheckVisitor(Table globalTable) {
			this.globalTable = globalTable;
		}

		@Override
		public void visit(DecList dl) {
            for (Absyn aDl : dl) aDl.accept(this);
		}

		@Override
		public void visit(ProcDec pd) {
			Entry entry = globalTable.lookup(pd.name);
            Table temp;

			SemanticChecker.checkClass(entry,ProcEntry.class,"locale table from '" + pd.name + "' has wrong type");

            temp = localTable;
            localTable = new Table(((ProcEntry) entry).localTable);
            pd.body.accept(this);
            localTable = temp;

		}

		@Override
		public void visit(StmList sl) {
            for (Absyn aSl : sl) aSl.accept(this);
        }

		@Override
		public void visit(AssignStm as) {
			Type lhs,rhs;

			as.var.accept(this);
			lhs = this.type;
			as.exp.accept(this);
			rhs = this.type;

			if (lhs != rhs) {
				throw new RuntimeException(
						"assignment has different types in line "
								+ as.row
				);
			} else if (lhs != SemanticChecker.intType) {
				throw new RuntimeException(
						"assignment requires integer variable in line "
								+ as.row
				);
			}
		}

		@Override
		public void visit(SimpleVar sv) {
			Entry entry = localTable.lookup(sv.name);

			if (entry == null) {
                throw new RuntimeException(
                        "undefined variable '" + sv.name.toString()
                                + "' in line " + sv.row
                );
            }
            SemanticChecker.checkClass(entry,VarEntry.class,
                    "'" + sv.name.toString() + "' is not a variable", sv.row);

			type = ((VarEntry) entry).type;
			sv.dataType = this.type;
		}

		@Override
		public void visit(IntExp e) {
			type = SemanticChecker.intType;
		}

		@Override
		public void visit(ArrayVar av){
			av.index.accept(this);

			if (type != SemanticChecker.intType) {
				throw new RuntimeException(
						"illegal indexing with a non-integer in line "
								+ av.row
				);
			}

			av.var.accept(this);
			av.dataType = type;
			SemanticChecker.checkClass(type, ArrayType.class,"illegal indexing a non-array",av.row);
			type = ((ArrayType) type).baseType;
			av.dataType = type;
		}

		@Override
		public void visit(CompStm node) {
			node.stms.accept(this);
		}

		@Override
		public void visit(CallStm cs) {
			Entry entry = localTable.lookup(cs.name);
			int i = 0;

			if (entry == null)
				throw new RuntimeException(
						"undefined procedure '"
								+ cs.name.toString()
								+ "' in line " + cs.row
				);
			SemanticChecker.checkClass(entry, ProcEntry.class,
					"call of non-procedure '"
							+ cs.name.toString() + "'", cs.row);

            ListNodeIterator ArgsIt = cs.args.iterator();
            Iterator<ParamType> ParamsIt = ((ProcEntry) entry).paramTypes.iterator();
            while(ArgsIt.hasNext() && ParamsIt.hasNext()){
                i++;
                Absyn a = ArgsIt.next();
                ParamType p = ParamsIt.next();
                if(p.isRef && !(a instanceof VarExp)){
                    throw new RuntimeException("procedure '"
                            + cs.name + "' argument " + i
                            + " must be a variable in line " + cs.row
                    );
                } else if(a instanceof VarExp) {
                    a.accept(this);
                    if(p.type != type) {
                        throw new RuntimeException("procedure '"
                                + cs.name + "' argument '"
                                + ((SimpleVar)((VarExp) a).var).name
                                + "' type mismatch in line " + cs.row
                        );
                    }
                }
            }
            if(ArgsIt.hasNext()){ /*called with to much*/
                throw new RuntimeException("procedure '" + cs.name +
                        "' called with too many arguments in line "
                        + cs.row
                );
            } else if(ParamsIt.hasNext()) { /*called with to few*/
                throw new RuntimeException("procedure '" + cs.name
                        + "' called with too few arguments in line "
                        + cs.row
                );
            }
		}

        @Override
        public void visit(ExpList el) {
            for (Absyn anEl : el) {
                anEl.accept(this);
            }
        }

        @Override
        public void visit(VarExp ve) {
            ve.var.accept(this);
            ve.dataType = ve.var.dataType;
        }

        @Override
        public void visit(OpExp oe) {
            Type leftType, rightType;
            oe.left.accept(this);
            leftType = this.type;
            oe.right.accept(this);
            rightType = this.type;

            if ( leftType != rightType ) {
                throw new RuntimeException(
                        "expression combines different types in line "
                                + oe.row
                );
            }

            switch (oe.op) {
                case OpExp.EQU:    // case fall-through, following cases same type
                case OpExp.NEQ:
                case OpExp.LST:
                case OpExp.LSE:
                case OpExp.GRT:
                case OpExp.GRE:
                    if (leftType != SemanticChecker.intType) {
                        throw new RuntimeException(
                                "comparison requires integer operands in line "
                                        + oe.row
                        );
                    }
                    type = SemanticChecker.boolType;
                    break;
                case OpExp.ADD:    // case fall-through, following cases same type
                case OpExp.SUB:
                case OpExp.MUL:
                case OpExp.DIV:
                    if (leftType != SemanticChecker.intType) {
                        throw new RuntimeException(
                                "arithmetic operation requires integer operands in line "
                                        + oe.row
                        );
                    }
                    type = SemanticChecker.intType;
                    break;
                default:
                    throw new RuntimeException(
                            "undefined operation expression in line  "
                                    + oe.row
                    );
            }
        }

        @Override
        public void visit(IfStm is) {
            is.test.accept(this);
            if (type != SemanticChecker.boolType) {
                throw new RuntimeException(
                        "'if' test expression must be of type boolean in line "
                                + is.row
                );
            }
            type = null;
            is.thenPart.accept(this);
            if(is.elsePart != null)
                is.elsePart.accept(this);
        }

        @Override
        public void visit(WhileStm ws) {
            ws.test.accept(this);
            if(type != SemanticChecker.boolType) {
                throw new RuntimeException(
                        "'while' test expression must be of type boolean in line "
                                + ws.row
                );
            }
            type = null;
            ws.body.accept(this);
        }

    }
}
