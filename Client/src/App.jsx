import React, {useState} from 'react';
import './App.css';
import FormTodo from './FormTODO';

function App() {

  const [respuesta, setRespuesta] = useState("");
  return (
    <div className="App">
      <div className="App-header">
        <h2>Proyecto final: Complejidad.</h2>
      </div>

      <FormTodo
        onSubmit={setRespuesta}/>
      {respuesta ? <h2>Respuesta: {respuesta}</h2> : <React.Fragment />}
    </div>
  );
}

export default App;
