/*
 * scanner.jflex -- SPL scanner specification
 */


package parse;
import java_cup.runtime.*;


%%


%class Scanner
%public
%line
%column
%cup

%{

	

  private Symbol symbol(int type) {
    return new Symbol(type, yyline + 1, yycolumn + 1);
  }

  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline + 1, yycolumn + 1, value);
  }

  public void showToken(Symbol token) {
    String s;
    switch (token.sym) {
    
      case sym.IF:
      	s="IF";
      	break;
      	
      case sym.ELSE:
      	s = "ELSE";
      	break;
      	
      case sym.WHILE:
      	s = "WHILE";
      	break;
      	
      case sym.PROC:
      	s = "PROC";
      	break;
      	
      case sym.VAR:
      	s = "VAR";
      	break;
      	
      case sym.ARRAY:
      	s = "ARRAY";
      	break;
      	
      case sym.TYPE:
      	s = "TYPE";
      	break;
      	
      case sym.OF:
      	s = "OF";
      	break;
      	
      case sym.REF:
      	s = "REF";
      	break;
      	
      case sym.LCURL:
      	s = "LCURL";
      	break;
      	
      case sym.RCURL:
      	s = "RCURL";
      	break;
      	
      case sym.LBRACK:
      	s = "LBRACK";
      	break;
      	
      case sym.RBRACK:
      	s = "RBRACK";
      	break;
      	
      case sym.LPAREN:
      	s = "LPAREN";
      	break;
      	
      case sym.RPAREN:
      	s = "RPAREN";
      	break;
      	
      	
       case sym.PLUS:
      	s = "PLUS";
      	break;
      	
      case sym.MINUS:
      	s = "MINUS";
      	break;
      	
      case sym.SLASH:
      	s = "SLASH";
      	break;
      	
      case sym.STAR:
      	s = "STAR";
      	break;	
      	
       case sym.SEMIC:
      	s = "SEMIC";
      	break;
      	
      case sym.COLON:
      	s = "COLON";
      	break;
      	
      case sym.COMMA:
      	s = "COMMA";
      	break;
      	
      case sym.ASGN:
      	s = "ASGN";
      	break;	
      	
       case sym.NE:
      	s = "NE";
      	break;
      	
      case sym.EQ:
      	s = "EQ";
      	break;
      	
      case sym.LT:
      	s = "LT";
      	break;
      	
      case sym.LE:
      	s = "LE";
      	break;	
      	
      case sym.GT:
      	s = "GT";
      	break;
      	
      case sym.GE:
      	s = "GE";
      	break;	
      	
      case sym.IDENT:
      	s = "IDENT";
      	break;
      	
      case sym.INTLIT:
      	s = "INTLIT";
      	break;						
      	
      case sym.EOF:
        s = "-- EOF --";
        break;
        
      default:
        /* this should never happen */
        throw new RuntimeException(
          "unknown token " + token.sym + " in showToken"
        );
    }
    
    if (token.sym != sym.EOF){
    	s = "TOKEN = " + s +
     	" in line " + token.left;
     }
    else s = "TOKEN = " + s; 
    
    if (token.value != null){
  		s = s + ", value = " +
  		"\"" + token.value.toString() + "\"";
    }
    
    System.out.println(s);
  }

%}


%%
\/\/.*						{/*comment*/}
[\n\ \t\r]+ 					{/*whitespace*/}

"if"						{return symbol(sym.IF);}
"else"						{return symbol(sym.ELSE);}
"while"						{return symbol(sym.WHILE);}
"proc"						{return symbol(sym.PROC);}
"var"						{return symbol(sym.VAR);}
"array"						{return symbol(sym.ARRAY);}
"type"						{return symbol(sym.TYPE);}
"of"						{return symbol(sym.OF);}
"ref"						{return symbol(sym.REF);}	

"{" 						{return symbol(sym.LCURL);}
"}"						{return symbol(sym.RCURL);}
"["						{return symbol(sym.LBRACK);}
"]"						{return symbol(sym.RBRACK);}
"("						{return symbol(sym.LPAREN);}
")"						{return symbol(sym.RPAREN);}

"+"						{return symbol(sym.PLUS);}
"-"						{return symbol(sym.MINUS);}
"/"						{return symbol(sym.SLASH);}
"*"						{return symbol(sym.STAR);}

";"						{return symbol(sym.SEMIC);}
":"						{return symbol(sym.COLON);}
","						{return symbol(sym.COMMA);}
":="						{return symbol(sym.ASGN);}

"#"						{return symbol(sym.NE);}
"="						{return symbol(sym.EQ);}
"<"						{return symbol(sym.LT);}
"<="						{return symbol(sym.LE);}
">"						{return symbol(sym.GT);}
">="						{return symbol(sym.GE);}

[_a-zA-Z][a-zA-Z0-9_]*				{return symbol(sym.IDENT, yytext()); }
[0-9]+						{return symbol(sym.INTLIT, Integer.valueOf(yytext())); }
0x[0-9a-fA-F]+ 					{return symbol(sym.INTLIT, Integer.valueOf(yytext().substring(2),16)); }  //Hexdezimal
'.'						{return symbol(sym.INTLIT, new Integer(yytext().charAt(1)));}

'\\n'						{return symbol(sym.INTLIT, new Integer('\n'));} 

<<EOF>>						{return symbol(sym.EOF);}


.		{
		  throw new RuntimeException(
		    "illegal character 0x" +
		    Integer.toString((int) yytext().charAt(0), 16) +
		    " in line " + (yyline + 1) +
		    ", column " + (yycolumn + 1)
		  );
		}
		

