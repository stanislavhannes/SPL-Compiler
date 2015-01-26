/*
 * OpExp.java -- abstract syntax for operator expression
 */


package absyn;

import visitor.Visitor;
import visitor.VisitorElement;

public class OpExp extends Exp {

    public final static int EQU = 0;
    public final static int NEQ = 1;
    public final static int LST = 2;
    public final static int LSE = 3;
    public final static int GRT = 4;
    public final static int GRE = 5;
    public final static int ADD = 6;
    public final static int SUB = 7;
    public final static int MUL = 8;
    public final static int DIV = 9;

    public int op;
    public Exp left;
    public Exp right;

    public OpExp(int r, int c, int o, Exp e1, Exp e2) {
        row = r;
        col = c;
        op = o;
        left = e1;
        right = e2;
    }

    public void show(int n) {
        indent(n);
        say("OpExp(\n");
        indent(n + 1);
        switch (op) {
            case EQU:
                say("EQU");
                break;
            case NEQ:
                say("NEQ");
                break;
            case LST:
                say("LST");
                break;
            case LSE:
                say("LSE");
                break;
            case GRT:
                say("GRT");
                break;
            case GRE:
                say("GRE");
                break;
            case ADD:
                say("ADD");
                break;
            case SUB:
                say("SUB");
                break;
            case MUL:
                say("MUL");
                break;
            case DIV:
                say("DIV");
                break;
            default:
                throw new RuntimeException(
                        "unknown operator " + op + " in OpExp.show"
                );
        }
        say(",\n");
        left.show(n + 1);
        say(",\n");
        right.show(n + 1);
        say(")");
    }


    public void accept(Visitor v) {
        v.visit(this);
    }
}
