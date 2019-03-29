"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
require("collections/shim-array");
require("collections/listen/array-changes");
var CompilarAltoNivel = /** @class */ (function () {
    //Metodo Constructor
    function CompilarAltoNivel(raiz) {
        this.raizArbol = raiz;
        this.SalidaConsolaAltoNivel = "********* Salida Consola ************\n";
        this.ErroresSemanticos = "********* ERRORES SEMANTICOS ************\n";
        this.SalidaC3D = "********* SALIDA C3D ************\n";
    }
    //Metodos Void
    CompilarAltoNivel.prototype.AnalizarAltoNivel = function () {
        try {
            this.recorrido(this.raizArbol);
        }
        catch (err) {
            this.SalidaConsolaError("<ERROR><Catch>[1]Lexema:'" + "AnalizadorAltoNivel()" + "' D:" + err + " <Semantico>");
        }
    };
    CompilarAltoNivel.prototype.recorrido = function (raiz) {
        var _this = this;
        try {
            if (raiz.etiqueta == "INICIO") {
                this.SalidaConsola("ENTRO a inicio Recorrido");
                this.recorrido(raiz.hijos[0]);
            }
            else if (raiz.etiqueta == "LISTA_CLASES") {
                raiz.hijos.forEach(function (element) {
                    _this.LeerListaClases(element);
                });
            }
        }
        catch (err) {
            this.SalidaConsolaError("<ERROR><Catch>[2]Lexema:'" + "recorrido1()" + "' D:" + err + " <Semantico>");
        }
    };
    CompilarAltoNivel.prototype.LeerListaClases = function (raiz) {
        try {
            if (raiz.etiqueta == "DEFCLASE") {
                this.LeerListaClases(raiz.hijos[0]);
            }
            else if (raiz.etiqueta == "IMPORTAR") {
                this.LeerIMPORTAR(raiz);
            }
            else if (raiz.etiqueta == "CLASE") {
                this.LeerCLASE(raiz);
            }
        }
        catch (err) {
            this.SalidaConsolaError("<ERROR><Catch>[3]Lexema:'" + "LeerListaClases()" + "' D:" + err + " <Semantico>");
        }
    };
    CompilarAltoNivel.prototype.LeerIMPORTAR = function (raiz) {
        try {
            var path = raiz.lexema;
            this.SalidaConsola("La Path de Importacion es: " + path);
        }
        catch (err) {
            this.SalidaConsolaError("<ERROR><Catch>[4]Lexema:'" + "LeerImportar()" + "' D:" + err + " <Semantico>");
        }
    };
    CompilarAltoNivel.prototype.LeerCLASE = function (raiz) {
        try {
            this.SalidaConsola("LeerCLASE");
            //Si el Arbol tiene 3 Hijos es Una clase Normal
            if (raiz.hijos.length == 3) {
                this.SalidaConsola("CLASE NORMA");
                //Si el Arbol tiene 4 Hijos es Una clase Heredada
            }
            else if (raiz.hijos.length == 4) {
                this.SalidaConsola("CLASE HEREDADA");
                this.EscribirC3D("t1=1*1;");
            }
        }
        catch (err) {
            this.SalidaConsolaError("<ERROR><Catch>[5]Lexema:'" + "LeerClase()" + "' D:" + err + " <Semantico>");
        }
    };
    CompilarAltoNivel.prototype.SalidaConsola = function (texto) {
        this.SalidaConsolaAltoNivel += texto + "\n";
    };
    CompilarAltoNivel.prototype.SalidaConsolaError = function (texto) {
        this.ErroresSemanticos += texto + "\n";
    };
    CompilarAltoNivel.prototype.EscribirC3D = function (texto) {
        this.SalidaC3D += texto + "\n";
    };
    return CompilarAltoNivel;
}());
exports.CompilarAltoNivel = CompilarAltoNivel;
