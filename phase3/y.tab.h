/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IDENTIFIER = 258,
     NUMBER = 259,
     FUNCTION = 260,
     IDENTIFIERS = 261,
     BEGIN_PARAMS = 262,
     END_PARAMS = 263,
     BEGIN_LOCAL_VARS = 264,
     END_LOCAL_VARS = 265,
     BODY_START = 266,
     BODY_END = 267,
     INTEGER = 268,
     ARRAY = 269,
     IF = 270,
     THEN = 271,
     ENDIF = 272,
     ELSE = 273,
     WHILE = 274,
     LOOP_BEGIN = 275,
     LOOP_END = 276,
     MINUS = 277,
     PLUS = 278,
     MULT = 279,
     DIV = 280,
     MOD = 281,
     NOT_EQ = 282,
     EQ = 283,
     EQ_TO = 284,
     LESS_THAN = 285,
     GREAT_THAN = 286,
     LESS_THAN_EQ = 287,
     GREAT_THAN_EQ = 288,
     READ = 289,
     WRITE = 290,
     AND = 291,
     OR = 292,
     NOT = 293,
     RETURN = 294,
     L_PAREN = 295,
     R_PAREN = 296,
     L_SQ_BRACKET = 297,
     AMPERSAND = 298,
     R_SQ_BRACKET = 299,
     COLON = 300,
     SEMICOLON = 301,
     COMMA = 302,
     ASSIGNMENT = 303
   };
#endif
/* Tokens.  */
#define IDENTIFIER 258
#define NUMBER 259
#define FUNCTION 260
#define IDENTIFIERS 261
#define BEGIN_PARAMS 262
#define END_PARAMS 263
#define BEGIN_LOCAL_VARS 264
#define END_LOCAL_VARS 265
#define BODY_START 266
#define BODY_END 267
#define INTEGER 268
#define ARRAY 269
#define IF 270
#define THEN 271
#define ENDIF 272
#define ELSE 273
#define WHILE 274
#define LOOP_BEGIN 275
#define LOOP_END 276
#define MINUS 277
#define PLUS 278
#define MULT 279
#define DIV 280
#define MOD 281
#define NOT_EQ 282
#define EQ 283
#define EQ_TO 284
#define LESS_THAN 285
#define GREAT_THAN 286
#define LESS_THAN_EQ 287
#define GREAT_THAN_EQ 288
#define READ 289
#define WRITE 290
#define AND 291
#define OR 292
#define NOT 293
#define RETURN 294
#define L_PAREN 295
#define R_PAREN 296
#define L_SQ_BRACKET 297
#define AMPERSAND 298
#define R_SQ_BRACKET 299
#define COLON 300
#define SEMICOLON 301
#define COMMA 302
#define ASSIGNMENT 303




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 18 "super_l.y"
{
  struct CodeNode *code_node;
  char* identifier_val;
  int number_val;
 }
/* Line 1529 of yacc.c.  */
#line 151 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

