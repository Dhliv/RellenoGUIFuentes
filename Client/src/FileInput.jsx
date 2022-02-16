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
    <div className="file-input">
      {/*(F-2)*/}
      {console.log(fieldSize)}
      <input
        type="number"
        value={coordenadaX}
        placeholder='Coordenada X'
        onChange={e => setCoordenadaX(e.target.value)}
      />
      <input
        type="number"
        value={coordenadaY}
        placeholder='Coordenada Y'
        onChange={e => setCoordenadaY(e.target.value)}
      />
      <button
        type='button'
        className="button pink"
        disabled={(coordenadaY && coordenadaX && coordenadaY>= 0 && coordenadaX>= 0 && coordenadaY <= fieldSize && coordenadaX <= fieldSize) ? "" : "disabled"}
        onClick={onClick}
      >
        Añadir
      </button>
    </div>
  )
}