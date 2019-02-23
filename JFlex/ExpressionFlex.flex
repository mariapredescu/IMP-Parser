//PREDESCU Maria 334CB

import java.util.*;
import java.util.Stack;
import java.util.ArrayList;

%%
 
%class ExpressionFlexLexer
%line
%standalone

%{
    //Stiva in care sunt retinute elementele relevante pentru parsarea programului
    Stack<Expression> stack = new Stack<>();

    //ArrayList in care este stocata lista de variabile de la inceputul ficarui program
    ArrayList<Expression> varList = new ArrayList<>();


    //Functie folosita pentru a retine lista de variabile de la inceputul programului
    void varList() {

        while(true) {
            Expression e = stack.peek();
            if(e instanceof Symbol) {
                Symbol s = (Symbol) e;
                if(s.symbol().equals("int")) {
                    break;
                }
            }
            varList.add(stack.pop());
        }
    }


    //Functie ce se apeleaza cand se ajunge la finalul fisierului pentru a adauga nodul
    //final, MainNode, ce primeste ca parametru expresia ce reprezinta arborele programului
    Expression build_tree() {

        Expression tree = null;

        while(!stack.isEmpty()) {
            Expression e2 = stack.peek();
            stack.pop();

            Expression e1 = stack.peek();
            stack.pop();
            if(e1 instanceof Symbol) {
                Symbol s = (Symbol) e1;
                if(s.symbol().equals("int")) {
                    tree = new MainNode(e2);
                }
            } else {
                stack.push(new SequenceNode(e1, e2));
            }
        }
        return tree;
    }


    //Functie ce parseaza o constructie de tip assignment
    Expression solve_assignment() {

        ArrayList<Expression> expr = new ArrayList<>();
        while(true) {
            Expression e = stack.peek();
            if(e instanceof Symbol) {
                Symbol s = (Symbol) e;
                if(s.symbol().equals("=")) {
                    break;
                }
            }
            expr.add(stack.pop());
        }
        Collections.reverse(expr);
        stack.pop();    //extragem "=" de pe stiva
        Expression var = stack.peek();  
        stack.pop();    //extragem variabila de pe stiva

        int i;
        int preced = 0;
        Stack<Integer> op = new Stack<>();
        Stack<Expression> operand = new Stack<>();

        for(i = 0; i < expr.size(); i++) {
            if(expr.get(i) instanceof Symbol) {
                Symbol s = (Symbol) expr.get(i);
                if(s.symbol().equals("+")) {
                    preced = 1;
                } else if(s.symbol().equals("/")) {
                    preced = 2;
                }
                while(!op.isEmpty() && op.peek() >= preced) {
                    int operation = op.peek();
                    op.pop();   //scoatem operatorul de pe stiva
                    Expression op2 = operand.pop(); //scoatem operandul 2 de pe stiva
                    Expression op1 = operand.pop(); //scoatem operandul 1 de pe stiva
                    if(operation == 1) {
                        Expression result = new PlusNode(op1, op2);
                        operand.push(result);
                    } else if(operation == 2) {
                        Expression result = new DivNode(op1, op2);
                        operand.push(result);
                    }
                }
                op.push(preced);
            } else {
                operand.push(expr.get(i));
            }
        }

        while(!op.isEmpty()) {
            int operation = op.peek();
            op.pop();
            Expression op2 = operand.pop();
            Expression op1 = operand.pop();
            if(operation == 1) {
                Expression result = new PlusNode(op1, op2);
                operand.push(result);
            } else if(operation == 2) {
                Expression result = new DivNode(op1, op2);
                operand.push(result);
            }
        }
        return new AssignmentNode((VarNode) var, operand.peek());
    }


    //Functie ce parseaza o constructie de tip paranteza
    Expression solve_bracket() {
        ArrayList<Expression> expr = new ArrayList<>();
        while(true) {
            Expression e = stack.peek();
            if(e instanceof Symbol) {
                Symbol s = (Symbol) e;
                if(s.symbol().equals("(")) {
                    break;
                }   
            }
            expr.add(stack.pop());
        }    
        stack.pop();    //extragem "(" de pe stiva
        Collections.reverse(expr);

        int i;
        int preced = 0;
        Stack<Integer> op = new Stack<>();
        Stack<Expression> operand = new Stack<>();

        for(i = 0; i < expr.size(); i++) {
            if(expr.get(i) instanceof Symbol) {
                Symbol s = (Symbol) expr.get(i);
                if(s.symbol().equals("&&")) {
                    preced = 1;
                } else if(s.symbol().equals("!")) {
                    preced = 2;
                } else if(s.symbol().equals(">")) {
                    preced = 3;
                } else if(s.symbol().equals("+")) {
                    preced = 4;
                } else if(s.symbol().equals("/")) {
                    preced = 5;
                }
                while(!op.isEmpty() && op.peek() >= preced) {
                    int operation = op.peek();
                    op.pop();   //scoatem operatorul de pe stiva
                    if(operation == 1) {
                        Expression op2 = operand.pop(); //scoatem operandul 2 de pe stiva
                        Expression op1 = operand.pop(); //scoatem operandul 1 de pe stiva
                        Expression result = new AndNode(op1, op2);
                        operand.push(result);
                    } else if(operation == 2) {
                        Expression op2 = operand.pop(); //scoatem operandul 2 de pe stiva
                        Expression result = new NotNode(op2);
                        operand.push(result);
                    } else if(operation == 3) {
                        Expression op2 = operand.pop(); //scoatem operandul 2 de pe stiva
                        Expression op1 = operand.pop(); //scoatem operandul 1 de pe stiva
                        Expression result = new GreaterNode(op1, op2);
                        operand.push(result);
                    } else if(operation == 4) {
                        Expression op2 = operand.pop(); //scoatem operandul 2 de pe stiva
                        Expression op1 = operand.pop(); //scoatem operandul 1 de pe stiva
                        Expression result = new PlusNode(op1, op2);
                        operand.push(result);
                    } else if(operation == 5) {
                        Expression op2 = operand.pop(); //scoatem operandul 2 de pe stiva
                        Expression op1 = operand.pop(); //scoatem operandul 1 de pe stiva
                        Expression result = new DivNode(op1, op2);
                        operand.push(result);
                    }
                }
                op.push(preced);
            } else {
                operand.push(expr.get(i));
            }
        }
        while(!op.isEmpty()) {

            int operation = op.peek();
            op.pop();   //scoatem operatorul de pe stiva

            if(operation == 1) {
                Expression op2 = operand.pop(); //scoatem operandul 2 de pe stiva
                Expression op1 = operand.pop(); //scoatem operandul 1 de pe stiva
                Expression result = new AndNode(op1, op2);
                operand.push(result);
            } else if(operation == 2) {
                Expression op2 = operand.pop(); //scoatem operandul 2 de pe stiva
                Expression result = new NotNode(op2);
                operand.push(result);
            } else if(operation == 3) {
                Expression op2 = operand.pop(); //scoatem operandul 2 de pe stiva
                Expression op1 = operand.pop(); //scoatem operandul 1 de pe stiva
                Expression result = new GreaterNode(op1, op2);
                operand.push(result);
            } else if(operation == 4) {
                Expression op2 = operand.pop(); //scoatem operandul 2 de pe stiva
                Expression op1 = operand.pop(); //scoatem operandul 1 de pe stiva
                Expression result = new PlusNode(op1, op2);
                operand.push(result);
            } else if(operation == 5) {
                Expression op2 = operand.pop(); //scoatem operandul 2 de pe stiva
                Expression op1 = operand.pop(); //scoatem operandul 1 de pe stiva
                Expression result = new DivNode(op1, op2);
                operand.push(result);
            }
        }
        return new BracketNode(operand.peek());
    }


    //Functie ce parseaza o constructie de tip block
    Expression solve_block() {
        Expression block = null;
        Expression result = null;
        Stack<Expression> stmt = new Stack<>();
        Stack<Expression> stmtcopy = new Stack<>();
        while(true) {
            Expression e = stack.peek();
            if(e instanceof Symbol) {
                Symbol s = (Symbol) e;
                if(s.symbol().equals("{")) {
                    //stmt.push(e);
                    break;
                }
            }
            stmt.add(stack.pop());
        }
        stmt.add(new Symbol("{"));
        stack.pop();    //extragem "{" de pe stiva

        //inversez stiva cu ajutorul unei stive auxiliare
        while(!stmt.isEmpty()) {
            Expression e = stmt.peek();
            stmtcopy.push(e);
            stmt.pop();
        }

        while(!stmtcopy.isEmpty()) {
            Expression e2 = stmtcopy.peek();
            stmtcopy.pop();
            if(e2 instanceof Symbol) {
                Symbol s = (Symbol) e2;
                if(s.symbol().equals("{")) {
                    block = new BlockNode(null);
                }
            } else {
                Expression e1 = stmtcopy.peek();
                stmtcopy.pop();
                if(e1 instanceof Symbol) {
                    Symbol s = (Symbol) e1;
                    if(s.symbol().equals("{")){
                        block = new BlockNode(e2);
                    }
                } else {
                    stmtcopy.push(new SequenceNode(e1, e2));
                }
            }
        }

        Expression ex = stack.peek();
        if(ex instanceof BracketNode) {
            stack.pop();
            Expression expr = stack.peek();
            if(expr instanceof Symbol) {
                Symbol s = (Symbol) expr;
                if(s.symbol().equals("while")) {
                    stack.pop();    //extragem "while" de pe stiva
                    result = new WhileNode((BracketNode) ex, (BlockNode) block);
                } else {
                    stack.push(ex);
                    result = block;
                }
            }
        } else if(ex instanceof Symbol) {
            Symbol s = (Symbol) ex;
            if(s.symbol().equals("else")) {
                stack.pop();    //extragem "else" de pe stiva
                Expression b1 = stack.pop();    //extragem primul block al if-ului
                Expression br = stack.pop();    //extragem paranteza if-ului
                stack.pop();    //extragem "if" de pe stiva
                result = new IfNode((BracketNode) br, (BlockNode) b1, (BlockNode) block);
            }
        }

        return result;
    }

%}

intnode = [1-9][0-9]* | 0
boolnode = "true" | "false"
varlist = "int"
ifnode = "if"
elsenode = "else"
whilenode = "while"
varnode = ("a" | "b" | "c" | "d" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m" | "n" | 
        "o" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z")+
plusnode = "+"
divnode = "/"
bracketnode = "("
close_bracket = ")"
andnode = "&&"
greaternode = ">"
notnode = "!"
assignmentnode = "="
close_assignment = ";"
blocknode = "{"
close_block = "}"


%%   
{intnode} { stack.push(new IntNode(yytext())); }
{ifnode} { stack.push(new Symbol("if")); }
{whilenode} { stack.push(new Symbol("while")); }
{elsenode} { stack.push(new Symbol("else")); }
{varlist} { stack.push(new Symbol("int")); }
{varnode} { stack.push(new VarNode(yytext())); }
{boolnode} { stack.push(new BoolNode(yytext())); }
{plusnode} { stack.push(new Symbol("+")); }
{divnode} { stack.push(new Symbol("/")); }
{andnode} { stack.push(new Symbol("&&")); }
{greaternode} { stack.push(new Symbol(">")); }
{notnode} { stack.push(new Symbol("!")); }
{bracketnode} { stack.push(new Symbol("(")); }
{close_bracket} { 
    Expression e = solve_bracket(); //scot ce am pe stiva pana la "(" inclusiv si formez un nou element
    stack.push(e);  //pun elementul nou format inapoi pe stiva

}
{blocknode} { stack.push(new Symbol("{"));
    //System.out.println("open block");
}
{close_block} {
    //System.out.println("block");
    Expression e = solve_block();
    stack.push(e);
}
{assignmentnode} { stack.push(new Symbol("=")); }
{close_assignment} { 
    if(varList.isEmpty()) {
        varList();
    } else {
        Expression as = solve_assignment(); //scot ce am pe stiva pana la elementul din 
                                                //fata egalului
        stack.push(as); //pun elementul nou format la loc pe stiva
        //System.out.println("ass");
    }
}

<<EOF>> {

    Expression tree = build_tree();
    stack.push(tree);
    return 0;
 }
. {}


