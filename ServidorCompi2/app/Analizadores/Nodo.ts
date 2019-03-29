require("collections/shim-array");
require("collections/listen/array-changes");

export class Nodo {
    public etiqueta: string;
    public lexema: string;
    public linea: number;
    public columna: number;
    public id: number;
    public hijos: Array<Nodo>;
    public Value: string;
    public tipoDato: string;

    constructor(etq: string, lex: string, linea: number, columna: number, ide: number) {
        this.etiqueta = etq;
        this.lexema = lex;
        this.linea = linea;
        this.columna = columna;
        this.id=ide;
        this.hijos = new Array<Nodo>();
        this.Value="";
        this.tipoDato="";
    }

    addHijo (nuevo:Nodo):void{
        this.hijos.push(nuevo);
    }

    NodoC1(etq: string, lex: string, linea: number, columna: number, ide: number, val: string): void {

        this.etiqueta = etq;
        this.lexema = lex;
        this.linea = linea;
        this.columna = columna;
        this.id=ide;
        this.Value=val;
        this.hijos = new Array<Nodo>(); 
    }

}


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