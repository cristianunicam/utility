const express = require("express");
const app = express();
const PORT  = process.env.PORT  || 3000;
const ROUTE = require("./structure/route.js");

app.use("/path",ROUTE);
app.listen(
    PORT,
    err => {
      if(err){
        return console.log("ERROR ",err);
      }
      console.log(`Listening at http://localhost:${PORT}`);
    }
  );