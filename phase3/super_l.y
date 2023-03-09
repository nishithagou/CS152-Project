%{
#include <stdlib.h>
#include <string.h>
#include "CodeNode.h"
#define YY_NO_UNPUT
#include <stdio.h>
void yyerror(const char* error);
extern FILE* yyin;
%}

%{
int tempCounter = 0;
bool isArray;
int yylex();
%}


%union{
  struct CodeNode *code_node;
  char* identifier_val;
  int number_val;
 }

%error-verbose
%start program

%token <identifier_val> IDENTIFIER
%token <number_val> NUMBER

%token FUNCTION
%token IDENTIFIERS
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

%type <code_node> functions
%type <code_node> function
%type <code_node> declarations
%type <code_node> declaration
%type <code_node> statements
%type <code_node> statement
%type <code_node> variable
%type <code_node> variables
%type <code_node> val
%type <code_node> expressions
%type <code_node> expression
%type <code_node> relational_expression
%type <code_node> multExpression
%type <code_node> assign
%type <code_node> ifthenelse
%type <code_node> return
%type <code_node> read
%type <code_node> write
%type <code_node> while
%type <code_node> else_stmt
%type <code_node> comparator
%type <code_node> identifiers
%type <identifier_val> identifier

%%

program: functions {
  CodeNode *code_node = $1;
  printf("%s\n", code_node->code.c_str());
};

functions: function functions {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $2;
  CodeNode *node = new CodeNode;
  node->code = code_node1->code + code_node2->code;
  $$ = node;
}
  |  {
  CodeNode *node = new CodeNode;
  $$ = node;

};

function: FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCAL_VARS declarations END_LOCAL_VARS BODY_START statements BODY_END
{
  CodeNode *node = new CodeNode;
  std::string func_name = $2;
  node->code = "";
  node->code += std::string("func ") + func_name + ("\n");

  CodeNode *declarations = $5;
  node->code += declarations->code;

  CodeNode *locals = $8;
  node->code += locals->code;

  CodeNode *statements = $11;
  node->code += statements->code;

  node->code += std::string("endfunc \n ");

  $$ = node;
};

declarations: declaration SEMICOLON declarations {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  CodeNode *node = new CodeNode;
  node->code = code_node1->code + code_node2->code;
  $$ = node;
}
  |  {
    CodeNode *node = new CodeNode;
    $$ = node;
};


declaration:  identifier COLON INTEGER {
  CodeNode *node = new CodeNode;
  std::string id = $1;
  node->code += std::string(". ") + id + std::string("\n");
  $$ = node;
}
  | identifier COLON INTEGER ARRAY L_SQ_BRACKET NUMBER R_SQ_BRACKET {
    CodeNode *node = new CodeNode;
    std::string id = $1;
    std::string numb = std::to_string($6);
    node->code += std::string(".[] ") + id + std::string(", ") + numb + std::string("\n");
    $$ = node;
};

identifiers:  IDENTIFIER {
  $$ = $1;
}
  | IDENTIFIER COMMA identifiers {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  CodeNode *node = new CodeNode;
  node->code += code_node1->code + code_node2->code;
  $$ = node;
};

statements: statement SEMICOLON statements {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  CodeNode *node = new CodeNode;
  node->code = code_node1->code + code_node2->code;
  $$ = node;
}
  |  {
    CodeNode *node = new CodeNode;
    $$ = node;
};

statement: assign {
  CodeNode *code_node1 = $1;
  CodeNode *node = new CodeNode;
  node->code += code_node1->code;
  $$ = node;
}
  | ifthenelse {
  CodeNode *code_node1 = $1;
  CodeNode *node = new CodeNode;
  node->code += code_node1->code;
  $$ = node;
}
  | while {
  CodeNode *code_node1 = $1;
  CodeNode *node = new CodeNode;
  node->code += code_node1->code;
  $$ = node;
}
	| read {
  CodeNode *code_node1 = $1;
  CodeNode *node = new CodeNode;
  node->code += code_node1->code;
  $$ = node;
}
  | write {
  CodeNode *code_node1 = $1;
  CodeNode *node = new CodeNode;
  node->code += code_node1->code;
  $$ = node;
}
  | return {
  CodeNode *code_node1 = $1;
  CodeNode *node = new CodeNode;
  node->code += code_node1->code;
  $$ = node;
}
  | variable L_SQ_BRACKET expression R_SQ_BRACKET ASSIGNMENT expression {
  CodeNode *code_node1 = $3;
  CodeNode *code_node2 = $6;
  CodeNode *var = $1;
  std::string id = var->name;
  CodeNode *node = new CodeNode;
  node->name = id;
  node->code += code_node1->code + code_node2->code;
  node->code += "[]= " + id + ", " + code_node1->name + ", " + code_node2->name + "\n";
  $$ = node;
  }

;

assign: variable ASSIGNMENT expression {
  CodeNode *var = $1;
  std::string id = var->name;
  CodeNode *code_node2 = $3;
  CodeNode *node = new CodeNode;
  node->code = "";
  node->code += code_node2->code;
  node->code += std::string("= ") + id + std::string(", ") + code_node2->name + std::string("\n");
  $$ = node;
};

ifthenelse: IF relational_expression THEN statements else_stmt ENDIF {
  CodeNode *node = new CodeNode;
  CodeNode *rel_exp = $2;
  CodeNode *stmt = $4;
  CodeNode *else_stmt = $5;
  std::string temp = "_temp" + std::to_string(tempCounter);
  node->code += rel_exp->code + std::string("?:= if_true0, ") + temp + std::string("\n") + std::string(":= else0\n: if_true0\n") + stmt->code + std::string(":= endif0\n: else0\n") + std::string("= c, a\n: endif0\n");
  $$ = node;
};

while: WHILE relational_expression LOOP_BEGIN statements LOOP_END {
  CodeNode *rel_exp = $2;
  CodeNode *stmt = $4;
  CodeNode *node = new CodeNode;
  node->code += std::string(": beginloop0 \n") + rel_exp->code + std::string("?:= loopbody0, _temp0 \n:= endloop0 \n: loopbody0 \n") + stmt->code + std::string(":= beginloop0 \n: endloop0 \n");
  $$ = node;
};

read: READ variable {
  CodeNode *node = new CodeNode;
  $$ = node;
};

write: WRITE variable {
  CodeNode *node = new CodeNode;
  CodeNode *var = $2;
  std::string id = var->name;
  node->code = "";
  node->code += var->code;
  node->code += std::string(".> ") + id + std::string("\n");
  $$ = node;
};

return: RETURN expression {
  CodeNode *node = new CodeNode;
  $$ = node;
};

else_stmt: ELSE statements {
  CodeNode *node = new CodeNode;
  CodeNode *stmt = $2;
  node->code += stmt->code;
  $$ = node;
}
  |  {
  CodeNode *node = new CodeNode;
  $$ = node;
};

relational_expression: expression comparator expression {
  CodeNode *node = new CodeNode;
  CodeNode *expr = $1;
  CodeNode *comp = $2;
  CodeNode *expr2 = $3;
  std::string temp = "_temp" + std::to_string(tempCounter);
  node->name = temp;
  node->code += ", " + temp + "\n" + comp->code + temp + ", " + expr->name + ", " + expr2->name + "\n";
  tempCounter++;
  $$ = node;
};

comparator: LESS_THAN {
    CodeNode *node = new CodeNode;
    node->code += "< ";
    $$ = node;
}
  | GREAT_THAN {
    CodeNode *node = new CodeNode;
    node->code += "> ";
    $$ = node;
}
  | LESS_THAN_EQ {
    CodeNode *node = new CodeNode;
    node->code += "<= ";
    $$ = node;
}
  | GREAT_THAN_EQ {
    CodeNode *node = new CodeNode;
    node->code += ">= ";
    $$ = node;
}
  | EQ_TO {
    CodeNode *node = new CodeNode;
    node->code += "== ";
    $$ = node;
}
  | NOT_EQ {
  CodeNode *node = new CodeNode;
  node->code += "!= ";
  $$ = node;
};

expressions: expression {
  CodeNode *code_node1 = $1;
  CodeNode *node = new CodeNode;
  node->code += code_node1->code;
  $$ = node;
}
  |  {
  CodeNode *node = new CodeNode;
  $$ = node;
};

expression: multExpression {
  CodeNode *code_node1 = $1;
  CodeNode *node = new CodeNode;
  std::string id = code_node1->name;
  node->name = id;
  node->code += code_node1->code;
  $$ = node;
}
  | multExpression PLUS expression {
    CodeNode *code_node1 = $1;
    CodeNode *code_node2 = $3;
    std::string temp = "_temp" + std::to_string(tempCounter);
    CodeNode *node = new CodeNode;
    node->name = temp;
    node->code += code_node1->code + code_node2->code;
    node->code += ". " + temp + "\n" + "+ " + temp + ", " + code_node1->name + ", " + code_node2->name + "\n";
    $$ = node;
    tempCounter++;
};
  | multExpression MINUS expression {
    CodeNode *code_node1 = $1;
    CodeNode *code_node2 = $3;
    std::string temp = "_temp" + std::to_string(tempCounter);
    CodeNode *node = new CodeNode;
    node->name = temp;
    node->code += code_node1->code +  code_node2->code;
    node->code += ". " + temp + "n" + "- " + temp + ", " + code_node1->name + ", " + code_node2->name + "\n";
    $$ = node;
    tempCounter++;
};

multExpression: val {
    CodeNode *code_node1 = $1;
    CodeNode *node = new CodeNode;
    std::string id = code_node1->name;
    node->name = id;
    node->code += code_node1->code;
    $$ = node;
}
  | val MULT multExpression {
    CodeNode *code_node1 = $1;
    CodeNode *code_node2 = $3;
    std::string temp = "_temp" + std::to_string(tempCounter);
    CodeNode *node = new CodeNode;
    node->name = temp;
    node->code += code_node1->code;
    node->code += ". " + temp + "\n" + "* " + temp + ", " + code_node1->name + ", " + code_node2->name + "\n";
    $$ = node;
    tempCounter++;
}
  | val DIV multExpression {
      CodeNode *code_node1 = $1;
      CodeNode *code_node2 = $3;
      std::string temp = "_temp" + std::to_string(tempCounter);
      CodeNode *node = new CodeNode;
      node->name = temp;
      node->code += code_node1->code;
      node->code += ". " + temp + "\n" + "/ " + temp + ", " + code_node1->name + ", " + code_node2->name + "\n";
      $$ = node;
      tempCounter++;

}
  | val MOD multExpression {
    CodeNode *code_node1 = $1;
    CodeNode *code_node2 = $3;
    std::string temp = "_temp" + std::to_string(tempCounter);
    CodeNode *node = new CodeNode;
    node->name = temp;
    node->code += code_node1->code;
    node->code += ". " + temp + "\n" + "% " + temp + ", " + code_node1->name + ", " + code_node2->name + "\n";
    $$ = node;
    tempCounter++;
};


val: NUMBER {
  std::string id = std::to_string($1);
  CodeNode *node = new CodeNode;
  node->name = id;
  node->code = "";
  $$ = node;
}
    | variable {
    CodeNode *code_node1 = $1;
    CodeNode *node = new CodeNode;
    node->name = code_node1->name;
    node->code += code_node1->code;
    $$ = node;
}
    | L_PAREN expression R_PAREN {
    CodeNode *code_node1 = $2;
    CodeNode *node = new CodeNode;
    node->name = code_node1->name;
    node->code = code_node1->code;
    $$ = node;
}
    | identifier L_PAREN expression R_PAREN {
    CodeNode *node = new CodeNode;
    std::string id = $1;
    CodeNode *code_node1 = $3;
    node->name = id;
    node->code += code_node1->code;
    $$ = node;
};

variable: identifier {
  isArray = false;
  std::string name = $1;
  CodeNode *node = new CodeNode;
  node->code = "";
  node->name = name;
  $$ = node;
} | L_PAREN expression R_PAREN {
    CodeNode *code_node1 = $2;
    CodeNode *node = new CodeNode;
    node->name = code_node1->name;
    node->code = code_node1->code;
    $$ = node;
} | identifier L_PAREN expression R_PAREN { //127
    CodeNode *node = new CodeNode;
    std::string id = $1;
    CodeNode *code_node1 = $3;
    node->name = id;
    node->code += code_node1->code;
    $$ = node;
};

variables: variable {
  CodeNode *code_node1 = $1;
  CodeNode *node = new CodeNode;
  node->code += code_node1->code;
  $$ = node;
}
  | variable COMMA variables {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  CodeNode *node = new CodeNode;
  node->code += code_node1->code + code_node2->code;
  $$ = node;
};

identifier: IDENTIFIER {
  $$ = $1;
};

%%

void yyerror(const char* error) {
  extern int row;
  extern char* yytext;
  printf("ERROR: %s at symbol \"%s\" on line %d\n", error, yytext, row);
  exit(1);
}
