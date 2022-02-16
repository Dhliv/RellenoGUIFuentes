const express = require('express');
const fs = require('fs');

const app = express();
app.use(express.json());
app.set('port', process.env.PORT || 5000);
app.listen(app.get('port'), () => {
  console.log('Server running on port ' + app.get('port'))
});


app.post("/getSolution",

  ({ body }, res) => {
    const { data } = body;
    var exec = require('child_process').exec;

    fs.writeFile('proyecto.dzn', data, (err) => {

      // In case of a error throw err.
      if (err) throw err;
      else {
        const command = "minizinc proyecto.mzn proyecto.dzn";
        exec(command,
          function (error, stdout, stderr) {
            console.log('stdout: ' + stdout);
            console.log('stderr: ' + stderr);
            if (error !== null) {
              console.log('exec error: ' + error);
              res.json("Error");
            }else{
              console.log("NO ERROR")
              res.json(stdout);
            }
          });
      }
    })

  });