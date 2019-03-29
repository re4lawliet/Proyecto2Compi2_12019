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

">=" return 'RMayorIgual'
"<=" return 'RMenorIgual'
"!=" return 'RDiferente'
//******************************> Palabras Reservadas
"class" return 'Rclass'
"import" return 'Rimport'

"private" return 'Rprivate'
"protected" return 'Rprotected'
"public" return 'Rpublic'

"int" return 'Rint'
"double" return 'Rdouble'
"char" return 'Rchar'
"boolean" return 'Rboolean'
"String" return 'RString'

"main" return 'Rmain'
"void" return 'Rvoid'
"extends" return 'Rextends'
"this" return 'Rthis'

"abstract" return 'Rasbstract'
"break" return 'Rbreak'
"case" return 'R_case'
"catch" return 'R_catch'
"continue" return 'R_continue'
"default" return 'R_default'
"do" return 'R_do'
"else" return 'R_else'
"for" return 'R_for'
"final" return 'R_final'
"graph_dot" return 'R_graph_dot'
"if" return 'R_if'
"instanceof" return 'R_instanceof'
"message" return 'R_message'
"new" return 'Rnew'
"Object" return 'R_object'

"println" return 'R_println'
"return" return 'R_return'
"read_console" return 'R_read_console'
"read_file" return 'R_read_file'
"static" return 'Rstatic'
"str" return 'R_str'
"super" return 'R_super'
"switch" return 'R_switch'

"toChar" return 'R_toChar'
"toDouble" return 'R_toDouble'
"toString" return 'R_toString'
"toInt" return 'R_toInt'
"try" return 'R_try'
"while" return 'R_while'
"write_file" return 'R_write_file'


//Operadores

"||" return 'ROr'
"|^" return 'RXor'
"&&" return 'RAnd'
"!"  return 'neg'

">" return 'RMayor'
"<" return 'RMenor'
"==" return 'RIgualigual'

"+"                   return 'Rmas'
"-"                   return 'Rmenos'
"*"                   return 'Rpor'
"/"                   return 'Rdiv'
"^"                   return 'Rpot'
"%"                   return 'Rmod'

"++" return 'Rincremento'
"--" return 'Rdecremento'

"?" return 'RInterrogacion'
":" return 'RDosPuntos'
";" return 'fin'
"," return 'coma'
"." return 'punto'

"true"  return 'Rtrue'
"false" return 'Rfalse'
"null"  return 'Rnull'

"{"                   return 'alla'
"}"                   return 'clla'
"["                   return 'acor'
"]"                   return 'ccor'
"("                   return 'apar'
")"                   return 'cpar'
"="                   return 'Rigual'



"-"?[0-9]+("."[0-9]+)?\b            return 'numero'
[a-zA-Z]([0-9A-Za-z]|"_")*          return 'identi'
(\"[^\"]+\")                        return 'Tstring'
(' [a-zñA-ZÑ] | [0-9] ')            return 'Tchar'


\s+                  /* skip whitespace */
<<EOF>>               return 'EOF'
.                     {
    var error= new Error(yytext, yylineno, 0, "Lexico", "Error Lexico en: "+yytext);
    ListaErrores.push(error);}

/lex

/* operator associations and precedence */

%left '+' '-'
%left '*' '/'
%left '^'
%right '!'
%right '%'
%left UMINUS

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

S:INICIO EOF
        { 
            raizArbol=$1;
            var salida={
                raiz:raizArbol,
                Errores: ListaErrores
            };
            ListaErrores = [];
            return salida;
        };

INICIO:LISTA_CLASES
{
    var tmp = new Nodo("INICIO","noterminal",yylineno,0,countNodo);
    tmp.addHijo($1);
    countNodo++;
    $$ = tmp;
};


LISTA_CLASES:LISTA_CLASES DEFCLASE
{
    var tmp = $1;
    tmp.addHijo($2);
    $$ = tmp;
}
| DEFCLASE
{
    var tmp = new Nodo("LISTA_CLASES","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

DEFCLASE: IMPORTAR
{
    var tmp = new Nodo("DEFCLASE","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
}
| CLASE
{
    var tmp = new Nodo("DEFCLASE","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

//-----------------------------------------------------IMPORTAR
IMPORTAR: Rimport apar Tstring cpar fin
{
    var tmp = new Nodo("IMPORTAR",$3.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
};

//-----------------------------------------------------CLASE
CLASE: VISIBILIDAD Rclass identi alla FUNCIONES clla
{
    var tmp = new Nodo("CLASE","noterminal",yylineno,0,countNodo);
    countNodo++;

    var tmp2 = new Nodo("identi",$3.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo($5);

    $$ = tmp;

}
| VISIBILIDAD Rclass identi Rextends identi alla FUNCIONES clla
{
    var tmp = new Nodo("CLASE","noterminal",yylineno,0,countNodo);
    countNodo++;

    var tmp2 = new Nodo("identi",$3.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    var tmp3 = new Nodo("identi",$5.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo(tmp3);
    tmp.addHijo($7);

    $$ = tmp;
};

//-----------------------------------------------------FUNCION Y GLOBALES
FUNCIONES:FUNCIONES FUNCION
{
    var tmp = $1;
    tmp.addHijo($2);
    $$ = tmp;
}
|  FUNCION
{
    var tmp = new Nodo("FUNCIONES","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

FUNCION: DEF_ATRIBUTO fin
{
    $$ = $1;
}
| DEF_ARRAY fin
{
   $$ = $1;
}
| DEF_FUNCTION
{
    $$ = $1;
}
| error fin
{
    var error= new Error(yytext, yylineno, 0, "Sintactico", "Error Sintactico en: "+yytext);
    ListaErrores.push(error);}
};

//-----------------------------------------------------DEF_ATRIBUTO

DEF_ATRIBUTO: VISIBILIDAD Rstatic DEF_TIPO identi Rigual OR
{
    var tmp = new Nodo("DEF_ATRIBUTO","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("STATIC","static",yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("identi",$4.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo($3);
    tmp.addHijo(tmp3);
    tmp.addHijo($6);

    $$ = tmp;
}
| VISIBILIDAD DEF_TIPO identi Rigual OR
{
    var tmp = new Nodo("DEF_ATRIBUTO","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("NO_STATIC","no_static",yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("identi",$3.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo($2);
    tmp.addHijo(tmp3);
    tmp.addHijo($5);

    $$ = tmp;

}
|  VISIBILIDAD Rstatic DEF_TIPO identi
{
    var tmp = new Nodo("DEF_ATRIBUTO","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("STATIC","static",yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("identi",$4.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo($3);
    tmp.addHijo(tmp3);

    $$ = tmp;
}
| VISIBILIDAD DEF_TIPO identi
{
    var tmp = new Nodo("DEF_ATRIBUTO","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("NO_STATIC","no_static",yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("identi",$3.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo($2);
    tmp.addHijo(tmp3);

    $$ = tmp;

};

//-----------------------------------------------------DEF_ARRAY

DEF_ARRAY: VISIBILIDAD DEF_TIPO identi LISTDIM
{
    var tmp = new Nodo("DEF_ARRAY","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("NO_STATIC","no_static",yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("identi",$3.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo($2);
    tmp.addHijo(tmp3);
    tmp.addHijo($4);

    $$ = tmp;
}
| VISIBILIDAD Rstatic DEF_TIPO identi LISTDIM
{
    var tmp = new Nodo("DEF_ARRAY","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("STATIC","static",yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("identi",$4.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo($3);
    tmp.addHijo(tmp3);
    tmp.addHijo($5);

    $$ = tmp;
}
|  VISIBILIDAD DEF_TIPO identi LISTDIM Rigual OR
{
    var tmp = new Nodo("DEF_ARRAY","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("NO_STATIC","no_static",yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("identi",$3.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo($2);
    tmp.addHijo(tmp3);
    tmp.addHijo($4);
    tmp.addHijo($6);
    $$ = tmp;
}
| VISIBILIDAD Rstatic DEF_TIPO identi LISTDIM Rigual OR
{
    var tmp = new Nodo("DEF_ARRAY","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("STATIC","static",yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("identi",$4.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo($3);
    tmp.addHijo(tmp3);
    tmp.addHijo($5);
    tmp.addHijo($7);

    $$ = tmp;
};

LISTDIM: LISTDIM DIM
{
    var tmp = $1;
    tmp.addHijo($2);
    $$ = tmp;
}
| DIM
{
    var tmp = new Nodo("LISTA_DIMENSIONES","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

DIM: acor ccor
{
    var tmp = new Nodo("DIMENSION","noterminal",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
};

//-----------------------------------------------------DEF_FUNCTION


DEF_FUNCTION: VISIBILIDAD DEF_TIPO identi apar LISTA_PARAM cpar alla clla
{
    var tmp = new Nodo("DEF_FUNCTION","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("NO_STATIC","no_static",yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("identi",$3.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo($2);
    tmp.addHijo(tmp3);
    tmp.addHijo($5);

    $$ = tmp;
}
| VISIBILIDAD DEF_TIPO identi apar cpar alla clla
{
    var tmp = new Nodo("DEF_FUNCTION","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("NO_STATIC","no_static",yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("identi",$3.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    var tmp4 = new Nodo("LISTA_PARAM","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo($2);
    tmp.addHijo(tmp3);
    tmp.addHijo(tmp4);

    $$ = tmp;
}
| VISIBILIDAD Rstatic DEF_TIPO Rmain apar cpar alla clla
{
    var tmp = new Nodo("DEF_FUNCTION_MAIN","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("STATIC","static",yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("main","main",yylineno,0,countNodo);
    countNodo++;
    var tmp4 = new Nodo("LISTA_PARAM","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo($3);
    tmp.addHijo(tmp3);
    tmp.addHijo(tmp4);

    $$ = tmp;
}
| VISIBILIDAD identi apar LISTA_PARAM cpar alla clla
{
    var tmp = new Nodo("DEF_FUNCTION_CONSTRUCT","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("NO_STATIC","no_static",yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("identi",$2.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo(tmp3);
    tmp.addHijo($4);

    $$ = tmp;

}
| VISIBILIDAD identi apar  cpar alla clla
{
    var tmp = new Nodo("DEF_FUNCTION_CONSTRUCT","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("NO_STATIC","no_static",yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("identi",$2.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    var tmp4 = new Nodo("LISTA_PARAM","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo(tmp3);
    tmp.addHijo(tmp4);

    $$ = tmp;


};

LISTA_PARAM: LISTA_PARAM coma PARAMETRO
{
    var tmp = $1;
    tmp.addHijo($3);
    $$ = tmp;
}
| PARAMETRO
{
    var tmp = new Nodo("LISTA_PARAM","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

PARAMETRO: DEF_TIPO identi LISTDIM
{
    var tmp = new Nodo("PARAM_ARRAY","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("identi",$2.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);
    tmp.addHijo($3);

    $$ = tmp;
}
| DEF_TIPO identi
{
    var tmp = new Nodo("PARAM","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("identi",$2.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo(tmp2);

    $$ = tmp;
};













//-----------------------------------------------------DEF_TIPO
DEF_TIPO: Rint
{
    var tmp = new Nodo("DEF_TIPO","int",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| Rdouble
{
    var tmp = new Nodo("DEF_TIPO","double",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| Rchar
{
    var tmp = new Nodo("DEF_TIPO","char",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| Rboolean
{   
    var tmp = new Nodo("DEF_TIPO","boolean",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| RString
{
    var tmp = new Nodo("DEF_TIPO","string",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| identi
{
    var tmp = new Nodo("DEF_TIPO",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| Rvoid
{
    var tmp = new Nodo("DEF_TIPO","void",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
};

//-----------------------------------------------------VISIBILIDAD
VISIBILIDAD:Rpublic
{
    console.log("entro al Inicio");
    var tmp = new Nodo("publico",yytext.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| Rprivate
{
    var tmp = new Nodo("privado",yytext.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| Rprotected
{
    var tmp = new Nodo("protegido",yytext.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
|
{
    var tmp = new Nodo("publico","publico",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
};













//-------------------------------------------------------------------EVALUAR EXP 

OR : OR ROr XOR
{
    var tmp = new Nodo("OR","or",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| XOR
{
    var tmp = new Nodo("OR","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

XOR: XOR RXor AND
{
    var tmp = new Nodo("XOR","xor",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
|AND 
{
    var tmp = new Nodo("XOR","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

AND: AND RAnd NOT
{
    var tmp = new Nodo("AND","and",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| NOT
{
    var tmp = new Nodo("AND","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

NOT: neg EXP
{
    var tmp = new Nodo("NOT","not",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($2);
    $$ = tmp;
}
| EXP
{
    var tmp = new Nodo("NOT","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

EXP: E RMayor E
{
    var tmp = new Nodo("EXP",">",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| E RMenor E
{
    var tmp = new Nodo("EXP","<",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| E RMayorIgual E
{
    var tmp = new Nodo("EXP",">=",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| E RMenorIgual E
{
    var tmp = new Nodo("EXP","<=",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| E RDiferente E
{
    var tmp = new Nodo("EXP","!=",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| E RIgualigual E
{
    var tmp = new Nodo("EXP","==",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| E
{
    var tmp = new Nodo("EXP","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};


E: E Rmas T
{
    var tmp = new Nodo("E","+",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| E Rmenos T
{
    var tmp = new Nodo("E","-",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| T
{
    var tmp = new Nodo("E","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};


T: T Rpor F 
{
    var tmp = new Nodo("T","*",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| T Rdiv F
{
    var tmp = new Nodo("T","/",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| F
{
    var tmp = new Nodo("T","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

F: F Rpot G 
{
    var tmp = new Nodo("F","^",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| F Rmod G 
{
    var tmp = new Nodo("F","%",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| G
{
    var tmp = new Nodo("F","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

G: U Rincremento
{
    var tmp = new Nodo("G","++",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
}
| U Rdecremento
{
    var tmp = new Nodo("G","--",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
}
| U 
{
    var tmp = new Nodo("G","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

U: Rmenos UU 
{
    var tmp = new Nodo("E","-",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($2);
    $$ = tmp;
}
| UU
{
    var tmp = new Nodo("E","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

UU: numero
{
    var tmp = new Nodo("U",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| Tchar
{
    var tmp = new Nodo("U",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| Tstring
{
    var tmp = new Nodo("U",$1.replace("\"","").replace("\"","").replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| Rtrue
{
    var tmp = new Nodo("U",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| Rfalse
{
    var tmp = new Nodo("U",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| Rnull
{
    var tmp = new Nodo("U","-1",yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
}
| apar OR cpar
{
    var tmp = new Nodo("U","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($2);

    $$ = tmp;
}
| INSTANCIA
{
    var tmp = new Nodo("U","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);

    $$ = tmp;
}
| INSTANCIA_ARRAY
{
    var tmp = new Nodo("U","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);

    $$ = tmp;
}
| LISTATTRIB
{
    var tmp = new Nodo("U","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);

    $$ = tmp;
};


//-----------------------------------------------------INSTANCIA
INSTANCIA: Rnew LLAMADA_METODO
{
    var tmp = new Nodo("INSTANCIA","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($2);

    $$ = tmp;
};

//-----------------------------------------------------LLAMADA_METODO
LLAMADA_METODO: identi apar LISTA_EXP cpar
{
    var tmp = new Nodo("LLAMADA_METODO","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("identi",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo(tmp2);
    tmp.addHijo($3);

    $$ = tmp;
}
| identi apar cpar
{
    var tmp = new Nodo("LLAMADA_METODO","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("identi",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    var tmp3 = new Nodo("LISTA_EXP","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo(tmp2);
    tmp.addHijo(tmp3);
    
    $$ = tmp;
}
};

LISTA_EXP: LISTA_EXP coma OR
{
    var tmp = $1;
    tmp.addHijo($3);
    $$ = tmp;
}
| OR
{
    var tmp = new Nodo("LISTA_EXP","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

//-----------------------------------------------------INSTANCIA_ARRAY
INSTANCIA_ARRAY: Rnew DEF_TIPO INICIO_DIMEN
{
    var tmp = new Nodo("INSTANCIA_ARRAY","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($2);
    tmp.addHijo($3);

    $$ = tmp;
};

INICIO_DIMEN: INICIO_DIMEN DIMEN
{
    var tmp = $1;
    tmp.addHijo($2);
    $$ = tmp;
}
| DIMEN
{
    var tmp = new Nodo("INICIO_DIMEN","noterminal",yylineno,0,countNodo);
    countNodo++;
    tmp.addHijo($1);
    $$ = tmp;
};

DIMEN: acor numero ccor
{
    var tmp = new Nodo("DIMEN",$2.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;
    $$ = tmp;
};
//-----------------------------------------------------LLAMADA_ARRAY
ARRAY: identi INICIO_DIMEN
{
    var tmp = new Nodo("ARRAY","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("identi",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo(tmp2);
    tmp.addHijo($2);

    $$ = tmp;
};

//-----------------------------------------------------LISTATTRIB
LISTATTRIB: LISTATTRIB punto ATRIBUTO 
{
    var tmp = new Nodo("LISTATTRIB_0","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    tmp.addHijo($3);
    $$ = tmp;
}
| ATRIB
{
    var tmp = new Nodo("LISTATTRIB_1","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    $$ = tmp;

};

ATRIBUTO: identi
{
    var tmp = new Nodo("ATRIBUTO","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("identi",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo(tmp2);
    $$ = tmp;
}
| ARRAY 
{
    var tmp = new Nodo("ATRIBUTO","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    $$ = tmp;
}
| LLAMADA_METODO
{
    var tmp = new Nodo("ATRIBUTO","noterminal",yylineno,0,countNodo);
    countNodo++;
    
    tmp.addHijo($1);
    $$ = tmp;
};

ATRIB: Rthis 
{
    var tmp = new Nodo("ATRIB","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("ATRIB","this",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo(tmp2);
    $$ = tmp;
}
| identi
{
    var tmp = new Nodo("ATRIB","noterminal",yylineno,0,countNodo);
    countNodo++;
    var tmp2 = new Nodo("identi",$1.replace("\"","").replace("\"",""),yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo(tmp2);
    $$ = tmp;
}
| ARRAY 
{
    var tmp = new Nodo("ATRIB","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    $$ = tmp;
}
| LLAMADA_METODO
{
    var tmp = new Nodo("ATRIB","noterminal",yylineno,0,countNodo);
    countNodo++;

    tmp.addHijo($1);
    $$ = tmp;
};




// FALTA LISTA_ATRIB