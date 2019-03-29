// lib/app.ts
import express = require('express');
import { Graficador } from "./Analizadores/Graficador";
import { CompilarAltoNivel } from "./Analizadores/CompilarAltoNivel";

//INICIAR LA WEA:::::::   npm run dev
//COMPILAR LOS TS LA WEA:::::::   npm run tsc

const app: express.Application = express();
var bodyParser = require("body-parser");
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.get('/', function (req, res) {
  res.send('Hello World!');
});

app.post('/CompilarAltoNivel',function (req,res,next){

    /******************************************************/
    /******  Ejecuta Analizador Lexico y Sintactico   *****/
    /******************************************************/
    var parser = require("./Analizadores/Lexico").parser;
    
    function exec (input: any) {
        return parser.parse(input);
    }
    try{

      var RaizArbol = exec(req.body.textoEnviado);


      /******************************************************/
      /******  Verifica Errores Lexicos Y Sintacticos   *****/
      /******************************************************/
      var ErroresLexSint=":::::::: ERRORES LEXICOS Y SINTACTICOS ::::::::\n";
      if(RaizArbol.Errores.length>0){//si tiene errores lexicos y sintacticos
        
        RaizArbol.Errores.forEach((element: { lexema: { toString: () => void; }; line: string; columna: string; tipo: { toString: () => string; }; descripcion: { toString: () => string; }; }) => { 
          
          var err=element.lexema;
          err=err+" ["+element.line+"]";
          err=err+" ["+element.columna+"]";
          err=err+" ["+element.tipo.toString()+"]";
          err=err+" ["+element.descripcion.toString()+"]";

          ErroresLexSint+=err.toString();
        });
        //se envia el Objeto de Respuesta
        res.json({

          salidaConsola: "Existen Errores Lexicos Y Sintacticos",
          salidaErrores: ErroresLexSint,
          salidaC3D: "Errores Lexicos y Sintacticos Alto Nivel"
      
        });
      }else{//si no tiene Crea el Arbol
        /******************************************************/
        /******  Grafica El Arbol                         *****/
        /******************************************************/
        var graficar =  new Graficador();
        graficar.GraficarAST(RaizArbol.raiz);

        /******************************************************/
        /******  Ejecuta El Arbol Alto Nivel              *****/
        /******************************************************/
        var EjecutarArbol = new CompilarAltoNivel(RaizArbol.raiz);
        EjecutarArbol.AnalizarAltoNivel();
        ErroresLexSint+=EjecutarArbol.ErroresSemanticos;
        //se envia el Objeto de Respuesta
        res.json({

          salidaConsola: EjecutarArbol.SalidaConsolaAltoNivel,
          salidaErrores: ErroresLexSint,
          salidaC3D: EjecutarArbol.SalidaC3D
      
        });
      }
      

      
  }catch(err){
    //se envia el Objeto de Respuesta
    res.json({

      salidaConsola: "::Cayo en Catch::",
      salidaErrores: "ERROR Catch :" + err,
      salidaC3D: "::Cayo en Catch::"
  
    });
  }


});

app.post('/CompilarC3D',function (req,res,next){

    
  /******************************************************/
  /******  Ejecuta Analizador Lexico y Sintactico   *****/
  /******************************************************/
  var parser = require("./Analizadores/LexicoC3D").parser;
  function exec (input: any) {
      return parser.parse(input);
  }
  try{
    var RaizArbol = exec(req.body.textoEnviado);

    /******************************************************/
    /******  Verifica Errores Lexicos Y Sintacticos   *****/
    /******************************************************/
    var ErroresLexSint=":::::::: ERRORES LEXICOS Y SINTACTICOS C3D ::::::::\n";
    if(RaizArbol.Errores.length>0){//si tiene errores lexicos y sintacticos
      
      RaizArbol.Errores.forEach((element: { lexema: { toString: () => void; }; line: string; columna: string; tipo: { toString: () => string; }; descripcion: { toString: () => string; }; }) => { 
        
        var err=element.lexema;
        err=err+" ["+element.line+"]";
        err=err+" ["+element.columna+"]";
        err=err+" ["+element.tipo.toString()+"]";
        err=err+" ["+element.descripcion.toString()+"]";

        ErroresLexSint+=err.toString();
      });
      //se envia el Objeto de Respuesta
      res.json({

        salidaConsola: "Existen Errores Lexicos Y Sintacticos C3D",
        salidaErrores: ErroresLexSint,
        salidaC3D: "Errores Lexicos y Sintacticos Alto Nivel C3D"
    
      });
    }else{//si no tiene Crea el Arbol
      /******************************************************/
      /******  Grafica El Arbol                         *****/
      /******************************************************/
      var graficar =  new Graficador();
      graficar.GraficarAST(RaizArbol.raiz);

      /******************************************************/
      /******  Ejecuta El Arbol Alto Nivel              *****/
      /******************************************************/
      //var EjecutarArbol = new CompilarAltoNivel(RaizArbol.raiz);
      //EjecutarArbol.AnalizarAltoNivel();
      //ErroresLexSint+=EjecutarArbol.ErroresSemanticos;
      //se envia el Objeto de Respuesta
      res.json({

        salidaConsola: "Salida a Consola del 3D",
        salidaErrores: ErroresLexSint,
        salidaC3D: req.body.textoEnviado
    
      });
    }
    

    
}catch(err){
  //se envia el Objeto de Respuesta
  res.json({

    salidaConsola: "::Cayo en Catch::",
    salidaErrores: "ERROR Catch :" + err,
    salidaC3D: "::Cayo en Catch::"

  });
}


});

app.listen(3001, function () {
  console.log('Example app listening on port 3001!');
});
