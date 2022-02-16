import React, { useState } from "react";
import FileInput from "./FileInput";
import { postData } from "./postData";

const FormTodo = (props) => {

  const [ciudades, setCiudades] = useState([]);
  const [field, setField] = useState(0);
  const [content, setContent] = useState("");
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



  return (
    <form onSubmit={handleSubmit}>

      <p>
        Ingrese el tamaño del territorio.
      </p>
      <input
        type={"number"}
        onChange={e => setContent(e.target.value)}
        disabled={fieldInserted ? "disable" : ""} />
      <button
        type="button"
        disabled={content && content && !fieldInserted > 0 ? "" : "disable"}
        onClick={block}>Set</button>
      <p>
        Por favor, ingrese las coordenadas X,Y de las ciudades
      </p>
      <div>
        {ciudades.map((ciudad, index) => (
          <React.Fragment key={index}>
            <h2 key={`${index}_h2`}>Ciudad {index + 1}:</h2>
            <h3 key={`${index}_xCoord`}>X: {`${ciudad.x}`}</h3>
            <h3 key={`${index}_yCoord`}>Y: {`${ciudad.y}`}</h3>
          </React.Fragment>
        ))}
      </div>
      <div className="todo-list">
        <FileInput
          setCiudades={setCiudades}
          fieldSize={field}
          ciudades={ciudades} />
      </div>
      <br></br>
      <button
        type={"submit"}
        disabled={field && ciudades.length ? "" : "disable"}
      >Calcular distancia máxima del relleno sanitario.</button>
    </form>
  );
};

export default FormTodo;