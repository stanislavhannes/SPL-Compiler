/*
 * Codegen.java -- ECO32 code generator
 */


package codegen;

import java.io.*;
import absyn.*;
import table.*;
import types.*;

public class Codegen {

  private Table globalTable;
  private PrintWriter outWriter;

  public Codegen(Table t, Writer w) {
    globalTable = t;
    outWriter = new PrintWriter(w);
  }

  private void assemblerProlog() {
    outWriter.format("\t.import\tprinti\n");
    outWriter.format("\t.import\tprintc\n");
    outWriter.format("\t.import\treadi\n");
    outWriter.format("\t.import\treadc\n");
    outWriter.format("\t.import\texit\n");
    outWriter.format("\t.import\ttime\n");
    outWriter.format("\t.import\tclearAll\n");
    outWriter.format("\t.import\tsetPixel\n");
    outWriter.format("\t.import\tdrawLine\n");
    outWriter.format("\t.import\tdrawCircle\n");
    outWriter.format("\t.import\t_indexError\n");
    outWriter.format("\n");
    outWriter.format("\t.code\n");
    outWriter.format("\t.align\t4\n");
  }

  public void genCode(Absyn program) {
    assemblerProlog();
  }

}
