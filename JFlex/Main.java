//PREDESCU Maria 334CB

import java.io.IOException;
import java.util.Scanner;
import java.io.*;

public class Main {

	public static String addNewline(String print) {
		Scanner scanner = new Scanner(print);
		String build = "";
		while (scanner.hasNextLine()) {
			String line = scanner.nextLine();
			build += "	" + line + "\n";
		}
		scanner.close();
		return build;
	}
	
	public static void main (String[] args) throws IOException {
		ExpressionFlexLexer l = new ExpressionFlexLexer(new FileReader("input"));
		PrintWriter pw = new PrintWriter("arbore");
		
		l.yylex();

		pw.print(((Expression) l.stack.pop()).show());
		pw.close();
	}
}
