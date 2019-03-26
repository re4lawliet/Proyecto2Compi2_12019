import React from 'react';
import AceEditor from 'react-ace';
import 'brace/mode/java';
import 'brace/theme/textmate';



function onChange(newValue) {
  console.log('change',newValue);
}

class Acee extends React.Component {
  render()  {
    return (
      <div>
        {/* CAJA DE TEXTO */}
        <div className="salidaC3D">
          <AceEditor
          width="450px"
          height="700px"
          mode="java"
          theme="textmate"
          onChange={onChange}
          name="UNIQUE_ID_OF_DIV"
          editorProps={{$blockScrolling: true}}
          />      
        </div>   
    </div>
    );
  }
}

export default Acee;