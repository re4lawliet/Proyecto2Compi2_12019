import React from 'react';
import AceEditor from 'react-ace';
import 'brace/mode/java';
import 'brace/theme/textmate';
import { Button } from 'react-bootstrap';
import { ButtonToolbar } from 'react-bootstrap';
import { Tab,Tabs } from 'react-bootstrap';
import "../Break.css";


class Acee extends React.Component {


  constructor(props){
    super(props);
    this.onChange=this.onChange.bind(this);
    this.onChange2=this.onChange2.bind(this);
    this.state={
      Texto1 : "Bienvenido a Caas",
      Texto2 : "Salida3D",
      Salida : []
    }
    
  }
  
  onChange(newValue) {
    const editorAltoNivel = this.ace.editor;//Caja del Codigo Alto nivel
    this.setState({Texto1: editorAltoNivel.getValue()});
  }
  onChange2(newValue) {
    const editorC3D = this.cajaC3D.editor; // Caja del Codigo 3D
    this.setState({Texto2: editorC3D.getValue()});
  }

  /**********************************************************/
  /*******      BOTON COMPILAR CODIGO ALTO NIVEL      *******/
  /**********************************************************/

  CompilarCAltoNivel = event => {

    alert("Click en el Boton Compilar");

    //Definicion de Consolas
    const editorAltoNivel = this.ace.editor;//Caja del Codigo Alto nivel
    const editorC3D = this.cajaC3D.editor; // Caja del Codigo 3D
    const editorConsola1=this.ace1.editor; //Consola Salida
    const editorConsola2=this.ace2.editor; //Consola Errores
    const editorConsola3=this.ace3.editor; //Consola Extra

    //Jalada de BreakPoints
    var BKP = editorAltoNivel.session.getBreakpoints();
    var i = 0;
    for (i = 0; i < BKP.length; i++) {
        alert(BKP[i]);
    }

    var S;
    this.setState({Texto1: editorAltoNivel.getValue()});

    //Enviar al Servidor el Texto
    fetch('/CompilarAltoNivel', {
      method: 'POST',
            body: JSON.stringify({ textoEnviado: this.state.Texto1 }),
            headers: {
                'Content-Type': 'application/json'
            }
            
        }).then(response => response.json())
            .then(Salida => this.setState({ Salida }));

      try{
        this.setState({Texto2: this.state.Salida.salidaC3D});
        this.setState({Texto2: this.state.Salida.salidaC3D});
       //var a=this.state.Salida.salidaConsola;
       //var b=this.state.Salida.salidaErrores;
       //var c=this.state.Salida.salidaC3D;
       //alert(a);
       //alert(b);
       //alert(c);

    /*
    //Definicion de Clase Graficador y Gramatica
    var Graficador_1 = require("../Analizadores/Graficador");
    var parser = require("../Analizadores/Lexico").parser;

    //Ejecutar Parser
    function exec (input) {
        return parser.parse(input);
    }
    var RaizArbol = exec(editorAltoNivel.getValue().toString());

    //LLamada a Metodo de Graficar
    var graficar = new Graficador_1.Graficador();
    graficar.GraficarAST(RaizArbol.raiz);
    */
    /*
    var a="ERRORES::::::::::::::\n";
    if(RaizArbol.Errores.length>0){
      alert("tiene Errores la Wea");
      
      RaizArbol.Errores.forEach(element => {
        
        var err=element.lexema.toString();
        err=err+" ["+element.line+"]";
        err=err+" ["+element.columna+"]";
        err=err+" ["+element.tipo.toString()+"]";
        err=err+" ["+element.descripcion.toString()+"]";

        a+=err.toString();
      });
    }
    RaizArbol.Errores=[];
    */


    //Salida Consola Errores
    //editorConsola2.setValue(this.state.Salida.salidaErrores);
    //SAlida del Dot en Consola Extra
    //editorConsola1.setValue(this.state.Salida.salidaConsola);
    //SAlida del C3D
    //editorC3D.setValue(this.state.Salida.salidaC3D);
    }catch{
        alert("<Error Catch>[1] Error Accion de Boton");  
    }
  };

  /**********************************************************/
  /*******      BOTON COMPILAR CODIGO 3D              *******/
  /**********************************************************/

  CompilarC3D = event => {

    alert("Click en el Boton Compilar C3D");
    
    //Definicion de Consolas
    const editorAltoNivel = this.ace.editor;//Caja del Codigo Alto nivel
    const editorC3D = this.cajaC3D.editor; // Caja del Codigo 3D
    const editorConsola1=this.ace1.editor; //Consola Salida
    const editorConsola2=this.ace2.editor; //Consola Errores
    const editorConsola3=this.ace3.editor; //Consola Extra
    //Jalada de BreakPoints
    var BKP = editorAltoNivel.session.getBreakpoints();
    var i = 0;
    for (i = 0; i < BKP.length; i++) {
        alert(BKP[i]);
    }
    var S;
    this.setState({Texto1: editorAltoNivel.getValue()});
    
    //Enviar al Servidor el Texto
    fetch('/CompilarC3D', {
      method: 'POST',
            body: JSON.stringify({ textoEnviado: editorC3D.getValue() }),
            headers: {
                'Content-Type': 'application/json'
            }
            
        }).then(response => response.json())
            .then(Salida => this.setState({ Salida }));

    try{
    /*
    //Definicion de Clase Graficador y Gramatica
    var Graficador_1 = require("../Analizadores/Graficador");
    var parser = require("../Analizadores/LexicoC3D").parser;

    //Ejecutar Parser
    function exec (input) {
        return parser.parse(input);
    }
    var RaizArbol = exec(editorC3D.getValue());

    //LLamada a Metodo de Graficar
    var graficar = new Graficador_1.Graficador();
    graficar.GraficarAST(RaizArbol);

    //SAlida del Dot en Consola Extra
    editorConsola3.setValue(graficar.CadenaDot);
    */
    }catch{
      alert("<Error Catch>[1] Error Accion de Boton");  
    }
  };

  Limpiar = event => {
    const editorC3D = this.cajaC3D.editor; // Caja del Codigo 3D
    alert(editorC3D.getValue());
  };
  /**********************************************************/
  /*******      HTML GENERADO                         *******/
  /**********************************************************/

  render()  {
    return (
      <div>

        {/* BARRA DE BOTONES */}

         <div className="cajaTexto">
          <ButtonToolbar>
            <Button variant="primary" onClick={this.CompilarCAltoNivel}>Compilar</Button>
            <Button variant="secondary"onClick={this.CompilarC3D}>Compilar C3D</Button>
            
            <Button variant="success">Debug</Button>
            <Button variant="warning">Pausa</Button>
            <Button variant="light"onClick={this.Limpiar} >Limpiar</Button>
          </ButtonToolbar>
          <br/>
        </div>

        {/* CAJA DE TEXTO ALTO NIVEL */}

        <div className="cajaTexto">
          <AceEditor
          width="1000px"
          height="400px"
          mode="java"
          theme="textmate"
          onChange={this.onChange}
          name="UNIQUE_ID_OF_DIV"
          ref={instance => { this.ace = instance; }}
          editorProps={{$blockScrolling: true}}
          showGutter={true}
          value={this.state.Texto1}
          />      
        </div> 

        {/* CONSOLAS DE SALIDA */}

        <div className="Consolas"> 
          <Tabs id="uncontrolled-tab-example">
            <Tab eventKey="ConsolaSalida" title="ConsolaSalida">
              <AceEditor
              width="1000px"
              height="300px"
              mode="java"
              theme="textmate" 
              name="UNIQUE_ID_OF_DIV"
              value={this.state.Salida.salidaConsola}
              ref={instance => { this.ace1 = instance; }}
              editorProps={{$blockScrolling: true}}
              />
            </Tab>
            <Tab eventKey="ConsolaErrores" title="ConsolaErrores">
              <AceEditor
              width="1000px"
              height="300px"
              mode="java"
              theme="textmate"   
              name="UNIQUE_ID_OF_DIV"
              ref={instance => { this.ace2 = instance; }}
              editorProps={{$blockScrolling: true}}
              value={this.state.Salida.salidaErrores}
              />
            </Tab>
            <Tab eventKey="ConsolaExtra" title="ConsolaExtra">
              <AceEditor
              width="1000px"
              height="300px"
              mode="java"
              theme="textmate"
              name="UNIQUE_ID_OF_DIV"
              ref={instance => { this.ace3 = instance; }}
              editorProps={{$blockScrolling: true}}
              />
            </Tab>
          </Tabs>
        </div>

        {/* CONSOLAS DE C3D */}

        <div className="salidaC3D">
          <AceEditor
          width="450px"
          height="700px"
          mode="java"
          theme="textmate"
          
          name="UNIQUE_ID_OF_DIV"
          ref={instance => { this.cajaC3D = instance; }}
          editorProps={{$blockScrolling: true}}
          value={this.state.Salida.salidaC3D}
          />     
        </div>   

    </div>
    );
  }

}

export default Acee;