%option noyywrap yylineno

%{
#include <string>
#include "node.h"
#include "parser.hpp"

#define SAVE_TOKEN  yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t)    (yylval.token = t)

extern void yyerror(const char *);

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

","				          		return TOKEN(TCOMMA);
":"         					return TOKEN(TCOLON);

"("	          					return TOKEN(TLPAREN);
")"					          	return TOKEN(TRPAREN);
"{"         					return TOKEN(TLBRACE);
"}"					          	return TOKEN(TRBRACE);


"+"				          		return TOKEN(TPLUS);
"-"		          				return TOKEN(TMINUS);
"*"		          				return TOKEN(TMUL);
"/"				          		return TOKEN(TDIV);
"%"				          		return TOKEN(TREM);

"=="				          	return TOKEN(TCEQ);
"!="			          		return TOKEN(TCNE);
"<"				          		return TOKEN(TCLT);
"<="	          				return TOKEN(TCLE);
">"				          		return TOKEN(TCGT);
">="					        return TOKEN(TCGE);

"=>" 							return define_sign;

"="						        return TOKEN(TEQUAL);

"def" 							return def;
"in" 							return in;
"to" 							return to;
"by" 							return by;
"extern" 						return EXTERN;
"if" 							return IF;
"else" 							return ELSE;
"for" 							return FOR;
"return" 						return RETURN;


{data_type} 					SAVE_TOKEN; return data_type;
{numbers} 						SAVE_TOKEN; return num;
{id} 							SAVE_TOKEN; return id;

{whitespace} {/* Do nothing */}
{newline} {/* Do nothing */};

. {yyerror("Unrecognized character"); yyterminate();}

%%
