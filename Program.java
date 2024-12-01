import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Program
{
    public static void main(String[] args)
    {        
        if(args.length < 2)
        {
            System.out.println("Uso lexer: <archivo_entrada> <archivo_salida>");
            return;
        }
       
        String inputFile = args[0];
        String outputFile = args[1];
        
        try(BufferedReader reader = new BufferedReader(new FileReader(inputFile)); BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile));)
        {
            Lexer lexer = new Lexer(reader, writer);
            
            while(true)
            {
                lexer.yylex();
                if(lexer.isEOF()) break;
            }
                
            ArrayList<String> errors = lexer.getErrors();
            int totalErrors = errors.size();
             
            if(errors.size() >= 1)
            {
                writer.write("\nLista de errores:\n");
                for(int i = 0; i < totalErrors; i++)
                {
                   writer.write(errors.get(i));
                }
            }
            
            System.out.println("Análisis completado. Tokens guardados en "+outputFile);
        }
        catch(IOException e)
        {
            e.printStackTrace();
        }   
    }
}