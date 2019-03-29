"use strict";
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
/*
var Nodoprueba = new Nodo();
Nodoprueba.NodoS("hola");
var hijo = new Nodo();
hijo.NodoS("hijo");
Nodoprueba.hijos.push(;
var nodito:any = Nodoprueba.hijos.shift();
console.log(nodito.valor);
*/
/*
function Nodo(val: string):void {

    this.valor = val;
    this.id = 0;
    this.linea = 0;
    this.columna = 0;
    this.hijos = new Hijos();
}

function Nodo(val:string,id:number,linea:number,columna:number):void {

    this.valor = val;
    this.id = id;
    this.linea = linea;
    this.columna = columna;
    this.hijos = new Hijos();
}

*/ 
