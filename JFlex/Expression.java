//PREDESCU Maria 334CB

abstract interface Expression {
	String show();
	Expression interpret();
};

class MainNode implements Expression {
	Expression e;
	
	public MainNode(Expression e) {
		super();
		this.e = e;
	}
	
	@Override
	public String show() {
		String expr = "";
		expr += "<MainNode>\n";
		
		String print = "";
		print += e.show();
		
		expr += Main.addNewline(print);
		return expr;
	}

	@Override
	public Expression interpret() {
		return new MainNode(e.interpret());
	}
}

class SequenceNode implements Expression {
	Expression e1, e2;
	
	public SequenceNode(Expression e1, Expression e2) {
		super();
		this.e1 = e1;
		this.e2 = e2;
	}
	
	@Override
	public String show() {
		String expr = "";
		expr += "<SequenceNode>\n";
		
		String print = "";
		print += e1.show() + e2.show();
		
		expr += Main.addNewline(print);
		return expr;
	}

	@Override
	public Expression interpret() {
		return new SequenceNode(e1.interpret(), e2.interpret());
	}
}

class IntNode implements Expression {
	String number;
	
	public IntNode(String number) {
		super();
		this.number = number;
	}
	
	@Override
	public String show() {
		return "<IntNode> " + number + "\n";
	}

	@Override
	public Expression interpret() {
		return this;
	}	
}

class VarNode implements Expression {
	String var;
	
	public VarNode(String var) {
		super();
		this.var = var;
	}
	
	@Override
	public String show() {
		return "<VariableNode> " + var + "\n";
	}

	@Override
	public Expression interpret() {
		return null;
	}	
}

class BoolNode implements Expression {
	String bool;
	
	public BoolNode(String bool) {
		super();
		this.bool = bool;
	}
	
	@Override
	public String show() {
		return "<BoolNode> " + bool + "\n";
	}

	@Override
	public Expression interpret() {
		return this;
	}
	
}

class Symbol implements Expression {
	String symbol;

	public Symbol(String symbol) {
		super();
		this.symbol = symbol;
	}
	
	String symbol() {
		return symbol;
	}

	@Override
	public String show() {
		return null;
	}

	@Override
	public Expression interpret() {
		return null;
	}	
}

class PlusNode implements Expression {
	Expression t1, t2;
	
	public PlusNode(Expression t1, Expression t2) {
		super();
		this.t1 = t1;
		this.t2 = t2;
	}
	
	@Override
	public String show() {
		String expr = "";
		expr += "<PlusNode> +\n";
		
		String print = "";
		print += t1.show() + t2.show();
		
		expr += Main.addNewline(print);
		return expr;
		
	}

	@Override
	public Expression interpret() {
		return null;
	}
}

class DivNode implements Expression {
	Expression d1, d2;
	
	public DivNode(Expression d1, Expression d2) {
		super();
		this.d1 = d1;
		this.d2 = d2;
	}
	
	@Override
	public String show() {
		String expr = "";
		expr += "<DivNode> /\n";
		
		String print = "";
		print += d1.show() + d2.show();
		
		expr += Main.addNewline(print);
		return expr;
	}

	@Override
	public Expression interpret() {
		// TODO Auto-generated method stub
		return null;
	}
}

class AndNode implements Expression {
	Expression b1, b2;
	
	public AndNode(Expression b1, Expression b2) {
		super();
		this.b1 = b1;
		this.b2 = b2;
	}
	@Override
	public String show() {
		String expr = "";
		expr += "<AndNode> &&\n";
		
		String print = "";
		print += b1.show() + b2.show();
		
		expr += Main.addNewline(print);
		return expr;
	}

	@Override
	public Expression interpret() {
		// TODO Auto-generated method stub
		return null;
	}
	
}

class GreaterNode implements Expression {
	Expression e1, e2;
	
	public GreaterNode(Expression e1, Expression e2) {
		super();
		this.e1 = e1;
		this.e2 = e2;
	}
	
	@Override
	public String show() {
		String expr = "";
		expr += "<GreaterNode> >\n";
		
		String print = "";
		print += e1.show() + e2.show();
		
		expr += Main.addNewline(print);
		return expr;
	}

	@Override
	public Expression interpret() {
		// TODO Auto-generated method stub
		return null;
	}
}

class NotNode implements Expression {
	Expression e;
	
	public NotNode(Expression e) {
		super();
		this.e = e;
	}
	@Override
	public String show() {
		String expr = "";
		expr += "<NotNode> !\n";
		
		String print = "";
		print += e.show();
		
		expr += Main.addNewline(print);
		return expr;
	}

	@Override
	public Expression interpret() {
		// TODO Auto-generated method stub
		return null;
	}
}

class BracketNode implements Expression {
	Expression e;
	
	public BracketNode(Expression e) {
		super();
		this.e = e;
	}
	
	@Override
	public String show() {
		String expr = "";
		expr += "<BracketNode> ()\n";
		
		String print = "";
		print += e.show();
		
		expr += Main.addNewline(print);
		return expr;
	}

	@Override
	public Expression interpret() {
		return null;
	}
}

class BlockNode implements Expression {
	Expression e;
	
	public BlockNode(Expression e) {
		super();
		this.e = e;
	}
	
	@Override
	public String show() {
		String expr = "";
		expr += "<BlockNode> {}\n";
		if(!(e == null)) {
			String print = "";
			print += e.show();
			expr += Main.addNewline(print);
		}
		return expr;
	}

	@Override
	public Expression interpret() {
		return null;
	}
}

class AssignmentNode implements Expression {
	VarNode v;
	Expression e;
	
	public AssignmentNode(VarNode v, Expression e) {
		super();
		this.v = v;
		this.e = e;
	}
	
	@Override
	public String show() {
		String expr = "";
		expr += "<AssignmentNode> =\n";
		
		String print = "";
		print += v.show() + e.show();
		
		expr += Main.addNewline(print);
		return expr;
	}

	@Override
	public Expression interpret() {
		return null;
	}
}

class IfNode implements Expression {
	BracketNode b;
	BlockNode b1, b2;
	
	public IfNode(BracketNode b, BlockNode b1, BlockNode b2) {
		super();
		this.b = b;
		this.b1 = b1;
		this.b2 = b2;
	}
	
	@Override
	public String show() {
		String expr = "";
		expr += "<IfNode> if\n";
		
		String print = "";
		print += b.show() + b1.show() + b2.show();
		
		expr += Main.addNewline(print);
		return expr;
	}

	@Override
	public Expression interpret() {
		return null;
	}
}

class WhileNode implements Expression {
	BracketNode b;
	BlockNode b1;
	
	public WhileNode(BracketNode b, BlockNode b1) {
		super();
		this.b = b;
		this.b1 = b1;
	}
	
	@Override
	public String show() {
		String expr = "";
		expr += "<WhileNode> while\n";
		
		String print = "";
		print += b.show() + b1.show();
		
		expr += Main.addNewline(print);
		return expr;
	}

	@Override
	public Expression interpret() {
		return null;
	}
}



