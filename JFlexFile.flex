import java.util.ArrayList;
import java.io.Reader;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.BufferedWriter;
%%
%standalone
%unicode
%class Lexer
%public
%{
    private int line = 1;
    private int tokenCount;
    private ArrayList<String> errors; 
    private BufferedWriter writer;
    public boolean isEOF(){ return zzAtEOF; }
    public ArrayList<String> getErrors() { return errors; }
    public Lexer(Reader in, BufferedWriter writer)
    {
        this.zzReader = in;
        this.writer = writer;
        this.errors = new ArrayList<String>();
    }
    private void writeToken(String lexema, String token)
    {
        try{ tokenCount++; this.writer.write(""+tokenCount+": ("+token+", \""+lexema+"\")\n"); }
        catch(IOException e){ e.printStackTrace(); }
    }    
%}
DATA_TYPE           = (integer|decimal|boolean|varchar|character|generic)
KEYWORD             = (if|else|elif|while|for|do|return|define|start|end|as|is|to|switch|case|default|break|print)
IDENTIFIER          = @[a-zA-Z][a-zA-Z0-9]*
INVALID_IDENTIFIER  = @[^a-zA-Z\s]+[a-zA-Z0-9]*
QUOTATION_MARK      = \"
INLINE_TEXT         = \"[^\"]*\"
NUMBER              = [0-9]+(\.[0-9]+)?
LEFT_PARENTHESIS    = "(" 
RIGHT_PARENTHESIS   = ")" 
COMMA               = ","
DELIMITER           = ";"
TWO_POINTS          = ":"
OPERATOR            = [-+*/%]
LOGICAL_OPERATOR    = (and|or|not|&&|\!|\|\|)
ASSIGN              = "="
RELATIONAL_OPERATOR = (greatherthan|lessthan|equalto|different|>|<|<=|>=|<>|==|\!\=)
POT                 = "^"
UNKNOWN             = .
SPACE               = " "+
LINE_BREAK          = "\n" 
%%
<YYINITIAL>{ 
    {LINE_BREAK}           {line++;}
    {SPACE}                {}
    {INVALID_IDENTIFIER}   { this.errors.add("Linea "+line+", Identificador inválido '"+yytext()+"' detectado.\n");}
    {IDENTIFIER}           { writeToken(yytext(), "IDENTIFIER"); }
    {TWO_POINTS}           { writeToken(yytext(), "TWO_POINTS"); }
    {COMMA}                { writeToken(yytext(), "COMMA"); }
    {DELIMITER}            { writeToken(yytext(), "DELIMITER"); }
    {QUOTATION_MARK}       { writeToken(yytext(), "QUOTATION_MARK"); }
    {LEFT_PARENTHESIS}     { writeToken(yytext(), "LEFT_PARENTHESIS"); }
    {RIGHT_PARENTHESIS}    { writeToken(yytext(), "RIGHT_PARENTHESIS"); }
    {ASSIGN}               { writeToken(yytext(), "ASSIGN"); }
    {DATA_TYPE}            { writeToken(yytext(), "DATA_TYPE"); }
    {KEYWORD}              { writeToken(yytext(), "KEYWORD"); }
    {NUMBER}               { writeToken(yytext(), "NUMBER"); }
    {OPERATOR}             { writeToken(yytext(), "OPERATOR"); }
    {POT}                  { writeToken(yytext(), "POT"); }
    {LOGICAL_OPERATOR}     { writeToken(yytext(), "LOGICAL_OPERATOR"); }
    {RELATIONAL_OPERATOR}  { writeToken(yytext(), "RELATIONAL_OPERATOR");}
    {INLINE_TEXT}          { writeToken(yytext(), "INLINE_TEXT");}
    {UNKNOWN}              { this.errors.add("Linea "+line+", Simbolo desconocido '"+yytext()+"' detectado.\n"); }   
}