import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import CajaEditor from './Interfaz/CajaEditor';
//import CajaSalidaC3D from './Interfaz/CajaSalidaC3D';
//import ConsolasR from './Interfaz/Consolas';

class App extends Component {
  render()  {
    return (
      <div className="App-header">
        {/* Link para Jalar los Componentes de Bootstrap */}
        <link
          rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
          crossorigin="anonymous"
        />
        {/* Inicio Encabezado */}
        <header className="App-header">
          {/* Logo Giratorio */}
          <img src={logo} className="App-logo imageIcon" alt="logo" width='120' height='120'/>
          {/* Clase de la Caja de Texto */}
          <CajaEditor titulo="CajaEditor"/>
          {/*<ConsolasR titulo="Consolas"/>*/}
          {/*<CajaSalidaC3D titulo="CajaSalidaC3D"/>*/}
          

        </header> 
      </div>
    );
  }
}

export default App;
