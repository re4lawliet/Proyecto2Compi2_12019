import React from 'react';
import AceEditor from 'react-ace';
import 'brace/mode/java';
import 'brace/theme/textmate';
import { Button } from 'react-bootstrap';
import { ButtonToolbar } from 'react-bootstrap';
import { Tab,Tabs } from 'react-bootstrap';
import "../Break.css";


var TextoAltoNivel="Bienvenido a Caas";


class Acee extends React.Component {


  constructor(props){
    super(props);
    this.onChange=this.onChange.bind(this);
    this.state={
      Texto1 : TextoAltoNivel
    }
  }
  
  onChange(newValue) {
    console.log('change',newValue);
    TextoAltoNivel=newValue;
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
    graficar.GraficarAST(RaizArbol);

    //SAlida del Dot en Consola Extra
    editorConsola3.setValue(graficar.CadenaDot);
    //SAlida del C3D
    editorC3D.setValue(editorAltoNivel.getValue());

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

    //Definicion de Clase Graficador y Gramatica
    var Graficador_1 = require("../Analizadores/Graficador");
    var parser = require("../Analizadores/LexicoC3D").parser;

    //Ejecutar Parser
    function exec (input) {
        return parser.parse(input);
    }
    var RaizArbol = exec(editorC3D.getValue().toString());

    //LLamada a Metodo de Graficar
    var graficar = new Graficador_1.Graficador();
    graficar.GraficarAST(RaizArbol);

    //SAlida del Dot en Consola Extra
    editorConsola3.setValue(graficar.CadenaDot);

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
          />      
        </div>   

    </div>
    );
  }

}

export default Acee;