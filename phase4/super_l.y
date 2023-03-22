%{
#include "y.tab.h"
#include <string>
#include <stdio.h>
#include <algorithm>
#include <vector>
#include <iostream>
#include "stdbool.h"
#include <stdlib.h>
using namespace std;

extern int yylex();
extern int yyparse();
extern int line;
void yyerror(const char *msg);
extern FILE* yyin;

void print_table();
void duplicates();
void print_table();
void findMain();
string *makeTemp();
int whileCounter = 0;
int ifCounter = 0;
int tempCounter;
vector<string> symbolTable;
vector<int> loop;
vector<string> funcList;
vector<string> errorTable;
int counts = 0;

enum FuncTypes {Parameters, Integer, Array, Addition, Subtraction, Division, Multiplication, Mod};

struct CodeNode {
    std::string name;
    std::string code;
    FuncTypes type;
    FuncTypes func;
    string returnVal;
    bool endCheck = false;
    std::string op;
};

struct collection {
   string name;
   FuncTypes type;
};

%}

%start program

%union{
  int number_val;
  char* identifier_val;
  struct CodeNode* code_node;
}

%error-verbose
%locations

%token FUNCTION
%token BEGIN_PARAMS
%token END_PARAMS
%token BEGIN_LOCAL_VARS
%token END_LOCAL_VARS
%token BODY_START
%token BODY_END
%token SEMICOLON
%token COLON
%token COMMA
%token WHILE
%token LOOP_BEGIN
%token LOOP_END
%token READ
%token EQ
%token AMPERSAND
%token WRITE
%token INTEGER
%token ARRAY
%token OF
%token IF
%token THEN
%token ENDIF
%token ELSE
%token BREAK
%token NOT
%token RETURN
%left MINUS
%left PLUS
%left MULT
%left DIV
%left MOD
%left L_PAREN
%left R_PAREN
%left L_SQ_BRACKET
%left R_SQ_BRACKET
%left EQ_TO NOT_EQ
%left LESS_THAN
%left GREAT_THAN
%left LESS_THAN_EQ
%left GREAT_THAN_EQ
%right ASSIGNMENT

%token <number_val> NUMBER
%token <identifier_val> IDENTIFIER

%type <code_node> program
%type <code_node> function
%type <code_node> functions
%type <code_node> declarations
%type <code_node> declaration
%type <code_node> statements
%type <code_node> else_stmt
%type <code_node> statement
%type <code_node> identifier
%type <code_node> identifiers
%type <code_node> relational_expression
%type <code_node> expression
%type <code_node> expressions
%type <code_node> multExpression
%type <code_node> comparator
%type <code_node> variable
%type <code_node> val

%%

program: functions {
   CodeNode *code_node = $1;
   printf("%s\n", code_node->code.c_str());
};

functions: function functions {
   CodeNode *code_node1 = $1;
   CodeNode *code_node2 = $2;
   CodeNode *node = new CodeNode;
   node->code = code_node1->code;
   node->code += code_node2->code;
   findMain();
   $$ = node;
}
  | {
  CodeNode *node = new CodeNode;
  $$ = node;
};

function: FUNCTION identifier SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCAL_VARS declarations END_LOCAL_VARS BODY_START statements BODY_END {
   CodeNode *node = new CodeNode;
   std::string func_name = $2->code;
   node->code = "";
   node->code += std::string("func ") + func_name + ("\n");

   CodeNode *declarations = $5;
   node->code += declarations->code;

   CodeNode *locals = $8;
   node->code += locals->code;

   CodeNode *statements = $11;
   node->code += statements->code;

   node->code += std::string("endfunc \n");
   $$ = node;

   funcList.push_back(func_name);
   print_table();
   symbolTable.clear();
};

declarations: declaration SEMICOLON declarations {
   CodeNode *code_node1 = $1;
   CodeNode *code_node2 = $3;
   CodeNode *node = new CodeNode;
   node->code = code_node1->code + code_node2->code;
   $$ = node;
}
  | {
  CodeNode *node = new CodeNode;
  $$ = node;
};

declaration: identifiers COLON INTEGER {
   CodeNode *value = $1;
   CodeNode *node = new CodeNode;
   string ident = value->code;
   std::string id = $1->code;
   node->code = std::string(". ") + id + std::string("\n");
   symbolTable.push_back(ident);
   $$ = node;
}
   | identifiers COLON INTEGER ARRAY L_SQ_BRACKET NUMBER R_SQ_BRACKET {
   CodeNode *code_node = new CodeNode;
   std::string num = std::to_string($6);
   CodeNode *ident = $1;
   string name = ident->code;
   std::string id = $1->code;
   code_node->code += std::string(".[] ") + id + std::string(", ") + num + ("\n");
   symbolTable.push_back(name);
   $$ = code_node;
};

statements: statement SEMICOLON statements {
   CodeNode *code_node1 = $1;
   CodeNode *code_node2 = $3;
   CodeNode *node = new CodeNode;
   node->endCheck = code_node1->endCheck;
   node->code = code_node1->code + code_node2->code;
   $$ = node;
}
  | {
  CodeNode *node = new CodeNode;
  $$ = node;
};

else_stmt: ELSE statements {
   CodeNode *node = new CodeNode;
   CodeNode *stmt = $2;
   node->code += stmt->code;
   $$ = node;
}
  | {
   CodeNode *node = new CodeNode;
   $$ = node;
};

statement: variable ASSIGNMENT expression {
   CodeNode *var = $1;
   CodeNode *exp = $3;
   CodeNode *node = new CodeNode;

   node->code = string("= ") + var->code + string(", ") + exp->code + string("\n");

   if (exp->func == Addition || exp->func == Subtraction) {
      node->code = exp->code + string("\n") + string("= ") + var->code + string(", ") + exp->name + string("\n");
   } else if (exp->func == Multiplication || exp->func == Division || exp->func == Mod) {
      node->code = exp->code + string("\n") + string("= ") + var->code + string(", ") + exp->name + string("\n");
   }

   if (exp->func == Parameters) {
      node->code = string("") + exp->code + string("\n") + string("= ") +  var->code + string(", ")  + exp->name + string("\n");
   }
   if (exp->func == Array) {
      node->code = string(".[] ") + var->code + string(", ") + exp->code + ("\n");
      if (exp->func == Multiplication) {
         node->code = exp->code + string("\n");
      }
      if (exp->func == Addition) {
         node->code = exp->code + string("\n") + string("[]= ") + var->code + string(", ") + exp->name + string("\n");
      }
   }
   $$ = node;
}
  | IF relational_expression THEN statements else_stmt ENDIF {
  CodeNode *node = new CodeNode;
  CodeNode *relexp = $2;
  CodeNode *stmts = $4;
  CodeNode *else_stmt = $5;

  node->code += relexp->code + ("\n") + string("?:= if_true") + to_string(ifCounter) + string(", ") + relexp->name + ("\n");

  if(else_stmt->code != "") {
    node->code += string(":= else0\n");
  } else {
    node->code += string(":= endif0\n");
  }

  node->code += string(": if_true") + to_string(ifCounter) + ("\n") + stmts->code;

  if(stmts->endCheck == false) {
    node->code += std::string(":= endif") + to_string(ifCounter) + ("\n") + std::string(":= else") + to_string(ifCounter) + ("\n");
  }
  node->code += else_stmt->code + std::string(": endif") + to_string(ifCounter) + ("\n");

  ifCounter = ifCounter + 1;
  loop.push_back(0);
  $$ = node;
}
  | WHILE relational_expression LOOP_BEGIN statements LOOP_END {
  CodeNode *rel_exp = $2;
  CodeNode *stmt = $4;
  CodeNode *node = new CodeNode;
  node->code = std::string(": beginloop") + to_string(whileCounter) + ("\n");

  node->code += rel_exp->code + ("\n") + string("?:= loopbody") + to_string(whileCounter) + string(", ") + rel_exp->name + ("\n");
  node->code += string(":= endloop") + to_string(whileCounter) + ("\n");

  node->code += string(": loopbody") + to_string(whileCounter) + ("\n") + stmt->code;
  node->code += std::string(":= beginloop") + to_string(whileCounter) + ("\n") + std::string(": endloop") + to_string(whileCounter) + ("\n");

  whileCounter += 1;
  loop.push_back(0);
  $$ = node;
}
  | WRITE variable {
  CodeNode *code_node1 = $2;
  CodeNode *code_node2 = new CodeNode;
  //action is only diff if an array
  if(code_node1->func == Array) {
    string *temp = makeTemp();
    code_node2->code = ". " + *temp + string("\n");
    code_node2->code += string("=[] ") + *temp + string(", ") + code_node1->code + ("\n") + string(".> ") + *temp + ("\n");
  } else {
    code_node2->code = string(".> ") + code_node1->code + ("\n");
  }
  $$ = code_node2;

}
  | READ variable {
  CodeNode *code_node1 = $2;
  CodeNode *code_node2 = new CodeNode;
  code_node2->code = std::string(".< ") + code_node1->code + string("\n");
  $$ = code_node2;
}
  | RETURN expression {
  CodeNode *code_node1 = new CodeNode;
  CodeNode *code_node2 = $2;
  if(code_node2->func == Multiplication || code_node2->func == Division || code_node2->func == Mod || code_node2->func == Parameters) {
    code_node1->code = std::string("ret ") + code_node2->code + ("\n");
  }
  if(code_node2->func == Addition || code_node2->func == Subtraction) {
    code_node1->code += code_node2->code + string("\n") + string("ret ") + code_node2->name + ("\n");
  }
  code_node1->endCheck = true;
  $$ = code_node1;
}
  | BREAK {
  loop.push_back(1);
  CodeNode *code_node = new CodeNode;
  code_node->endCheck = true;
  code_node->code = std::string(":= endloop0\n");
  $$ = code_node;
};

relational_expression: expression comparator expression {
  CodeNode *node = new CodeNode;
   CodeNode *expr = $1;
   CodeNode *comp = $2;
   CodeNode *expr2 = $3;
   string *temp = makeTemp();
   node->code += string(". ") + *temp + ("\n") + comp->code + *temp + string(", ") + expr->code + string(", ") + expr2->code;
   node->name = *temp;
   $$ = node;
};

comparator: LESS_THAN {
   CodeNode *node = new CodeNode;
   node->code = "< ";
   $$ = node;
}
  | GREAT_THAN {
  CodeNode *node = new CodeNode;
  node->code = "> ";
  $$ = node;
}
  | LESS_THAN_EQ {
  CodeNode *node = new CodeNode;
  node->code = "<= ";
  $$ = node;
}
  | GREAT_THAN_EQ {
  CodeNode *node = new CodeNode;
  node->code = ">= ";
  $$ = node;
}
  | EQ_TO {
  CodeNode *node = new CodeNode;
  node->code = "== ";
  $$ = node;
}
  | NOT_EQ {
  CodeNode *node = new CodeNode;
  node->code = "!= ";
  $$ = node;
}
  | ASSIGNMENT {
  CodeNode *node = new CodeNode;
  node->code = "&= ";
  $$ = node;
};

expressions: COMMA expression expressions {
   CodeNode *code_node1 = new CodeNode;
   CodeNode *code_node2 = $2;
   code_node1->func = code_node2->func;
   code_node1->code = code_node2->code;
   code_node1->name = code_node2->name;
   $$ = code_node1;
}
  | {
  CodeNode *node = new CodeNode;
  node->code = string("");
  $$ = node;
};

expression: multExpression {
   CodeNode *code_node1 = $1;
   CodeNode *node = new CodeNode;
   node->code = code_node1->code;
   node->func = code_node1->func;
   std::string id = code_node1->name;
   node->name = id;
   node->op = code_node1->op;
   node->returnVal = code_node1->returnVal;
   $$ = node;
}
  | multExpression PLUS expression {
  CodeNode *node = new CodeNode;
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  node->func = Addition;

  if(code_node1->func == Parameters){
    node->code = code_node1->code + string("\n");
    node->code += code_node2->code + string("\n");
    string *temp = makeTemp();
    node->name = *temp;
    node->code = code_node1->code + ("\n") + code_node2->code + ("\n") + string(". ") + *temp + ("\n") + string("+ ") + *temp + string(", ") + code_node1->name + string(", ") + code_node2->name;
  }
  if(code_node1->func == Array){
    string *temp = makeTemp();
    string *temp1 = makeTemp();
    string *temp2 = makeTemp();
    node->name = *temp;
    node->code = string(". ") + *temp1 + ("\n") +
    string("=[] ") + *temp1 + string(", ") + code_node1->code + ("\n");
    node->code += ". " + *temp2 + ("\n") + string("+ ") + *temp2 + string(", ") + *temp1 + (", ") + code_node2->code;
    node->op = *temp2;
  } else {
    string *temp = makeTemp();
    node->code = string(". ") + *temp + ("\n") + string("+ ") + *temp + string(", ") + code_node1->code + string(", ") + code_node2->code;
    node->returnVal = string("= ") + code_node1->code + string(", $0\n") + string("= ") + code_node2->code + string(", $1\n");
    node->name = *temp;
  }
  $$ = node;
}
  | multExpression MINUS expression{
   CodeNode *code_node1 = $1;
   CodeNode *code_node2 = $3;
   CodeNode *node = new CodeNode;
   node->func = Subtraction;

   if(code_node1->func != Array){
     string *temp = makeTemp();
     node->name = *temp;
     node->code = string(". ") + *temp + ("\n") + string("- ") + *temp + string(", ") + code_node1->code + string(", ") + code_node2->code;
     node->returnVal = string("= ") + code_node1->code + string(", $0\n") + string("= ") + code_node2->code + string(", $1\n");
   }
   if(code_node1->func == Array) {
      string *temp1 = makeTemp();
      string *temp2 = makeTemp();
      string *temp3 = makeTemp();
      node->name = *temp1;
      node->code = string(". ") + *temp2 + ("\n") +
      string("=[] ") + *temp2 + string(", ") + code_node1->code + ("\n");
      node->code += ". " + *temp3 + ("\n") + string("- ") + *temp3 + string(", ") + *temp2 + string(", ") + code_node2->code;
      node->op = *temp3;
   }
   $$ = node;
};

multExpression: val {
   CodeNode *node = new CodeNode;
   CodeNode *code_node1 = $1;
   node->name = code_node1->name;
   node->code = code_node1->code;
   node->func = code_node1->func;
   node->op = code_node1->op;
   node->returnVal = code_node1->returnVal;
   $$ = node;
}
  | val MULT val {
   CodeNode *node = new CodeNode;
   node->func = Multiplication;
   CodeNode *code_node1 = $1;
   CodeNode *code_node2 = $3;
   if(code_node1->func != Array){
     string *temp1 = makeTemp();
     node->name = *temp1;
     node->code = string(". ") + *temp1 + ("\n") + string("* ") + *temp1 + string(", ") + code_node1->code + string(", ") + code_node2->code;
     node->returnVal = string("= ") + code_node1->code + string(", $0\n") + string("= ") + code_node2->code + string(", $1\n");
   } else {
     string *temp = makeTemp();
     node->name = *temp;
     node->code = string(". ") + code_node2->name + ("\n") + string("=[] ") + code_node2->name + string(", ") + code_node1->code + ("\n");
     node->code += string("") + code_node2->code + ("\n") + string(". ") + *temp + ("\n");
     node->code += string("* ") + *temp + string(", ") + code_node2->name + string(", ") + code_node2->op + ("\n") + string("[]= ") + code_node1->code + string(", ") + *temp;
   }
   $$ = node;

}
  | val DIV val {
  CodeNode *node = new CodeNode;
  node->func = Division;
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  if(code_node1->func != Array){
    string *temp = makeTemp();
    node->name = *temp;
    node->code = string(". ") + *temp + ("\n") + string("/ ") + *temp + string(", ") + code_node1->code + string(", ") + code_node2->code;
    node->returnVal = string("= ") + code_node1->code + string(", $0\n") + string("= ") + code_node2->code + string(", $1\n");
  } else {
    string *temp1 = makeTemp();
    node->name = *temp1;
    node->code = string(". ") + code_node2->name + ("\n") + string("=[] ") + code_node2->name + string(", ") + code_node1->code + ("\n");
    node->code += string("") + code_node2->code + ("\n") + string(". ") + *temp1 + ("\n");
    node->code += string("/ ") + *temp1 + string(", ") + code_node2->name + string(", ") + code_node2->op + ("\n") + string("[]= ") + code_node1->code + string(", ") + *temp1;
  }
  $$ = node;
}
  | val MOD val {
  CodeNode *node = new CodeNode;
  node->func = Mod;
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  if(code_node1->func != Array){
    string *temp = makeTemp();
    node->name = *temp;
    node->code = string(". ") + *temp + ("\n") + string("% ") + *temp + string(", ") + code_node1->code + string(", ") + code_node2->code;
    node->returnVal = string("= ") + code_node1->code + string(", $0\n") + string("= ") + code_node2->code + string(", $1\n");
  } else {
    string *temp1 = makeTemp();
    node->name = *temp1;
    node->code = string(". ") + code_node2->name + ("\n") + string("=[] ") + code_node2->name + string(", ") + code_node1->code + ("\n");
    node->code += string("") + code_node2->code + ("\n") + string(". ") + *temp1 + string("\n");
    node->code += string("% ") + *temp1 + string(", ") + code_node2->name + string(", ") + code_node2->op + ("\n") + string("[]= ") + code_node1->code + string(", ") + *temp1;
  }
   $$ = node;
};

val: NUMBER {
  CodeNode *node = new CodeNode;
  string code = to_string($1);
  node->code = code;
  $$ = node;
}
  | variable {
  CodeNode *node = new CodeNode;
  CodeNode *code_node = $1;
  node->code = code_node->code;
  node->name = code_node->name;
  node->func = code_node->func;
  node->op = code_node->op;
  $$ = node;
}
  | L_PAREN expression R_PAREN {
   CodeNode *node = new CodeNode;
   CodeNode *code_node = $2;
   node->name = code_node->name;
   node->code = code_node->code;
   node->func = code_node->func;
   node->op = code_node->op;
   $$ = node;
}
  | identifier L_PAREN expression R_PAREN {
   CodeNode *node = new CodeNode;
   CodeNode *ident = $3;
   CodeNode *exp = $1;
   string *temp = makeTemp();
   node->name = *temp;
   node->code = ident->code + string("\n") + string("param ") + ident->name + string("\n") + ". " + *temp + string("\n") + "call " + exp->code + string(", ") + *temp;
   node->func = Parameters;
   $$ = node;
}
  | identifier L_PAREN expression expressions R_PAREN {
   CodeNode *node = new CodeNode;
   node->func = Parameters;
   CodeNode *ident = $1;
   CodeNode *exp1 = $3;
   CodeNode *exp2 = $4;
   if(exp2->func == Addition) {
      string *temp1 = makeTemp();
      node->name = *temp1;
      node->code = string("param ") + exp1->code + string("\n") + exp2->code + ("\n") + string("param ") + exp2->name + ("\n");
      node->code += ". " + *temp1 + ("\n") + "call " + ident->code + string(", ") + *temp1 + string("");
   }
   if(exp2->func != Addition) {
      string *temp = makeTemp();
      node->name = *temp;
      node->code = string("param ") + exp1->code + ("\n") + string("param ") + exp2->code + ("\n") + ". " + *temp + ("\n") + "call " + ident->code + string(", ") + *temp;
   }
   $$ = node;
};

identifiers: identifier {
   CodeNode *node = new CodeNode;
   std::string name = $1->code;
   node->code = name;
   $$ = node;
};

identifier: IDENTIFIER {
   CodeNode *node = new CodeNode;
   std::string name = $1;
   node->code = name;
   $$ = node;
};

variable: identifier {
   CodeNode *node = new CodeNode;
   CodeNode *code_node1 = $1;
   node->code = code_node1->code;
   node->name = code_node1->name;
   node->func = Integer;
   node->returnVal = code_node1->code;
   $$ = node;
}
   | identifier L_SQ_BRACKET expression R_SQ_BRACKET {
   CodeNode *code_node1 = $1;
   CodeNode *code_node2 = $3;
   CodeNode *node = new CodeNode;
   node->code = code_node1->code + string(", ") + code_node2->code + string("");
   node->func = Array;
   $$ = node;
};

%%

//All the functions to check for semantic errors

//checking for duplicate idents and function names
void duplicates() {
   int pos = 0;
   for(int i = 0; i < symbolTable.size(); i++) {
         for(int n = 0; n < i; n++) {
            if(i != n) {
               if(symbolTable[i] == symbolTable[n]) {
                  pos = i + 5;
                  string s = "ERROR: Line: " + to_string(pos) + symbolTable[i] + " has been redefined.";
                  errorTable.push_back(s);
               }
            }
         }
   }
   for(int i = 0; i < funcList.size(); i++) {
         for(int n = 0; n < i; n++) {
            if(i != n) {
               if(funcList[i] == funcList[n]) {
                  pos = i + 5;
                  string s = "ERROR: Line: " + to_string(pos) + "Function " + funcList[i] + " has been redefined.";
                  errorTable.push_back(s);
               }
            }
         }
   }
}

//checks for existence of main function
void findMain() {
   bool isMain = false;
   for(int i = 0; i < funcList.size(); i ++) {
      if(funcList[i] == "main") {
         isMain = true;
      }
   }
   if(isMain == false) {
      cout << "ERROR: There is no main function!! " << endl;
      exit(0);
   }
}

//added new function for temp bc count was incorrect
string *makeTemp() {
   string* temp = new string();
   *temp = string("_temp") + to_string(tempCounter) + string("");
   tempCounter++;
   return temp;
}

//prints table of errors
void print_table() {
   duplicates();
   if(errorTable.size() != NULL) {
      for(int i = 0; i < errorTable.size(); i ++) {
         cout << errorTable[i] << endl;
      }
      exit(0);
   }
}

void yyerror(const char *error) {
   printf("** Line %d: %s\n", yylloc.first_line, error);
}

int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == 0) {
         printf("Cannot open the file. \n");
      }
   }
   yyparse();
   print_table();
   return 0;
}
