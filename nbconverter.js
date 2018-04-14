var fs = require('fs');

var NodeGeocoder = require('node-geocoder');

var options = {
    provider: 'google',
    // Optional depending on the providers 
    httpAdapter: 'https', // Default 
    apiKey: process.env.NB_API_KEY, // for Mapquest, OpenCage, Google Premier 
    formatter: null // 'gpx', 'string', ... 
};


var geocoder = null;

if (process.env.NB_API_KEY) {
    console.log("API Key found, will attempt to geocode locations.")
    geocoder = NodeGeocoder(options);
} else {
    console.log("No API Key (NB_API_KEY) found, not attempting to geocode locations.")
}

var args = process.argv.splice(2);

if (args.length != 1) {
    console.log("You must pass a file name to convert as the first parameter.");
    console.log("Usage:", process.argv[0], " csv-filename");
    process.exit(0);
}

// no longer need to merge this file, as the new csv format 
// var existingMapDataFile = "mapdata.json";

var inputfile = args[0];
var outputfile = "mapdata.xml";
var logfile = outputfile + '.log';

console.log("Input File ", inputfile);
console.log("Outputfile File ", outputfile);
console.log("Logfile File ", logfile);

var map = new Map();
var nameToId = new Map();
var Converter = require("csvtojson").Converter;
var converter = new Converter({});
var missingCount = 0;

function xmlit(tag, content) {
    var c = (content ? content.replace(/&/g, '&amp;') : "");
    return "    <" + tag + ">" + c + "</" + tag + ">";
}

var noNBDataExpected = {
    "gardens": ['icon', 'farmtype', "favorites"],
    "foodservices": ['icon', 'farmtype', "favorites"],
    "producer": ['icon']
}

function generateTag(obj, xmlField, nationBuilderField) {

    var nationbuilderdata = obj[nationBuilderField];
    if (nationbuilderdata == undefined) {
        var nbid = obj.nationbuilder_id;
        var msg = "Mapdata: '" +
                xmlField +
                "' CSV: '" +
                nationBuilderField + "'.";
 
                var excludes = noNBDataExpected[obj.orgtype];

                if (excludes && !excludes.includes(xmlField)) {
                    msg = msg + "No Update Found";
                    // log(JSON.stringify(existingdata, 4));
                } else {
                    msg = undefined;
                }
                nationbuilderdata = "";
            //}
        //}
    }
    if (msg) {
        if (obj.showHeader) {
            log(String(missingCount++) + ": " + header);
            obj.showHeader = false;
        }
        log("   " + msg);
    }
    return xmlit(xmlField, nationbuilderdata);
}

var outputLines = [];

function output(line) {
    outputLines.push(line);
}

var logoutput = [];

function log(line) {
    logoutput.push(line);
}


function outputXML() {
    console.log("Creating: ", outputfile);
    var stream = fs.createWriteStream(outputfile);
    stream.once('open', function(fd) {
        stream.write("");
        stream.write('<?xml version="1.0" encoding="UTF-8"?>');
        stream.write('<?xml-stylesheet type="text/xsl" href="mapdata.xsl"?>');
        stream.write("<markers>");

        for (var i = 0; i < outputLines.length; i++) {
            stream.write(outputLines[i]);
        }
        stream.write("</markers>");
        stream.end();
    });
}

function outputLog() {
    console.log("Creating: ", logfile);
    var stream = fs.createWriteStream(logfile);
    stream.once('open', function(fd) {
        for (var i = 0; i < logoutput.length; i++) {
            stream.write(logoutput[i]);
            stream.write("\n");
        }
        stream.end();
    });
}

function getFarmType(type) {
    // foodservice, producer, retailers, markets
}

var xmlTagToNBName = {
    "name": "full_name",
    "nbid": "nationbuilder_id",
    "lat": "lat",
    "lng": "lng",
    "orgtype": "orgtype",
    "savour": "membership",
    "farmtypes": "farmtypes",  // 
    "favorites": "favorites",  // things produced, fruit, vegetable, meat, etc
    "productiontypes": "productiontypes",  // conventional, eco_practices, certified_organic
    "infowindow": "infowindow",  // compilation of name, address, email, phone
    "email": "email", 
    "website": "website",
    "icon": "icon"
};

function getGetcodeData(address) {
    if (geocoder) {
        geocoder.geocode(address, function(err, res) {
            console.log("Returned Data for GPS FOR  =", address);
            console.log(res);
        });
    }
}

converter.fromFile(inputfile, function(err, jsonArray) {
    for (var i = 0, l = jsonArray.length; i < l; i++) {
        var obj = jsonArray[i];
        output("<marker>");
        var xmltags = Object.keys(xmlTagToNBName);
        obj.showHeader = true;

        if (obj.address_address1) {
            getGetcodeData(obj.address_address1);
        }

        xmltags.forEach(function callback(xmlkey, index, array) {
            output(generateTag(obj, xmlkey, xmlTagToNBName[xmlkey]));
        });
        output("</marker>\n");
    }
    outputXML();
    outputLog();
});