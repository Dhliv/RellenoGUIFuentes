import React, { useState } from 'react'

export default function FileInput(props) {

  const [coordenadaX, setCoordenadaX] = useState("");
  const [coordenadaY, setCoordenadaY] = useState("");

  const {ciudades, setCiudades, fieldSize} = props;
  const onClick = () => {
    const copy = ciudades.slice();
    copy.push({
      x: coordenadaX,
      y: coordenadaY
    });
    setCiudades(copy);
    setCoordenadaX("");
    setCoordenadaY("");
  }
  return (
    <div className="file-input xd">
      {/*(F-2)*/}
      {console.log(fieldSize)}
      <div className="input-group mb-3">
      <input
        type="number"
        className='form-control'
        value={coordenadaX}
        placeholder='Coordenada X'
        onChange={e => setCoordenadaX(parseInt(e.target.value))}
      />
      <input
        type="number"
        className='form-control'
        value={coordenadaY}
        placeholder='Coordenada Y'
        onChange={e => setCoordenadaY(parseInt(e.target.value))}
      />
      <button
        type='button'
        className="btn btn-primary"
        disabled={(coordenadaX !== "" && coordenadaY !== "" && coordenadaY>= 0 && coordenadaX>= 0 && coordenadaY <= fieldSize && coordenadaX <= fieldSize) ? "" : "disabled"}
        onClick={onClick}
      >
        Añadir
      </button>
      </div>
    </div>
  )
}