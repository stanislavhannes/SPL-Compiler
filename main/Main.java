/*
 * Main.java -- SPL compiler
 */


package main;

import java.io.*;
import java_cup.runtime.Symbol;
import parse.*;
import absyn.*;
import table.*;
import semant.*;
import varalloc.*;
import codegen.*;


class Main {

  static void help() {
    /* show some help how to use the program */
    System.out.print("Usage: spl [options] <input file> <output file>\n");
    System.out.print("Options:\n");
    System.out.print("  --tokens         show stream of tokens\n");
    System.out.print("  --absyn          show abstract syntax\n");
    System.out.print("  --tables         show symbol tables\n");
    System.out.print("  --vars           show variable allocation\n");
    System.out.print("  --help           show this help\n");
  }

  public static void main(String[] args) {
    String inFileName = null;
    String outFileName = null;
    boolean optionTokens = false;
    boolean optionAbsyn = false;
    boolean optionTables = false;
    boolean optionVars = false;
    for (int i = 0; i < args.length; i++) {
      if (args[i].charAt(0) == '-') {
        /* option */
        if (args[i].equals("--tokens")) {
          optionTokens = true;
        } else
        if (args[i].equals("--absyn")) {
          optionAbsyn = true;
        } else
        if (args[i].equals("--tables")) {
          optionTables = true;
        } else
        if (args[i].equals("--vars")) {
          optionVars = true;
        } else
        if (args[i].equals("--help")) {
          help();
          System.exit(0);
        } else {
          System.out.println(
            "**** Error: unrecognized option '" +
            args[i] + "'; try 'spl --help'"
          );
          System.exit(1);
        }
      } else {
        /* file */
        if (outFileName != null) {
          System.out.println(
            "**** Error: more than two file names not allowed"
          );
          System.exit(1);
        }
        if (inFileName != null) {
          outFileName = args[i];
        } else {
          inFileName = args[i];
        }
      }
    }
    if (inFileName == null) {
      System.out.println("**** Error: no input file");
      System.exit(1);
    }
    if (outFileName == null) {
      System.out.println("**** Error: no output file");
      System.exit(1);
    }
    try {
      FileInputStream source = new FileInputStream(inFileName);
      Scanner scanner = new Scanner(source);
      if (optionTokens) {
        Symbol token;
        do {
          token = scanner.next_token();
          scanner.showToken(token);
        } while (token.sym != sym.EOF);
        System.exit(0);
      }
      Parser parser = new Parser(scanner);
      DecList program = (DecList) parser.parse().value;
      if (optionAbsyn) {
        program.show(0);
        System.out.println();
        System.exit(0);
      }
      Semant semant = new Semant(optionTables);
      Table globalTable = semant.check(program);
      Varalloc varalloc = new Varalloc(globalTable, optionVars);
      varalloc.allocVars(program);
      try {
        FileWriter outFile = new FileWriter(outFileName);
        Codegen codegen = new Codegen(globalTable, outFile);
        codegen.genCode(program);
        outFile.close();
      } catch (FileNotFoundException e) {
        System.out.println("**** Error: cannot open output file '" +
                           outFileName + "'");
        System.exit(1);
      } catch (IOException e) {
        System.out.println("**** Error: IO error on output file '" +
                           outFileName + "'");
        System.exit(1);
      }
    } catch (FileNotFoundException e) {
      System.out.println("**** Error: cannot open input file '" +
                         inFileName + "'");
      System.exit(1);
    } catch (IOException e) {
      System.out.println("**** Error: IO error on input file '" +
                         inFileName + "'");
      System.exit(1);
    } catch (Exception e) {
      System.out.println("**** Error: " + e.getMessage());
      System.exit(1);
    }
  }

}
