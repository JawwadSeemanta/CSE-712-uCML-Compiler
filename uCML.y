%{
	#include<stdio.h>
	#include<stdlib.h>

    int yylex();
    void yyerror(const char *);
    extern FILE* yyin;
    extern int yylineno;
    int error_count;
%}

%error-verbose

%start program

%token TCEQ TCNE TCLT TCLE TCGT TCGE TEQUAL
%token TLPAREN TRPAREN TLBRACE TRBRACE TCOMMA TCOLON
%token TPLUS TMINUS TMUL TDIV

%token id num data_type
%token EXTERN IF ELSE FOR RETURN
%token def in to by
%token define_sign

/* Operator precedence for mathematical operators */
%left TPLUS TMINUS
%left TMUL TDIV

%%
program: 
	stmts
	;

stmts: 
	stmt
	| stmts stmt
	

stmt:
	extern_decl
	| var_decl 
	| assignment 
	| conditional_stmt
	| loop_stmt
	| RETURN expr
	| func_decl
	| expr
	
	| error
	| TLPAREN error TRPAREN
	| TLBRACE error TRBRACE
	;
	
TYPE:
	TCOLON data_type 
	;
extern_decl:
	EXTERN id TLPAREN func_decl_args TRPAREN TYPE 
	;

var_decl:
	id TYPE 
	;

assignment:
	id TEQUAL expr 
	| id TYPE TEQUAL expr 
	;

conditional_stmt:
	IF TLPAREN expr TRPAREN block 
	| IF TLPAREN expr TRPAREN block ELSE block 
	;

loop_stmt:
	FOR TLPAREN  id TYPE in expr to expr TRPAREN block 
	| FOR TLPAREN  id TYPE in expr to expr by expr TRPAREN block 
	;

block:
	TLBRACE stmts TRBRACE 
	| TLBRACE TRBRACE 
	;

func_decl:
	def id TLPAREN func_decl_args TRPAREN TYPE define_sign block 
	;

func_decl_args:
	var_decl 
	| func_decl_args TCOMMA var_decl 
	| %empty 
	;
	
func_call:
	id TLPAREN call_args TRPAREN 
	;

call_args:
	expr 
	| call_args TCOMMA expr 
	| %empty 
	;

expr:
	id 
	| num 
	| expr operation expr
    | TLPAREN expr TRPAREN 
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


int main(int argc, char **argv){
	
	if(argc>1)
        {
        yyin = fopen(argv[1],"r");
        if(yyin == 0)
            yyin = stdin;
        }
    else
        yyin = stdin;

    int flag = yyparse();
    
    fclose(yyin);
    
    if(error_count)
    	printf("\nTotal Errors: %02d\n", error_count);
    else
    	printf("No Error Detected\n");
    	
    return flag;
}
