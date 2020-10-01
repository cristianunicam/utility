const express = require("express");
const app = express();
const PORT  = process.env.PORT  || 3000;

const route = require("./structure/route.js");
app.use("/path",route);

app.listen(
    PORT,
    err => {
      if(err){
        return console.log("ERROR ",err);
      }
      console.log(`Listening at http://localhost:${PORT}`);
    }
  );

/*const {Client} = require("@googlemaps/google-maps-services-js");
const client = new Client({});

client
  .directions({
    params:{

    },
    })

client
  .elevation({
    params: {
      locations: [{ lat: 45, lng: -110 }],
      key: "AIzaSyB8gWlCkrp_kaqEy-dzRX_JNhLe2NtQjWI",
    },
    timeout: 1000, // milliseconds
  })
  .then((r) => {
    console.log(r.data.results[0].elevation);
  })
  .catch((e) => {
    console.log(e.response.data.error_message);
  });*/