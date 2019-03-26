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
    const editorAltoNivel = this.ace.editor;
    const editor = this.cajaC3D.editor; // The editor object is from Ace's API
    editor.setValue(editorAltoNivel.getValue());


    var BKP = editorAltoNivel.session.getBreakpoints();

    var i = 0;
    for (i = 0; i < BKP.length; i++) {
        alert(BKP[i]);
    }

    var parser = require("../Analizadores/Analizador1").parser;

    function exec (input) {
        return parser.parse(input);
    }
    
    var twenty = exec(editorAltoNivel.getValue().toString());
    const editorace1 = this.ace1.editor;
    editorace1.setValue(twenty.toString());

  };

  /**********************************************************/
  /*******      BOTON COMPILAR CODIGO 3D              *******/
  /**********************************************************/

  CompilarC3D = event => {
    alert("Click en el Boton Compilar C3D");
    const editor = this.cajaC3D.editor; // The editor object is from Ace's API
    alert("el codigo generado es: "+editor.getValue());

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