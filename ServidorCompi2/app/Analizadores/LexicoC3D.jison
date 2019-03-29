/* description: Parses and executes mathematical expressions. */
%{
    var countNodo=0;
    var raizArbol;

    var Error = /** @class */ (function () {
    function Error(ptoken, plinea, pcolumna, ptipo, desc) {
    this.lexema = ptoken;
    this.linea = plinea + 1;
    this.columna = pcolumna + 1;
    this.tipo = ptipo;
    this.descripcion = desc;
}
    return Error;
}());

var ListaErrores=new Array();

%}
/* lexical grammar */
%lex
%%

">=" return 'mayorigual'
"<=" return 'menorigual'
"!=" return 'diferente'
//******************************> Palabras Reservadas
"P" return 'Stack_Pointer'
"h" return 'Heap_Pointer'
"goto" return 'goto_'
"Stack" return 'Stack_'
"Heap" return 'Heap_'
"void" return 'void_'
"if" return 'IF_'
"printf" return 'printf_'
"call" return 'call_'
"{" return 'leftKey'
"}" return 'rightKey'
"(" return 'leftPar'
")" return 'rightPar'
":" return 'Points'
"[" return 'leftCor'
"]" return 'rightCor'
";" return 'dotcomma'
"=" return 'igual'
"+" return 'mas'
"-" return 'menos'
"*" return 'por'
"/" return 'divs'
"#" return 'mod'
"%" return 'mod'
"," return 'coma'


//Operadores
">" return 'mayor'
"<" return 'menor'
"==" return 'igualigual'

["L"]([0-9]+)                       return 'Label_'
["t"]([0-9]+)                       return 'Temporal_'
"-"?[0-9]+("."[0-9]+)?\b            return 'Numero'
[a-zA-Z]([0-9A-Za-z]|"_")*          return 'Identificador'



\s+                  /* skip whitespace */
<<EOF>>               return 'EOF'
.                     {
    var error= new Error(yytext, yylineno, 0, "Lexico", "Error Lexico en C3D: "+yytext);
    ListaErrores.push(error);}
/lex

/* operator associations and precedence */

%{  

exports.__esModule = true;
require("collections/shim-array");
require("collections/listen/array-changes");
var Nodo = /** @class */ (function () {
    function Nodo(etq, lex, linea, columna, ide) {
        this.etiqueta = etq;
        this.lexema = lex;
        this.linea = linea;
        this.columna = columna;
        this.id = ide;
        this.hijos = new Array();
        this.Value = "";
        this.tipoDato = "";
    }
    Nodo.prototype.addHijo = function (nuevo) {
        this.hijos.push(nuevo);
    };
    Nodo.prototype.NodoC1 = function (etq, lex, linea, columna, ide, val) {
        this.etiqueta = etq;
        this.lexema = lex;
        this.linea = linea;
        this.columna = columna;
        this.id = ide;
        this.Value = val;
        this.hijos = new Array();
    };
    return Nodo;
}());
exports.Nodo = Nodo;

%}
%start S

%% /* language grammar */

S: LISTFUNCTIONS EOF
        { 
            var tmp = new Nodo("START","noterminal",yylineno,0,countNodo);
            countNodo++;
            tmp.addHijo($1);

            raizArbol=tmp;
            var salida={
                raiz:raizArbol,
                Errores: ListaErrores
            };
            ListaErrores = [];
            return salida;
        };

LISTFUNCTIONS:FUNCTION LISTFUNCTIONS
{
    var tmp = new Nodo("LISTFUNCTIONS","noterminal",yylineno,0,countNodo);
    tmp.addHijo($1);
    tmp.addHijo($2);
    countNodo++;
    $$ = tmp;
}
| FUNCTION
{
    var tmp = new Nodo("LISTFUNCTIONS","noterminal",yylineno,0,countNodo);
    tmp.addHijo($1);
    countNodo++;
    $$ = tmp;
};

FUNCTION: void_ ID leftPar rightPar leftKey SENTENCES rightKey
{
    var tmp = new Nodo("FUNCTION","noterminal",yylineno,0,countNodo);
    tmp.addHijo($2);
    tmp.addHijo($6);
    countNodo++;
    $$ = tmp;
};

ID: Identificador{
    var tmp = new Nodo("ID",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
};

SENTENCES: SENTENCE SENTENCES
{
    var tmp = new Nodo("SENTENCES","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($2);
    $$ = tmp;
}
| SENTENCE
{  
    var tmp = new Nodo("SENTENCES","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

SENTENCE: ASIGNATION dotcomma
{
    var tmp = new Nodo("SENTENCE","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
}
| GOTO 
{
    var tmp = new Nodo("SENTENCE","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
}
| CONDITION
{
    var tmp = new Nodo("SENTENCE","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
}
| LABEL Points
{
    var tmp = new Nodo("LABEL","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
}
| CALLMETOD dotcomma
{
    var tmp = new Nodo("SENTENCE","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
}
| PRINTMETOD dotcomma
{
    var tmp = new Nodo("SENTENCE","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

CALLMETOD : call_ ID leftPar rightPar {

    var tmp = new Nodo("CALLMETOD","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($2);
    $$ = tmp;
};

ASIGNATION : STRUCT igual E
{
    var tmp = new Nodo("ASIGNATION","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| POINTERS igual E
{

    var tmp = new Nodo("ASIGNATION","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
};

POINTERS : Heap_Pointer
{
    var tmp = new Nodo("POINTERS","h",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| Stack_Pointer
{
    var tmp = new Nodo("POINTERS","p",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| Temporal_
{
    var tmp = new Nodo("POINTERS",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
};

GOTO : goto_ LABEL dotcomma
{
    var tmp = new Nodo("GOTO","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($2);
    $$ = tmp;
};

LABEL :  Label_
{
    var tmp = new Nodo("LABEL",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
};

CONDITION : IF_ leftPar E SINGCONDITIONAL E rightPar GOTO
{
    var tmp = new Nodo("CONDITION","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($3);
    tmp.addHijo($4);
    tmp.addHijo($5);
    tmp.addHijo($7);
    $$ = tmp;    
};

STRUCT : Heap_ leftCor TEMP rightCor
{
    var tmp = new Nodo("STRUCT","Heap",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($3);
    $$ = tmp;   

}
| Stack_ leftCor TEMP rightCor
{
    var tmp = new Nodo("STRUCT","Stack",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($3);
    $$ = tmp;
};

TEMP : Temporal_
{
    var tmp = new Nodo("F",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
};

E : F SING F
{
    var tmp = new Nodo("E","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.Value="0";
    tmp.addHijo($1);
    tmp.addHijo($2);
    tmp.addHijo($3);
    $$ = tmp;
}
| F
{
    var tmp = new Nodo("E","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.Value="1";
    tmp.addHijo($1);
    $$ = tmp;
};

F : STRUCT
{
    var tmp = new Nodo("STRUCT","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
}
| Temporal_
{
    var tmp = new Nodo("F",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    tmp.tipoDato="0";
    $$ = tmp;
}
| Numero
{
    var tmp = new Nodo("F",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    tmp.tipoDato="1";
    $$ = tmp;
}
| Heap_Pointer
{
    var tmp = new Nodo("F","h",yylineno,0,countNodo);
    countNodo++;
    tmp.tipoDato="2";
    $$ = tmp;
}
| Stack_Pointer
{
    var tmp = new Nodo("F","p",yylineno,0,countNodo);
    countNodo++;
    tmp.tipoDato="3";
    $$ = tmp;
};

SING : mas
{
    var tmp = new Nodo("SING","+",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| menos
{
    var tmp = new Nodo("SING","-",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| por
{
    var tmp = new Nodo("SING","*",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| divs
{
    var tmp = new Nodo("SING","/",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| mod
{
    var tmp = new Nodo("SING","%",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
};

SINGCONDITIONAL : igualigual
{
    var tmp = new Nodo("SINGCONDITIONAL","==",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| diferente
{
    var tmp = new Nodo("SINGCONDITIONAL","!=",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| mayorigual
{
    var tmp = new Nodo("SINGCONDITIONAL",">=",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| menorigual
{
    var tmp = new Nodo("SINGCONDITIONAL","<=",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| menor
{
    var tmp = new Nodo("SINGCONDITIONAL","<",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| mayor
{
    var tmp = new Nodo("SINGCONDITIONAL",">",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
};


PRINTMETOD : printf_ leftPar mod ID coma F rightPar
{
    var tmp = new Nodo("PRINTMETOD","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($4);
    tmp.addHijo($6);
    $$ = tmp;
};