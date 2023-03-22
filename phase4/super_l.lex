%{
  #include "y.tab.h"
	int row = 1;
	int position = 1;
%}

DIGIT [0-9]
LETTER [a-zA-Z]
COMMENT ##.*\n

%%
{COMMENT}		{row = row + 1; position = 1;}
{DIGIT}*		{yylval.number_val = atoi(yytext); return NUMBER; position = position + yyleng;}

"\n"		{row = row + 1; position = 1;}
[ ]		{position = position + yyleng;}
[\t]		{position = position + yyleng;}

"(" return L_PAREN; position +=1;
")" return R_PAREN; position +=1;
"[" return L_SQ_BRACKET; position +=1;
"]" return R_SQ_BRACKET; position +=1;
"+" return PLUS; position +=1;
"-" return MINUS; position +=1;
"*" return MULT; position +=1;
"/" return DIV; position +=1;
"%" return MOD; position +=1;

"&=" return ASSIGNMENT; position +=2;
":" return COLON; position +=1;
";" return SEMICOLON; position +=1;
"," return COMMA; position +=1;
"&" return AMPERSAND; position +=1;

"<" return LESS_THAN; position +=1;
">" return GREAT_THAN; position +=1;
"<=" return LESS_THAN_EQ; position +=2;
">=" return GREAT_THAN_EQ; position +=2;
"==" return EQ_TO; position +=2;
"!=" return NOT_EQ; position +=2;
"=" return EQ; position +=1;

function return FUNCTION; position += yyleng;
beginparameters return BEGIN_PARAMS; position += yyleng;
endparameters return END_PARAMS; position += yyleng;
beginlocalvars return BEGIN_LOCAL_VARS; position += yyleng;
endlocalvars return END_LOCAL_VARS; position += yyleng;
bodystart return BODY_START; position += yyleng;
bodyend return BODY_END; position += yyleng;

int return INTEGER; position += yyleng;
array return ARRAY; position += yyleng;
if return IF; position+= yyleng;
then return THEN; position += yyleng;
endif return ENDIF; position += yyleng;
else return ELSE; position += yyleng;
while return WHILE; position += yyleng;
beginloop return LOOP_BEGIN; position += yyleng;
endloop return LOOP_END; position += yyleng;
read return READ; position += yyleng;
write return WRITE; position += yyleng;
not return NOT; position += yyleng;
return return RETURN; position += yyleng;
break return BREAK; position += yyleng;

[0-9_][a-zA-Z0-9_]*[a-zA-Z0-9]		{printf("IDENTIFIER %s ERROR AT LINE %d, POSITION %d. IDENTIFIER CAN ONLY BEGIN WITH A LETTER. \n", yytext, row , position); position += yyleng;}
([a-zA-Z0-9_]*"_") {printf("IDENTIFIER \"%s\" ERROR AT LINE %d, POSITION %d. IDENTIFIER CANNOT END WITH AN UNDERSCORE. \n", yytext, row, position); position += yyleng;}
([a-zA-Z0-9_]*"&") {printf("IDENTIFIER \"%s\" ERROR AT LINE %d, POSITION %d. IDENTIFIER CANNOT END WITH AN AMPERSAND. \n", yytext, row, position); position += yyleng;}
[a-zA-Z0-9_]*[a-zA-Z0-9]*		{yylval.identifier_val = strdup(yytext); return IDENTIFIER; position += yyleng;}
%%
int yyparse();
