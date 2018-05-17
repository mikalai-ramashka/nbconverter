var browserify = require('browserify');
var b = browserify();
var fs = require('fs');
var path = require('path');

b.add(path.join(__dirname, '../nbconverter.js'));
b.bundle()
.pipe(fs.createWriteStream(path.join(__dirname, '../dist/nbconverter.js')));
