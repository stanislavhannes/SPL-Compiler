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

	static private String inFileName = null;
	static private String outFileName = null;
	static private boolean optionTokens = false;
	static private boolean optionAbsyn = false;
	static private boolean optionTables = false;
	static private boolean optionVars = false;

	private static void errmsg(String msg){
		System.err.println(msg);
	}

	private static void help() {
		/* show some help how to use the program */
		errmsg("Usage: spl [options] <input file> <output file>");
		errmsg("Options:");
		errmsg("  --tokens         show stream of tokens");
		errmsg("  --absyn          show abstract syntax");
		errmsg("  --tables         show symbol tables");
		errmsg("  --vars           show variable allocation");
		errmsg("  --help           show this help");
	}

	private static void checkArguments(String[] args) {
		for (String arg: args) {
			if (arg.charAt(0) == '-') {
				/* option */
				if (arg.equals("--tokens"))
					optionTokens = true;
				else if (arg.equals("--absyn"))
					optionAbsyn = true;
				else if (arg.equals("--tables"))
					optionTables = true;
				else if (arg.equals("--vars"))
					optionVars = true;
				else if (arg.equals("--help")) {
					help();
					System.exit(0);
				} 
				else {
					errmsg("**** Error: unrecognized option '" + arg + "'");
					errmsg("try 'spl --help'");
					System.exit(1);
				}
			} 
			else {
				/* filename */
				if (outFileName != null) {
					errmsg("**** Error: more than two file names not allowed");
					System.exit(1);
				}
				if (inFileName != null)
					outFileName = arg;
				else
					inFileName = arg;
			}
		}
		
		if (inFileName == null) {
			errmsg("**** Error: no input file");
			System.exit(1);
		}
		if (outFileName == null) {
			errmsg("**** Error: no output file");
			System.exit(1);
		}
	}

	public static void main(String[] args) {

		checkArguments(args);

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

			DecList program = (DecList) new Parser(scanner).parse().value;

			if (optionAbsyn) {
				program.show(0);
				System.out.println();
				System.exit(0);
			}

			Table globalTable = new SemanticChecker().check(program, optionTables);
			new VarAllocator(globalTable, optionVars).allocVars(program);
			
			try {
				FileWriter outFile = new FileWriter(outFileName);
				new Codegenerator(outFile).genCode(program, globalTable);
				outFile.close();
			} catch (FileNotFoundException e) {
				errmsg("**** Error: cannot open output file '" +
						outFileName + "'");
				System.exit(1);
			} catch (IOException e) {
				errmsg("**** Error: IO error on output file '" +
						outFileName + "'");
				System.exit(1);
			}
		} catch (FileNotFoundException e) {
			errmsg("**** Error: cannot open input file '" +
					inFileName + "'");
			System.exit(1);
		} catch (IOException e) {
			errmsg("**** Error: IO error on input file '" +
					inFileName + "'");
			System.exit(1);
		} catch (Exception e) {
			e.printStackTrace();
			errmsg("**** Error: " + e.getMessage());
			System.exit(1);
		}
	}
}
