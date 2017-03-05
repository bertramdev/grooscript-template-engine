/* JFlex example: partial Java language lexer specification */
package com.bertramlabs.plugins.grooscript.template;
import com.bertramlabs.plugins.grooscript.template.symbols.*;
import java.util.ArrayList;
import java.io.*;

/**
 * This class is a simple example lexer.
 */
%%

%class StringTemplateLexer
%unicode
%line
%column
%char
%type Symbol

%yylexthrow{
StringTemplateException
%yylexthrow}

%{
  StringBuffer string = new StringBuffer();
  int curleyBraceCounter = 0;
  ArrayList<Symbol> elementStack = new ArrayList<Symbol>();

  private Symbol addAttributeSymbol(String value) {
    GenericSymbol attr = new GenericSymbol(value, yyline,yycolumn,yychar);
    elementStack.add(attr);
    return attr;
  }


%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]
WhiteSpaceOpt = [ \t\f]+?

AnyChar = [^]

/*Attributes*/
DoubleStringCharacter = [^\"]
SingleStringCharacter = [^\']


GrooExpression = {OpenExpression} {AssignmentExpression}* {CloseExpression}
/* Children */
OpenExpession = [^\\] "{{"
CloseExpression = "}}"
AssignmentExpression = [^]

%state STRINGDOUBLE
%state STRINGSINGLE
%state INEXPRESSION

%%

/* keywords */
<YYINITIAL> {
  /* identifiers */ 
  {GrooExpression}               {yybegin(INEXPRESSION); yypushback(yylength()-2);}
  
  
  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }
  {AnyChar}                      { /* ignore */ }
}

<STRINGDOUBLE, STRINGSINGLE> {
  \\t                            { string.append('\t'); }
  \\n                            { string.append('\n'); }
  \\r                            { string.append('\r'); }
  \\                             { string.append('\\'); }
}
<STRINGDOUBLE> {
  \"                             { yybegin(INEXPRESSION); string.append("\""); }  
  \\\"                           { string.append('\"'); }
  [^\n\r\"\\]+                   { string.append( yytext() ); }
}

<STRINGSINGLE> {
  [^\n\r\'\\]+                   { string.append( yytext() ); }
  \'                             { yybegin(INEXPRESSION); string.append("'"); }  
  \\'                            { string.append('\''); }
}



<INEXPRESSION> {
  {CloseExpression}             {if(curleyBraceCounter > 0) { Symbol sym = addAttributeSymbol(string.toString()); yybegin(YYINITIAL); string.setLength(0); return sym;} }
  \}                            { string.append(yytext()); curleyBraceCounter--; }
  \{                            { string.append(yytext()); curleyBraceCounter++;}
  /* literals */
  \"                             { string.append("\""); yybegin(STRINGDOUBLE); }
  \'                             { string.append("'"); yybegin(STRINGSINGLE); }
  [^\{\}]                        { string.append( yytext() ); }
}


/* error fallback */
    [^]                              { throw new StringTemplateException("Illegal character <"+
                                                        yytext()+"> found on line: " + (yyline+1) + " col: " + (yycolumn+1) ); }
