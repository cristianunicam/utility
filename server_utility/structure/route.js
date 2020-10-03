const express = require("express");
const csv=require('csv-parser')
const csv_to_json=require('csvtojson')
const fs = require('fs')
var gpx_parse = require("gpx-parse");
let route = express();

var route_data;
const csv_file = "./parse_cai_data/data.csv";

route
    .route("/:id")
    .get((req, res) => {
        //res.send("GET ID: "+req.params.id);
        built_path = "./route_gpx/"+req.params.id+".gpx";
        var jsonResponse;
        parseCSV(req.params.id,jsonResponse)
        //res.send(parseGPX(built_path));
    });




function parseGPX(id_path){
    console.log("ID PATH: "+id_path);
    return gpx_parse.parseGpxFromFile(id_path,
        function(error, result) {
            if(error != null)
                console.log("ERROR! File not found");
            else{
                console.log(result.tracks[0].name);
                console.log(result.tracks.length);
            }
        });
}




function parseCSV(id,jsonResponse){
    csv_to_json()
        .fromFile(csv_file)
        .then((json_obj)=>{
            this.route_data=json_obj
            var found_item = this.route_data.filter(function(item) {
                return item.id == id;
            });
            console.log(found_item);
            jsonResponse = found_item;
        })
    /*var data = fs.readFileSync(csv_file)
    .toString() // convert Buffer to string
    .split('\n') // split string to lines
    .map(e => e.trim()) // remove white spaces for each line
    .map(e => e.split(',').map(e => e.trim())); // split each line to array

    console.log(data);
    console.log(JSON.stringify(data, '', 2));*/
    /*fs.createReadStream(csv_file)
        .pipe(csv())
        .on('data', (data) => results.push(data))
        .on('end', () => {
            console.log(results.filter(block => block.id==id));
        });*/
}

module.exports = route;