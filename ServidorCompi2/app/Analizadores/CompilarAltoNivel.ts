import { Nodo } from "./Nodo";

require("collections/shim-array");
require("collections/listen/array-changes");

export class CompilarAltoNivel{

    //ATRIBUTOS
    public raizArbol: Nodo;
    public SalidaConsolaAltoNivel: string;
    public ErroresSemanticos: string;
    public SalidaC3D: string;

    //Metodo Constructor
    constructor(raiz:Nodo) { 
        this.raizArbol=raiz;
        this.SalidaConsolaAltoNivel="********* Salida Consola ************\n";
        this.ErroresSemanticos="********* ERRORES SEMANTICOS ************\n";
        this.SalidaC3D="********* SALIDA C3D ************\n";
    }

    //Metodos Void
    AnalizarAltoNivel():void{ 
        try{
            this.recorrido(this.raizArbol);
        }catch (err){
            this.SalidaConsolaError("<ERROR><Catch>[1]Lexema:'"+"AnalizadorAltoNivel()"+"' D:"+err+" <Semantico>");
        }    
    }

    recorrido (raiz:Nodo):void{
        try{
            if(raiz.etiqueta=="INICIO"){
                this.SalidaConsola("ENTRO a inicio Recorrido");
                this.recorrido(raiz.hijos[0]);
            }else if(raiz.etiqueta=="LISTA_CLASES"){
                raiz.hijos.forEach(element => {
                    this.LeerListaClases(element);
                });
            }
        }catch (err){
            this.SalidaConsolaError("<ERROR><Catch>[2]Lexema:'"+"recorrido1()"+"' D:"+err+" <Semantico>");
        }    
    }

    LeerListaClases(raiz:Nodo):void{
        try{
            if(raiz.etiqueta=="DEFCLASE"){
                this.LeerListaClases(raiz.hijos[0]);
            }else if(raiz.etiqueta=="IMPORTAR"){
                this.LeerIMPORTAR(raiz); 
            }else if(raiz.etiqueta=="CLASE"){
                this.LeerCLASE(raiz);
            }
        }catch (err){
            this.SalidaConsolaError("<ERROR><Catch>[3]Lexema:'"+"LeerListaClases()"+"' D:"+err+" <Semantico>");
        }
    }

    LeerIMPORTAR(raiz:Nodo):void{
        try{
            var path=raiz.lexema;
            this.SalidaConsola("La Path de Importacion es: "+path);
        }catch (err){
            this.SalidaConsolaError("<ERROR><Catch>[4]Lexema:'"+"LeerImportar()"+"' D:"+err+" <Semantico>");
        }
    }

    LeerCLASE(raiz:Nodo):void{
        try{
            this.SalidaConsola("LeerCLASE");
            //Si el Arbol tiene 3 Hijos es Una clase Normal
            if(raiz.hijos.length==3){
                this.SalidaConsola("CLASE NORMA");
                

            //Si el Arbol tiene 4 Hijos es Una clase Heredada
            }else if(raiz.hijos.length==4){
                this.SalidaConsola("CLASE HEREDADA");
                this.EscribirC3D("t1=1*1;");
            }
        }catch (err){
            this.SalidaConsolaError("<ERROR><Catch>[5]Lexema:'"+"LeerClase()"+"' D:"+err+" <Semantico>");
        }

    }

    public SalidaConsola(texto:string):void{
        this.SalidaConsolaAltoNivel+=texto+"\n";
    }
    public SalidaConsolaError(texto:string):void{
        this.ErroresSemanticos+=texto+"\n";
    }
    public EscribirC3D(texto:string):void{
        this.SalidaC3D+=texto+"\n";
    }
}