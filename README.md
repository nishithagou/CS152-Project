# CS152-Project

Language Name - SUPER-L <br>
Program Extension - .abc <br>
Compiler - BIG-LC <br>


| Language Feature | Code Example |
| ------------- | ------------- | 
| Integer scalar variables | int x; <br> int one, two; #declaring multiple vars on same line |
| One-dimensional arrays of integers | a : int array[10]; <br> b : int array[10]; <br> a &= b; <br> a[0] &= 1; |
| Variable Declaration | x : int; <br> a : int array[5]; <br> var12_ : int; |
| Assignment statement | x : int; <br> x &= 4; <br> x &= x + 1; |
| Addition | x + y, a + b + c |
| Subtraction | x - y, a - b - c |
| Multiplication | x * y, a * b * c |
| Division | x / y, a / b / c |
| Modulus | x % y |
| Less than | x < y |
| Greater than | x > y|
| Equal to? | x == y |
| Less than or equal to | x <= y |
| Greater than or equal to | x >= y |
| Not equal to | x != y |
| While loop | while x < y <br> loopbegin <br>   x = x - 1; <br> loopend; |
| If-then-else statement | if p < 10 then write p; <br> endif;|
| Read statement | read p; <br> if p < 10 then p &= p + 5 <br> endif; <br> write p; |
| Write statement | a = 5; a = a - 3; write a |
| Function (taking multiple scalar arguments) | function main; <br> beginparameters <br>     a : int; <br> endparameters <br> beginlocalvars <br> endlocalvars <br> bodystart <br>    if a < 5 then return 10; <br>   endif; <br> endbody <br> |
| Comments | ##comment |

| Symbol in Language | Token Name |
| ------------- | ------------- | 
| ( | L_PAREN |
| ) | R_PAREN |
| + | PLUS |
| - | MINUS |
| * | MULT |
| / | DIV |
| % | MOD |
| &= | ASSIGNMENT |
| : | COLON |
| ; | SEMICOLON |
| , | COMMA |
| < | LESS_THAN |
| > | GREAT_THAN |
| <= | LESS_THAN_EQ |
| >= | GREAT_THAN_EQ |
| == | EQ_TO |
| != | NOT_EQ |
| function | FUNCTION |
| beginparameters | BEGIN_PARAMS |
| endparameters | END_PARAMS |
| beginlocalvars | BEGIN_LOCALS | 
| endlocalvars | END_LOCALS |
| bodystart | BODY_START |
| bodyend | BODY_END |
| int | INTEGER |
| array| ARRAY |
| of | OF |
| if | IF |
| then | THEN |
| endif | ENDIF |
| else | ELSE |
| while | WHILE |
| do | DO |
| for | FOR |
| loopbegin | LOOP_BEGIN |
| loopend | LOOP_END |
| continue | CONTINUE |
| read | READ |
| write | WRITE |
| and | AND |
| or | OR |
| not | NOT |
| true | TRUE |
| false | FALSE |
| return | RETURN |


reserved words: <br>
function <br>
beginparameters <br>
endparameters <br>
beginlocalvars <br>
endlocalvars <br>
bodystart <br>
bodyend <br>
int <br>
array <br>
of <br>
if <br>
then <br>
else if <br>
endif <br>
else <br>
while <br>
do <br>
loopbegin <br>
loopend <br>
continue <br>
read <br>
write <br>
and <br>
or <br>
not <br>
true <br>
false <br>
return <br>

Additional Specifications:  <br>
Variable names use only lowercase letters, cannot begin with an '@' or number, and cannot contain any spaces. Identifier names can however contain underscores, '@' symbols, and numbers within the name.  <br>
Language is case sensitive, all reserved words should be all lowercase. <br>
To represent a newline, use \n. <br>
A main method with no arguments is necessary for a program to function. <br>
Functions can accept any number of arguments passed by value. <br>
Body of all functions will be indented. <br>
Comments begin with ##, end when a newline is detected <br>







