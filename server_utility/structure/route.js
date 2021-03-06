const express = require("express");
const csv_to_json = require('csvtojson')
const gpx_parse = require("gpx-parse");
let route = express();

const csv_file = "./parse_cai_data/data.csv";
var json_object = {}; // empty Object
var json_route = 'route';
var gpx = 'gpx';
json_object[json_route] = []; // empty Array, which you can push() values into
json_object[gpx] = [];
json_list = {};


route.route("").get((req,res) => {
    console.log("Executing request...");
    parseCSV(null,res);
});


route.route("/:id")
    .get((req, res) => {
        file_path = "parse_cai_data/route_gpx/"+req.params.id+".gpx";

        parseCSV(req.params.id,res);
        parseGPX(file_path,res);
    });

function parseGPX(file_path,res){
    console.log("File PATH: "+file_path);
    return gpx_parse.parseGpxFromFile(file_path,
        function(error, result) {
            if(error != null){
                console.error("GPX file error!");
                res.send(error);
            }else{
                json_object[gpx]=result;
                res.send(JSON.stringify(json_object));
            }
        });
}

function parseCSV(id,res){
    csv_to_json()
        .fromFile(csv_file)
        .then((json_obj)=>{
            if(id != null){
                json_object[json_route] = json_obj.filter(
                    function(item) {
                        return item.id == id;
                })[0];
            }else{
                //TODO Send everything, filter just id, difficulty and...
                res.send(json_obj);
            }
        })
}

module.exports = route;