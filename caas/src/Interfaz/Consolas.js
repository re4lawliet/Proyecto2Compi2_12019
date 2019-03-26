import React from 'react';
import 'brace/mode/java';
import 'brace/theme/textmate';
import { Tab,Tabs } from 'react-bootstrap';
//import { Form } from 'react-bootstrap';

class ConsolasR extends React.Component {

  onChange(newValue) {
    alert(newValue);
  };

  render()  {
    return (
        <div className="Consolas"> 
          <Tabs id="uncontrolled-tab-example">
            <Tab eventKey="ConsolaSalida" title="ConsolaSalida">
            <textarea class="form-control" rows="10"></textarea>
            </Tab>
            <Tab eventKey="ConsolaErrores" title="ConsolaErrores">
            <textarea class="form-control" rows="10"></textarea>
            </Tab>
            <Tab eventKey="ConsolaExtra" title="ConsolaExtra">
            <textarea class="form-control" rows="10"></textarea>
            </Tab>
          </Tabs>
        </div>
    );
  }
}

export default ConsolasR;