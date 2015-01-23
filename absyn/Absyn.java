/*
 * Absyn.java -- abstract syntax for SPL
 */


package absyn;

public abstract class Absyn {

    public int row;
    public int col;

    public void indent(int n) {
        for (int i = 0; i < n; i++) {
            System.out.print("  ");
        }
    }

    public void say(String s) {
        System.out.print(s);
    }

    public void sayInt(int i) {
        System.out.print(i);
    }

    public void sayBoolean(boolean b) {
        if (b) {
            System.out.print("true");
        } else {
            System.out.print("false");
        }
    }

    public abstract void show(int n);

}
