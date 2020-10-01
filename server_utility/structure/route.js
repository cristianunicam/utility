const express = require("express");
const csv = require('csv-parser')
const fs = require('fs')
var gpxParse = require("gpx-parse");
let route = express();
var builtPath;

const csvFile = "./parse_cai_data/data.csv";
const results = [];

route
    .route("/:id")
    .get((req, res) => {
        //res.send("GET ID: "+req.params.id);
        builtPath = "./route_gpx/"+req.params.id+".gpx";
        parseCSV(req.params.id)
        //res.send(parseGPX(builtPath));
    });

function parseGPX(idPath){
    console.log("ID PATH: "+idPath);
    return gpxParse.parseGpxFromFile(idPath,
        function(error, result) {
            if(error != null)
                console.log("ERROR! File not found");
            else{
                console.log(result.tracks[0].name);
                console.log(result.tracks.length);
            }
        });
}

function parseCSV(id){
    fs.createReadStream(csvFile)
        .pipe(csv())
        .on('data', (data) => results.push(data))
        .on('end', () => {
            console.log(results.filter(block => block.id==id));
            // [
            //   { NAME: 'Daffy Duck', AGE: '24' },
            //   { NAME: 'Bugs Bunny', AGE: '22' }
            // ]
        });
}

module.exports = route;