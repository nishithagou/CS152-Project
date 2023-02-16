%{
	int row = 1;
	int position = 1;
%}

DIGIT [0-9]
LETTER [a-zA-Z]
COMMENT ##.*\n

%%

{COMMENT}		{row = row + 1; position = 1;}
{DIGIT}*		{printf("NUMBER %s\n", yytext); position = position + yyleng;}

"\n"		{row = row + 1; position = 1;}
[ ]		{position = position + yyleng;}
[\t]		{position = position + yyleng;}

"(" {printf("L_PAREN \n"); position += yyleng;}
")" {printf("R_PAREN \n"); position += yyleng;}
"[" {printf("L_SQ_BRACK \n"); position += yyleng;}
"]" {printf("R_SQ_BRACK \n"); position += yyleng;}
"+" {printf("PLUS \n"); position += yyleng;}
"-" {printf("MINUS \n"); position += yyleng;}
"*" {printf("MULT \n"); position += yyleng;}
"/" {printf("DIV \n"); position += yyleng;}
"%" {printf("MOD \n"); position += yyleng;}

"&=" {printf("ASSIGNMENT \n"); position += yyleng;}
":" {printf("COLON \n"); position += yyleng;}
";" {printf("SEMICOLON \n"); position += yyleng;}
"," {printf("COMMA \n"); position += yyleng;}
"&" {printf("AMPERSAND \n"); position += yyleng;}

"<" {printf("LESS_THAN \n"); position += yyleng;}
">" {printf("GREAT_THAN \n"); position += yyleng;}
"<=" {printf("LESS_THAN_EQ \n"); position += yyleng;}
">=" {printf("GREAT_THAN_EQ \n"); position += yyleng;}
"==" {printf("EQ_TO \n"); position += yyleng;}
"!=" {printf("NOT_EQ \n"); position += yyleng;}

function {printf("FUNCTION \n"); position += yyleng;}
beginparameters {printf("BEGIN_PARAMS \n"); position += yyleng;}
endparameters {printf("END_PARAMS \n"); position += yyleng;}
beginlocalvars {printf("BEGIN_LOCAL_VARS \n"); position += yyleng;}
endlocalsvars {printf("END_LOCALS_VARS \n"); position += yyleng;}
bodystart {printf("BODY_START \n"); position += yyleng;}
bodyend {printf("BODY_END \n"); position += yyleng;}

int 				{printf("INTEGER \n"); position += yyleng;}
array 			{printf("ARRAY \n"); position += yyleng;}

if {printf("IF \n"); position+= yyleng;}
then {printf("THEN \n"); position += yyleng;}
endif {printf("ENDIF \n"); position += yyleng;}
else {printf("ELSE \n"); position += yyleng;}
while {printf("WHILE \n"); position += yyleng;}
for {printf("FOR \n"); position += yyleng;}
beginloop {printf("LOOP_BEGIN \n"); position += yyleng;}
endloop {printf("LOOP_END \n"); position += yyleng;}
read {printf("READ \n"); position += yyleng;}
write {printf("WRITE \n"); position += yyleng;}
and {printf("AND \n"); position += yyleng;}
or {printf("OR \n"); position += yyleng;}
not {printf("NOT \n"); position += yyleng;}
return {printf("RETURN \n"); position += yyleng;}

/* finding identifiers */
[a-zA-Z0-9_]*[a-zA-Z0-9]*		{printf("IDENTIFIER %s\n", yytext); position += yyleng;}

/* invalid identifiers */
/* identifiers can only begin with a letter, and cannot end with an underscore or ampersand. */

[0-9_][a-zA-Z0-9_]*[a-zA-Z0-9]		{printf("IDENTIFIER %s ERROR AT LINE %d, POSITION %d. IDENTIFIER CAN ONLY BEGIN WITH A LETTER. \n", yytext, row , position); position += yyleng;}
[a-zA-Z0-9_]*[_]		{printf("IDENTIFIER %s ERROR AT LINE %d, POSITION %d. IDENTIFIER CANNOT END WITH AN UNDERSCORE. \n", yytext, row, position); position += yyleng;}
[a-zA-Z0-9_]*[&]    {printf("IDENTIFIER %s ERROR AT LINE %d, POSITION %d. IDENTIFIER CANNOT END WITH AN AMPERSAND. \n", yytext, row, position); position += yyleng;}

%%

int main(int argc, char** argv){
	if(argc >= 2){
		if(yyin == NULL){
			printf("Please enter a file name.");
		} else {
			yylex();
			return 0;
		}
	} else {
		printf("Please enter valid input.");
	}
}
