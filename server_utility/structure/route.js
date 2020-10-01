const express = require("express");
const csv=require('csv-parser')
const csvToJson=require('csvtojson')
const fs = require('fs')
var gpxParse = require("gpx-parse");
let route = express();

var builtPathGPXFile;
var routeData;
const csvFile = "./parse_cai_data/data.csv";

route
    .route("/:id")
    .get((req, res) => {
        //res.send("GET ID: "+req.params.id);
        builtPath = "./route_gpx/"+req.params.id+".gpx";
        parseCSV(req.params.id,res)
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




function parseCSV(id,res){
    csvToJson()
        .fromFile(csvFile)
        .then((jsonObj)=>{
            this.routeData=jsonObj
            var foundItem = this.routeData.filter(function(item) {
                return item.id == id;
            });
            console.log(foundItem);
            res.send(foundItem);
        })
    /*var data = fs.readFileSync(csvFile)
    .toString() // convert Buffer to string
    .split('\n') // split string to lines
    .map(e => e.trim()) // remove white spaces for each line
    .map(e => e.split(',').map(e => e.trim())); // split each line to array

    console.log(data);
    console.log(JSON.stringify(data, '', 2));*/
    /*fs.createReadStream(csvFile)
        .pipe(csv())
        .on('data', (data) => results.push(data))
        .on('end', () => {
            console.log(results.filter(block => block.id==id));
        });*/
}

module.exports = route;