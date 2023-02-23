%{
#include <stdlib.h>
#define YY_NO_UNPUT
#include <stdio.h>
void yyerror(const char* error);
FILE * yyin;
%}

%{
int yylex();
%}

%union{
  char* identifier_val;
  int number_val;
 }

%error-verbose
%start program

%token <ident_val> IDENTIFIER
%token <num_val> NUMBER

%token FUNCTION
%token BEGIN_PARAMS
%token END_PARAMS
%token BEGIN_LOCAL_VARS
%token END_LOCAL_VARS
%token BODY_START
%token BODY_END
%token INTEGER
%token ARRAY
%token IF
%token THEN
%token ENDIF
%token ELSE
%token WHILE
%token LOOP_BEGIN
%token LOOP_END
%left MINUS
%left PLUS
%left MULT
%left DIV
%left MOD
%left NOT_EQ
%left EQ
%left EQ_TO
%left LESS_THAN
%left GREAT_THAN
%left LESS_THAN_EQ
%left GREAT_THAN_EQ
%token READ
%token WRITE
%left AND
%left OR
%right NOT
%token RETURN
%token L_PAREN
%token R_PAREN
%token L_SQ_BRACKET
%token AMPERSAND
%token R_SQ_BRACKET
%token COLON
%token SEMICOLON
%token COMMA
%left ASSIGNMENT

%%

program: {printf("program -> epsilon\n");}
| function program {printf("program -> function program\n");};


function: FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCAL_VARS declarations END_LOCAL_VARS BODY_START statements BODY_END
{printf("function -> FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCAL_VARS declarations END_LOCAL_VARS BODY_START statements BODY_END\n");};


declarations: declaration SEMICOLON declarations {printf("declarations -> declaration SEMICOLON declarations\n");}
  | {printf("declarations -> epsilon\n");};


declaration:  identifiers COLON INTEGER {printf("declaration -> identifiers COLON INTEGER \n");}
  | identifiers COLON INTEGER ARRAY L_SQ_BRACKET NUMBER R_SQ_BRACKET {printf("declaration -> identifiers COLON INTEGER ARRAY L_SQ_BRACKET NUMBER R_SQ_BRACKET \n");};


identifiers:  IDENTIFIER {printf("identifiers -> IDENTIFIER \n");}
  | IDENTIFIER COMMA identifiers {printf("identifiers -> IDENTIFIER COMMA identifiers \n");};

statements: statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements \n");}
  | statement SEMICOLON {printf("statements -> statement SEMICOLON\n");};

statement: assign {printf("statement -> assign \n");}
  | ifthenelse {printf("statement -> ifthenelse \n");}
  | while {printf("statement -> while \n");}
	| read {printf("statement -> read \n");}
  | write {printf("statement -> write \n");}
  | return {printf("statement -> return \n");};

assign: variable ASSIGNMENT expression {printf("assign -> variable ASSIGNMENT EQ expression \n");};

ifthenelse: IF relational_expression THEN statements else_stmt ENDIF {printf("ifthenelse -> IF relational_expression THEN statements else_stmt ENDIF \n");};

while: WHILE relational_expression LOOP_BEGIN statements LOOP_END {printf("while -> WHILE relational_expression LOOP_BEGIN statements LOOP_END");};

read: READ variables {printf("read -> READ variables \n");};

write: WRITE variables {printf("write -> WRITE variables \n");};

return: RETURN expression {printf("return -> RETURN expression \n");};

else_stmt: ELSE statements {printf("else_stmt -> ELSE statements \n");}
  | {printf("else_stmt -> epsilon\n");};

relational_expression: expression comparator expression {printf("relational_expression -> expression comparator expression \n");};

comparator: LESS_THAN {printf("comparator -> LESS_THAN \n");}
  | GREAT_THAN {printf("comparator -> GREAT_THAN \n");}
  | LESS_THAN_EQ {printf("comparator -> LESS_THAN_EQ \n");}
  | GREAT_THAN_EQ {printf("comparator -> GREAT_THAN_EQ \n");}
  | EQ_TO {printf("comparator -> EQ_TO \n");}
  | NOT_EQ {printf("comparator -> NOT_EQ \n");};

expressions: expression {printf("expressions -> expression \n");}
  | {printf("expressions -> epsilon \n");};

expression: multExpression {printf("expression -> multExpression \n");}
  | multExpression PLUS expression {printf("expression -> multExpression PLUS expression \n");};
  | multExpression MINUS expression {printf("expression -> multExpression MINUS expression \n");};

multExpression: val {printf("multExpression -> val \n");}
  | val MULT multExpression {printf("multExpression -> val MULT multExpression \n");}
  | val DIV multExpression {printf("multExpression -> val DIV multExpression \n");}
  | val MOD multExpression {printf("multExpression -> val MOD multExpression \n");};


val: NUMBER {printf("val -> NUMBER \n");}
    | variable {printf("val -> variable \n");}
    | L_PAREN expression R_PAREN {printf("val -> L_PAREN expression R_PAREN \n");}
    | identifier L_PAREN expressions R_PAREN {printf("val -> identifier L_PAREN expressions R_PAREN \n");};

variable: IDENTIFIER {printf("variable -> IDENTIFIER \n");};

variables: variable {printf("variables -> variables \n");}
  | variable COMMA variables {printf("variables -> variable COMMA variables \n");};

identifier: IDENTIFIER {printf("identifier-> IDENTIFIER \n");};

%%

void yyerror(const char* error) {
  extern int row;
  extern char* yytext;
  printf("ERROR: %s at symbol \"%s\" on line %d\n", error, yytext, row);
  exit(1);
}
