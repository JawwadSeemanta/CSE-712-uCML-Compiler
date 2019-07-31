%option noyywrap yylineno

%{
#include "uCML.tab.h"

void yyerror(const char *);
int error_count = 0;
extern char* yytext;

%}

whitespace [ \t\v\f\r]+
newline [\n]

digit [0-9]
digits {digit}+
numbers {digits}(\.{digits})?
letter [A-Za-z]
letters {letter}+
id {letters}({letters}|{digits}|_)*

int int
double double
void void
data_type int|double|void


%%

","				          		return TCOMMA;
":"         					return TCOLON;

"("	          					return TLPAREN;
")"					          	return TRPAREN;
"{"         					return TLBRACE;
"}"					          	return TRBRACE;


"+"				          		return TPLUS;
"-"		          				return TMINUS;
"*"		          				return TMUL;
"/"				          		return TDIV;

"=="				          	return TCEQ;
"!="			          		return TCNE;
"<"				          		return TCLT;
"<="	          				return TCLE;
">"				          		return TCGT;
">="					        return TCGE;

"=>" 							return define_sign;

"="						        return TEQUAL;

"def" 							return def;
"in" 							return in;
"to" 							return to;
"by" 							return by;
"extern" 						return EXTERN;
"if" 							return IF;
"else" 							return ELSE;
"for" 							return FOR;
"return" 						return RETURN;


{data_type} 					return data_type;
{numbers} 						return num;
{id} 							return id;

{whitespace} {/* Do nothing */}
{newline} {/* Do nothing */};

. {yyerror("Unrecognized character"); yyterminate();}

%%

void yyerror(const char *err_msg ) { 
	error_count++;
	fprintf( stderr, "\nLine %02d : Error near \"%s\"\n\t%s\n",yylineno, yytext, err_msg);
}
