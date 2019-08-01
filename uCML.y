%{
	#include "node.h"
    #include <cstdio>
    #include <cstdlib>
	NBlock *programBlock; /* Root Node of AST */

    extern int yylex();
    extern int yylineno;
    int error_count = 0;
    void yyerror(const char *s) {error_count++; std::printf("Error %02d: %s at line %02d \n", error_count, s, yylineno); }
%}

%error-verbose

/* Represents the many different ways we can access our data */
%union {
	Node *node;
	NBlock *block;
	NExpression *expr;
	NStatement *stmt;
	NIdentifier *ident;
	NVariableDeclaration *var_decl;
	std::vector<NVariableDeclaration*> *varvec;
	std::vector<NExpression*> *exprvec;
	std::string *string;
	int token;
}

/* Defining terminal symbols (tokens) and their the node type */

%token <token> TCEQ TCNE TCLT TCLE TCGT TCGE TEQUAL
%token <token> TLPAREN TRPAREN TLBRACE TRBRACE TCOMMA TCOLON
%token <token> TPLUS TMINUS TMUL TDIV

%token <string> id num data_type
%token <token> EXTERN IF ELSE FOR RETURN
%token <token> def in to by
%token <token> define_sign


/* Define the type of node of nonterminal symbols */
 
%type <ident> IDENTIFIER DATA_TYPE
%type <expr> NUMBER expr
%type <varvec> func_decl_args
%type <exprvec> call_args
%type <block> program stmts block
%type <stmt> stmt var_decl func_decl extern_decl
%type <token> operation arithmatic_operation comparision_operation

/* Operator precedence for mathematical operators */
%left TPLUS TMINUS
%left TMUL TDIV
 
/* define start point */
%start program

%%
program: 
	stmts { programBlock = $1; }
	;

stmts: 
	stmt { $$ = new NBlock(); $$->statements.push_back($<stmt>1); }
	| stmts stmt { $1->statements.push_back($<stmt>2); }
	;

stmt:
	expr { $$ = new NExpressionStatement(*$1); }
	| extern_decl
	| var_decl 
	| conditional_stmt
	| loop_stmt
	| RETURN expr { $$ = new NReturnStatement(*$2); }
	| func_decl
	
	| error
	| TLPAREN error TRPAREN
	| TLBRACE error TRBRACE
	;
	
IDENTIFIER:
	id { $$ = new NIdentifier(*$1); delete $1; }
	;

NUMBER:
	num { $$ = new NInteger(atol($1->c_str())); delete $1; }
	;

DATA_TYPE:
	data_type { $$ = new NIdentifier(*$1); delete $1; }
	;
	
extern_decl:
	EXTERN IDENTIFIER TLPAREN func_decl_args TRPAREN TCOLON DATA_TYPE { $$ = new NExternDeclaration(*$7, *$2, *$4); delete $4; }
	;

var_decl:
	IDENTIFIER TCOLON DATA_TYPE { $$ = new NVariableDeclaration(*$3, *$1); }
	| IDENTIFIER TCOLON DATA_TYPE TEQUAL expr { $$ = new NVariableDeclaration(*$3, *$1, $5); }
	;

conditional_stmt:
	IF TLPAREN expr TRPAREN block 
	| IF TLPAREN expr TRPAREN block ELSE block 
	;

loop_stmt:
	FOR TLPAREN  IDENTIFIER TCOLON DATA_TYPE in expr to expr TRPAREN block 
	| FOR TLPAREN  IDENTIFIER TCOLON DATA_TYPE in expr to expr by expr TRPAREN block 
	;

block:
	TLBRACE stmts TRBRACE 
	| TLBRACE TRBRACE 
	;

func_decl:
	def IDENTIFIER TLPAREN func_decl_args TRPAREN TCOLON DATA_TYPE define_sign block 
	;

func_decl_args:
	var_decl { $$ = new VariableList(); $$->push_back($<var_decl>1); }
	| func_decl_args TCOMMA var_decl { $1->push_back($<var_decl>3); }
	| %empty { $$ = new VariableList(); }
	;
	
func_call:
	IDENTIFIER TLPAREN call_args TRPAREN 
	;

call_args:
	expr 
	| call_args TCOMMA expr 
	| %empty 
	;

expr:
	IDENTIFIER { $<ident>$ = $1; }
	| NUMBER
	| IDENTIFIER TEQUAL expr { $$ = new NAssignment(*$<ident>1, *$3); }
	| expr operation expr { $$ = new NBinaryOperator(*$1, $2, *$3); }
    | TLPAREN expr TRPAREN { $$ = $2; }
    | func_call
    ;
   
operation:
	arithmatic_operation | comparision_operation 
	;

arithmatic_operation:
	TMINUS 
	| TPLUS
	| TDIV
	| TMUL
	;

comparision_operation:
	TCEQ 
	| TCNE 
	| TCLT 
	| TCLE 
	| TCGT 
	| TCGE
	;
	
%%
