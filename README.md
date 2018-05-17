# nbconverter

cd into the nbconverter directory first.

Install 
    
    npm install
    npm run build

Usage

    npm run run

Output

    mapdata.xml - an updated version of the mapdata.xml used by applications
    mapdata.xml.log - a log file of the converstion and changes needed. 

View

    The mapdata.xml file created can be viewed by opening the mapdata.xml in a browser. The stylesheet mapdata.xsl will format it for viewing.

Example

    The example csv file has a set of titles and one data set with the names of the titles as the values. It can be used as sample input to ensure the conversion process is running.
    The log file will be empty if no errors. The xml file produced will have one row with the titles as data.

 