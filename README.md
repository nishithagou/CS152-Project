# CS152-Project

Language Name - SUPER-L <br>
Program Extension - .abc <br>
Compiler - BIG-LC <br>


| Language Feature | Code Example |
| ------------- | ------------- | 
| Integer scalar variables | x: int; <br> one: int; |
| One-dimensional arrays of integers | a : int array[10]; <br> b : int array[10]; <br> a &= b; <br> a[0] &= 1; |
| Variable Declaration | x : int; <br> a : int array[5]; <br> var12_ : int; |
| Assignment statement | x : int; <br> x &= 4; <br> x &= x + 1; |
| Addition | x &= x+1; <br> d &= a + b + 30; |
| Subtraction | x &= x - y; <br> d &=  a - b - 3; |
| Multiplication | x &= cat * dog; <br> d &= x * y * cat; |
| Division | x &= x / y; <br> d &= a / b / c; |
| Modulus | remainder &= x % y; |
| Less than | if x < y then <br>    write x; <br> endif; |
| Greater than | if x > y then <br>   x &= x + 1; <br> endif;|
| Equal to? | if x == y then <br>   x &= x + 1; <br> endif; |
| Less than or equal to | x <= y |
| Greater than or equal to | x >= y |
| Not equal to | if x != y then <br>   x &= 0; <br> endif;|
| While loop | while x < y loopbegin <br>   x &= x - 1; <br> loopend; |
| If-then-else statement | if p < 10 then <br>   write p; <br> else <br>   write q; <br> endif;|
| Read statement | read p; <br> if p < 10 then<br>   p &= p + 5; <br> endif; <br> write p; |
| Write statement | a &= 5; <br> a &= a - 3; <br> write a; |
| Function (taking multiple scalar arguments) | function main; <br> beginparameters <br>     a : int; <br> endparameters <br> beginlocalvars <br> endlocalvars <br> bodystart <br>    if a < 5 then return 10; <br>   endif; <br> endbody <br> |
| Comments | ##comment |
| Return Statement | if dog != cat then <br>  return dog; <br> endif; |

| Symbol in Language | Token Name |
| ------------- | ------------- | 
| ( | L_PAREN |
| ) | R_PAREN |
| \[ | R_SQ_BRACK |
| \] | L_SQ_BRACK |
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
| beginlocalvars | BEGIN_LOCALS_VARS | 
| endlocalvars | END_LOCALS_VARS |
| bodystart | BODY_START |
| bodyend | BODY_END |
| int | INTEGER |
| array| ARRAY |
| if | IF |
| then | THEN |
| endif | ENDIF |
| else | ELSE |
| while | WHILE |
| for | FOR |
| loopbegin | LOOP_BEGIN |
| loopend | LOOP_END |
| read | READ |
| write | WRITE |
| and | AND |
| or | OR |
| not | NOT |
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
if <br>
then <br>
else if <br>
endif <br>
else <br>
while <br>
loopbegin <br>
loopend <br>
read <br>
write <br>
and <br>
or <br>
not <br>
return <br>
break <br>

Additional Specifications:  <br>
Identifier names use only begin with letters. They cannot begin with any special characters (@,#,$.%.^.&.*) or numbers, and cannot contain any spaces. Identifier names also cannot contain any special characters (@,#,$.%.^.&.*). Identifier names cannot end with an underscore '_' or '&'. <br>
Language is case sensitive, all reserved words should be all lowercase. <br>
To represent a newline, use \n. <br>
A main method with no arguments is necessary for a program to function. <br>
Functions can accept any number of arguments passed by value. <br>
Body of all functions, if-then-else statements, and while loops will be indented. Parameters and local variables will also be indented. <br>
Comments begin with ##, end when a newline is detected <br>







