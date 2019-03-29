"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
require("typescript-require");
require("collections/shim-array");
require("collections/listen/array-changes");
var Graficador = /** @class */ (function () {
    function Graficador() {
        this.CadenaDot = "";
    }
    /**
     *
     * @param raiz
     */
    Graficador.prototype.GraficarAST = function (raiz) {
        //Creo una carpeta en /home/usuario/SalidasDot, en donde va estar todo
        var dir = "/Users/carlosmonterroso/Desktop";
        //Rutas para el .dot y la imagen .png
        var ruta_dot = "/Users/carlosmonterroso/Desktop/ast.dot";
        var ruta_png = "/Users/carlosmonterroso/Desktop/ast.png";
        //Arma el contenido del .dot
        this.armar_Cuerpo_dot(raiz, ruta_dot);
        var fs = require('fs');
        fs.writeFile(ruta_dot, "", function (error) {
            if (error)
                console.log(error);
        });
        //Genera el archivo .dot y su imagen .png
        this.crearGrafo(ruta_dot, ruta_png);
        //Abre la imagen resultante .png
        this.autoAbrir(ruta_png);
    };
    //Este metodo se puede usar para graficar cualquier grafo
    //debido a q solo necesita al ruta del dot y la ruta de la salida->imagen
    Graficador.prototype.crearGrafo = function (ruta_dot, ruta_png) {
        var fs = require('fs');
        var texto = "";
        fs.readFile(ruta_dot, function (error, datos) {
            if (error)
                console.log(error);
            else
                texto = datos.toString();
        });
        fs.appendFile(ruta_dot, this.CadenaDot + "}", function (error) {
            if (error)
                console.log(error);
            else
                console.log('El archivo fue creado');
        });
        var tParam = "-Tpng";
        var tOParam = "-o";
        var cmd = "dot " + tParam + " " + ruta_dot + " " + tOParam + " " + ruta_png;
        // On Windows Only ...
        //const { spawn } = require('child_process');
        //const bat = spawn('cmd.exe', ['/c', cmd]);
    };
    //Este metodo es generico
    //Porque solo necesita un nodo para crear el .dot
    Graficador.prototype.armar_Cuerpo_dot = function (raiz, ruta_dot) {
        var contador = 0;
        var buffer = require('fs');
        this.CadenaDot += "\ndigraph G {\r\nnode [shape=circle, style=filled, color=yellow, fontcolor=black];\n";
        /*buffer.appendFile(ruta_dot, "\ndigraph G {\r\nnode [shape=circle, style=filled, color=yellow, fontcolor=black];\n", (error: any) => {
            if (error) {
                throw error;
            }
        });*/
        this.CadenaDot += this.listarNodos(raiz, ruta_dot, buffer, contador, "");
    };
    //Este metodo es generico
    //Porque solo necesita un nodo para lista y generar una porcion
    //de lo que sera el fichero .dot
    Graficador.prototype.listarNodos = function (praiz, ruta_dot, buffer, contador, acum) {
        //graphviz+="node"+contador+"[label=\""+praiz.valor+"\"];\n";
        var cont = contador;
        if (praiz.lexema != "noterminal") {
            acum += "node" + praiz.id + "[label=\"" + praiz.lexema + "\"];\n";
            /*buffer.appendFile(ruta_dot, "node" + praiz.id + "[label=\"" + praiz.lexema + "\"];\n", (error: any) => {
                if (error) {
                    throw error;
                }
    
            });*/
        }
        else {
            acum += "node" + praiz.id + "[label=\"" + praiz.etiqueta + "\"];\n";
            /*buffer.appendFile(ruta_dot, "node" + praiz.id + "[label=\"" + praiz.etiqueta + "\"];\n", (error: any) => {
                if (error) {
                    throw error;
                }
    
            });*/
        }
        praiz.hijos.forEach(function (value) {
            cont++;
            acum += "\"node" + praiz.id + "\"->";
            acum += "\"node" + value.id + "\";\n";
            acum += Graficador.prototype.listarNodos(value, ruta_dot, buffer, cont, "");
            cont++;
        });
        return acum;
    };
    //Este metodo es generico
    //Porque solo necesita un nodo para lista y generar una porcion
    //de lo que sera el fichero .dot
    Graficador.prototype.enlazarNodos = function (pRaiz, ruta_dot, buffer) {
        var relacion = "";
        pRaiz.hijos.forEach(function (value) {
            relacion += "\"node" + pRaiz.id + "\"->";
            relacion += "\"node" + value.id + "\";\n";
            buffer.appendFile(ruta_dot, relacion, function (error) {
                if (error) {
                    throw error;
                }
            });
            Graficador.prototype.enlazarNodos(value, ruta_dot, buffer);
        });
        //this.CadenaDot+= relacion;
    };
    //Este metodo es generico
    //Por que abre un fichero, archivo, etc. en base a la ruta
    //Lo abre con el programa predeterminado por el sistema
    Graficador.prototype.autoAbrir = function (ruta) {
        // On Windows Only ...
        //const { spawn } = require('child_process');
        //const bat = spawn('cmd.exe', ['/c', ruta]);
        return true;
    };
    //Este metodo es generico
    //Porque crea un archivo plano en base a la ruta y el contenido que se le pase
    /**
     *
     * @param Ruta
     * @param Contenido
     */
    Graficador.prototype.CrearDocumento = function (Ruta, Contenido) {
        var fs = require('fs');
        fs.writeFile(Ruta, Contenido, function (error) {
            if (error) {
                throw error;
            }
            console.log('El archivo ha sido creado exitosamente.');
        });
    };
    return Graficador;
}());
exports.Graficador = Graficador;
