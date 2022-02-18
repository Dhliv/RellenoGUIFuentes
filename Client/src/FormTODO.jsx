import React, { useState } from "react";
import FileInput from "./FileInput";
import { postData } from "./postData";

import "./form.css";

const FormTodo = (props) => {

  const [ciudades, setCiudades] = useState([]);
  const [field, setField] = useState(0);
  const [content, setContent] = useState(null);
  const [fieldInserted, setFieldInserted] = useState(false);

  const parseToMZNFormat = () => {
    let mzn = `n=${field};\n`;
    mzn += `m=${ciudades.length};\n`;
    mzn += `ciudades=[`;
    ciudades.forEach(ciudad => {
      mzn += "|" + ciudad.x + "," + ciudad.y + "\n";
    });
    mzn += "|];";
    console.log(mzn);

    return mzn;
  }

  const handleSubmit = async (e) => {
    e.preventDefault();
    const input = parseToMZNFormat();
    const reqMzn = await postData("/getSolution", { data: input });
    const mzn = await reqMzn.json();
    props.onSubmit(mzn);
  };

  const block = () => {
    console.log(content);
    if (content) setField(content);
    setFieldInserted(true);
  }

  const remove = (index) => {
    let newArray = ciudades.slice(0, index);
    if (ciudades.length > 1) newArray = newArray.concat(ciudades.slice(index + 1, ciudades.length));
    console.log(ciudades);
    setCiudades(newArray);
  }

  return (
    <form onSubmit={handleSubmit}>

      <p>
        Ingrese el tamaño del territorio.
      </p>
      <div className="input-group mb-3">
      <input
        className="form-control"
        type={"number"}
        onChange={e => setContent(parseInt(e.target.value))}
        disabled={fieldInserted ? "disable" : ""} />
      <button
        className="btn btn-primary"
        type="button"
        disabled={content && content && !fieldInserted > 0 ? "" : "disable"}
        onClick={block}>Set</button>
        </div>
      <p>
        Por favor, ingrese las coordenadas X,Y de las ciudades
      </p>
      <FileInput
        setCiudades={setCiudades}
        fieldSize={field}
        ciudades={ciudades} />
      <br></br>
      <div>
        {ciudades.map((ciudad, index) => (
          <div key={index} className="input-group mb-3">
            <div className="div_ciudad">
            <h4 key={`${index}_h3`}></h4>
            <h4 key={`${index}_Coords`}>{`Ciudad ${index + 1} (X,Y) en (${ciudad.x}, ${ciudad.y})`}</h4>
            </div>
            <button
              onClick={e => remove(index)}
              type="button"
              className="btn btn-primary">
              Eliminar
            </button>
          </div>
        ))}
      </div>
      <button
        type={"submit"}
        className="btn btn-primary final-botton"
        disabled={field && ciudades.length ? "" : "disable"}
      >Calcular distancia máxima del relleno sanitario.</button>
    </form>
  );
};

export default FormTodo;