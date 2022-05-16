//LOAD A PLACEHOLDER TABLE
//create table
/*function createBlankSummary(){
document.getElementById("summaryTitle").innerHTML = "<br>Select a utility to see streamflow conditions in their water supply watersheds"; 

 const initialTableContent = ` 
   <table class='table-condensed sw-table'>
    <thead><tr>
      <th>Watershed</th>
      <th class='ext-dry'>Extremely <br> Dry</th>
      <th class='very-dry'>Very <br> Dry</th>
      <th class='mod-dry'>Moderately <br> Dry</th>
      <th class='mod-wet'>Moderately <br> Wet</th>
      <th class='very-wet'>Very <br> Wet</th>
      <th class='ext-wet'>Extremely <br> Wet</th>
    </tr></thead>
    
    <tbody><tr>
        <td>Watershed 1...</td>
        <td class='ext-dry'>NA</td>
        <td class='very-dry'>NA</td>
        <td class='mod-dry'>NA</td>
        <td class='mod-wet'>NA</td>
        <td class='very-wet'>NA</td>
        <td class='ext-wet'>NA</td>
      </tr>
      <tr>
        <td>Watershed 2...</td>
        <td class='ext-dry'>NA</td>
        <td class='very-dry'>NA</td>
        <td class='mod-dry'>NA</td>
        <td class='mod-wet'>NA</td>
        <td class='very-wet'>NA</td>
        <td class='ext-wet'>NA</td>
      </tr>
    </tbody>
  </table>
`; //note back ticks

document.getElementById("summaryTableDiv").innerHTML = initialTableContent;

}
createBlankSummary();


//Load Data and get correct########################################################
function createCurrentSummary(myUtility){
   d3.csv("data/boerne_link_pwsid_watershed.csv").then(function(pwsid_huc){
    var selectedHucs = pwsid_huc.filter(function(d){return d.utility_name === myUtility; });
    var filterHucName = selectedHucs.map(function(d){return d.ws_watershed; });
    
  //load in streams
  d3.csv("data/streamflow/current_sites_status.csv").then(function(hucStatus){
    //filter based on selectedHucs - array of names
    var filteredHuc = hucStatus.filter(function(d) {
    return filterHucName.indexOf(d.ws_watershed) !== -1 ;
  });
  
  //create table
  var myTable = "<table class='sw-table table-condensed'>";
  //create column header
  myTable += "<thead><tr>";
    myTable += "<th>Watershed</th>";
    myTable += "<th class='ext-dry'>Extremely <br> Dry</th>";
    myTable += "<th class='very-dry'>Very <br> Dry</th>";
    myTable += "<th class='mod-dry'>Moderately <br> Dry</th>";
    myTable += "<th class='mod-wet'>Moderately <br> Wet</th>";
    myTable += "<th class='very-wet'>Very <br> Wet</th>";
    myTable += "<th class='ext-wet'>Extremely <br> Wet</th></thead>";
  myTable += "<tbody style= 'font-weight: bold;'>";

  //var tbody = document.getElementById('tbody');
  //loop through and add rows
  //http://jsfiddle.net/mjE7R/3/
  var fooHuc;
  for (var i = 0, len = filterHucName.length; i < len; i++) {
    //filter table;
    fooHuc = filteredHuc.filter(function(d) {return d.ws_watershed === filterHucName[i]; });

    myTable += "<tr>";
    myTable += "<td>" + filterHucName[i] + "</td>";  // watershed row

    myTable += "<td class='ext-dry'>" + fooHuc.filter(function(d){return d.status==="Extremely Dry"; }).length + "</td>";
    myTable += "<td class='very-dry'>" + fooHuc.filter(function(d){return d.status==="Very Dry"; }).length + "</td>";
    myTable += "<td class='mod-dry'>" + fooHuc.filter(function(d){return d.status==="Moderately Dry"; }).length + "</td>";
    myTable += "<td class='mod-wet'>" + fooHuc.filter(function(d){return d.status==="Moderately Wet"; }).length + "</td>";
    myTable += "<td class='very-wet'>" + fooHuc.filter(function(d){return d.status==="Very Wet"; }).length + "</td>";
    myTable += "<td class='ext-wet'>" + fooHuc.filter(function(d){return d.status==="Extremely Wet"; }).length + "</td>";
    
  myTable += "</tr>";
}

//calculate total
  var extDry = filteredHuc.filter(function(d){return d.status==="Extremely Dry"; }).length;
  var veryDry = filteredHuc.filter(function(d){return d.status==="Very Dry"; }).length;
  var modDry = filteredHuc.filter(function(d){return d.status==="Moderately Dry"; }).length;
  var modWet = filteredHuc.filter(function(d){return d.status==="Moderately Wet"; }).length;
  var veryWet = filteredHuc.filter(function(d){return d.status==="Very Wet"; }).length;
  var extWet = filteredHuc.filter(function(d){return d.status==="Extremely Wet"; }).length;
  var totalSites = extDry+veryDry+modDry+modWet+veryWet+extWet;//filteredHuc.length... unknowns;

//add to table  
  myTable += "<tr style='font-size: 14px;'><td>TOTAL</td>";  // watershed row
  myTable += "<td style='color: darkred;'>" + extDry + "</td>";
  myTable += "<td style='color: red;'>" + veryDry + "</td>";
  myTable += "<td style='color: orange;'>" + modDry + "</td>";
  myTable += "<td style='color: cornflowerblue;'>" + modWet + "</td>";
  myTable += "<td style= 'color: blue;'>" + veryWet + "</td>";
  myTable += "<td style= 'color: navy;'>" + extWet + "</td></tr>";

  myTable += "</tbody></table>"; 

//load table
document.getElementById("summaryTableDiv").innerHTML = myTable;

//color cells based on value
var cells = document.getElementById('summaryTableDiv').getElementsByTagName('tbody')[0].getElementsByTagName('td');
for (var i=0, len=cells.length; i<len; i++){
  if (parseInt(cells[i].innerHTML) > 0) { cells[i].style.backgroundColor = 'rgba(26,121,131,0.2)';
  }
}

var array1 = ["Extermely Dry", "Very Dry", "Moderately Dry", "Moderately Wet", "Very Wet", "Extermely Wet"];
var array2 = [extDry, veryDry, modDry, modWet, veryWet, extWet];
var maxCategory = {};
array1.forEach(function(value, index) { maxCategory[value] = array2[index]; });
var maxCategoryD = Object.keys(maxCategory).reduce(function(a, b){ return maxCategory[a] > maxCategory[b] ? a : b; });
var maxValue = Math.round(Math.max(extDry, veryDry, modDry, modWet, veryWet, extWet)/totalSites*100*10)/10;
//console.log(maxCategoryD); console.log(maxValue);

//load document names
if(myUtility === "none"){ 
    document.getElementById("summaryTitle").innerHTML = ""; 
  }

  if(myUtility !== "none"){ 
    if(maxValue > 0){
      document.getElementById("summaryTitle").innerHTML = "<br>Recent Streamflow Conditions for " + myUtility +  
      "<p style='background-color: rgba(26,121,131,0.2)'>" + maxValue + "%</strong> of sites with data were <strong>" + maxCategoryD + 
      "</strong> on " + filteredHuc[0].date + "</p>"; 
    } else {document.getElementById("summaryTitle").innerHTML = "<br>Recent Streamflow Conditions for " + myUtility  + 
      "<p style='background-color: rgba(26,121,131,0.2)';><strong>No gauges found in defined water supply watersheds.";  }
  }


      });//end d3 of triangle sites
  });//end d3 of link_pwsid_watershed
}
*/





/*########################################################################################################3
#
#
##########################################################################################################3*/
function toggleStats(target){
  var x = document.getElementById("switchStats").checked;
  if (x === true) { streamPlotType = "on";}
  if (x === false) { streamPlotType = "off";}
  
  Plotly.purge('streamPlot');
  if(streamID !== "none"){
    createDailyStatistics(streamID, streamPlotType);
  }
  return streamPlotType;
}


/*########################################################################################################3
#
#
##########################################################################################################3*/
function createDailyStatistics(streamID, streamPlotType) {
// delete initial image and any plots
 document.getElementById("streamPlot").innerHTML = "";

//parse date to scale axis
parseDate = d3.timeParse("%Y-%m-%d");
//read in stream stats
d3.csv(fileName).then(function(streamStats){
    streamStats.forEach(function(d){
            d.julian = +d.julian;
            d.min = +d.min;
            d.flow10 = +d.flow10;
            d.flow25 = +d.flow25;
            d.flow50 = +d.flow50;
            d.flow75 = +d.flow75;
            d.flow90 = +d.flow90;
            d.flow = +d.flow;
            d.max = +d.max;
            d.Nobs = +d.Nobs;
            d.startYr = +d.startYr;
            d.endYr = +d.endYr;
            d.date = parseDate(d.date2);
       });

var filterData = streamStats.filter(function(d){return d.site === streamID && d.date >= parseDate("2021-01-01"); });
//Fill arrays  
    var XJulian = filterData.map(function(d) {return d.date; });
    var Ymin = filterData.map(function(d) {return d.min; });
    //var Ymax = filterData.map(function(d) {return d.max; });
    var Ymed = filterData.map(function(d) {return d.flow50; });
    var Y10per = filterData.map(function(d) {return d.flow10; });
    var Y25per = filterData.map(function(d) {return d.flow25; });
    var Y75per = filterData.map(function(d) {return d.flow75; });
    var Y90per = filterData.map(function(d) {return d.flow90; });
    var Yflow= filterData.map(function(d) {return d.flow; });
//console.log(filterData); console.log(Ymed);

var YOT = [];
for (j=0; j<XJulian.length; j++){  YOT[j] = 100; }  


/*#####################################################################################
         PLOT BY STATUS AS MARKERS
#####################################################################################*/
//Create Plotly Traces
traceOT = {
  type: 'scatter',   mode: 'lines',
  x: XJulian,  y: YOT,
  name: '100% Full',
  line: {  color: 'darkgray',  width: 3 }
};

traceMin = {
  type: 'scatter', mode: 'lines',
  x: XJulian,      y: Ymin,
  name: 'Min',
  line: { color: 'red',  width: 1,  dash: 'dot' }
};

trace10 = {
  type: 'scatter', mode: 'lines',
  x: XJulian,     y: Y10per,
  name: '10th %',
  line: { color: 'rgba(0, 0, 0, 0.2)',  width: 1,   dash: 'dot' }
};

trace25 = {
  type: 'scatter', mode: 'lines',
  x: XJulian,     y: Y25per,
  fill:  'tonexty',
  fillcolor: 'rgba(242,228,174,0.4)',
  name: '25th %',
  line: {  color: 'rgba(0,0,0,0.6)',  width: 2,  dash: 'dot'  }
};

trace50 = {
  type: 'scatter', mode: 'lines',
  x: XJulian,     y: Ymed,
  name: 'Median',
  fill:  'tonexty',
  fillcolor: 'rgba(242,228,174,0.8)',
  line: { color: 'black',  width: 1 }
};

trace75 = {
  type: 'scatter', mode: 'lines',
  x: XJulian,     y: Y75per,
  fill:  'tonexty',
  fillcolor: 'rgba(242,228,174,0.8)',
  name: '75th %',
  line: { color: 'rgba(0,0,0,0.6)',   width: 2,   dash: 'dot'  }
};

trace90 = {
  type: 'scatter', mode: 'lines',
  x: XJulian,      y: Y90per,
  fill:  'tonexty',
  fillcolor: 'rgba(242,228,174,0.4)',
  name: '90th %',
  line: { color: 'rgba(0,0,0,0.4)',  width: 1,  dash: 'dot' }
};


traceThisYear = {
  type: 'scatter', mode: 'lines',
  x: XJulian,  y: Yflow,
  name: '2021 Flow',
  line: { color: 'rgb(26,121,131)',   width: 3  }
};


var data; var y_title = ""; var x_axis_format = '%b-%d';

if(streamPlotType === "on"){
  x_axis_format =  '%b-%d';
  if (fileName === "data/streamflow/all_boerne_stream_stats.csv"){
    data = [traceMin, trace10, trace25, trace50, trace75, trace90, traceThisYear];
    y_title = "Streamflow (cfs)";
  }

  if (fileName === "data/reservoirs/all_canyon_reservoir_stats.csv"){
    y_title = "Percent Storage (%)";
    data = [traceMin, trace10, trace25, trace75, trace90, traceOT, trace50, traceThisYear];
  }
}

if(streamPlotType === "off"){
  x_axis_format =  '%Y-%m-%d';
  var filterData2 = streamStats.filter(function(d){return d.site === streamID && d.flow > 0; });
  var colorPoints = filterData2.map(function(d) {return d.colorStatus; });
  var streamStatus = filterData2.map(function(d) {return d.status; });
  var xColorPoints = filterData2.map(function(d) {return d.date; });
  var yColorPoints = filterData2.map(function(d) {return d.flow; });
  var yOT2 = [];
  for (j=0; j<xColorPoints.length; j++){  yOT2[j] = 100; }  
  
  var traceColorStatus;
  if(fileName==="data/streamflow/all_boerne_stream_stats.csv"){
    traceColorStatus = {
      type: 'scatter',
      x: xColorPoints,  y: yColorPoints,
      text: streamStatus,
      mode: 'lines+markers',
      name: 'flow',
      marker: { color: colorPoints, size: 5, opacity: 0.8},
      line: { color: 'gray',  width: 1},
      hovertemplate: "<b>%{text}</b><br>" + "Flow: %{y:.2f} cfs<br>" + "Date: %{x}"
    };
  }
  
  if(fileName==="data/reservoirs/all_canyon_reservoir_stats.csv"){
    traceColorStatus = {
      type: 'scatter',
      x: xColorPoints,  y: yColorPoints,
      text: streamStatus,
      mode: 'lines+markers',
      name: 'storage',
      marker: { color: colorPoints, size: 5, opacity: 0.8},
      line: { color: 'gray',  width: 1},
      hovertemplate: "<b>%{text}</b><br>" + "Storage: %{y:.2f}%<br>" + "Date: %{x}"
    };
  }
  

  traceOT2 = {
    type: 'scatter',   mode: 'lines',
    x: xColorPoints,  y: yOT2,
    name: '100% Full',
    line: {  color: 'darkgray',  width: 3 }
  };
  
  if (fileName === "data/streamflow/all_boerne_stream_stats.csv"){
    data = [traceColorStatus];
    y_title = "Streamflow (cfs)";
  }

  if (fileName === "data/reservoirs/all_canyon_reservoir_stats.csv"){
    y_title = "Percent Storage (%)";
    data = [traceOT2, traceColorStatus];
  }
}

var layout = {
    yaxis: {
        title: y_title,
        titlefont: {color: 'rgb(0, 0, 0)', size: 14},
        tickfont: {color: 'rgb(0, 0, 0)', size: 12},
        showline: true,
        showgrid: false,
        //range: [0, Math.log(maxVal)],
        type:'log'
    },
    xaxis: {
      showline: true,
      title: '',
      titlefont: {color: 'rgb(0, 0, 0)', size: 14},
      tickfont: {color: 'rgb(0, 0, 0)', size: 12},
      tickformat: x_axis_format,
      //range: [minStart.toString(), maxEnd.toString()],
      //zerolinewidth: 1,
    },
    height: 300,
    showlegend: true,
    margin: {t: 30, b: 60, r: 30, l: 50 },
    //fixedrange: false
};

Plotly.newPlot('streamPlot', data, layout, config);

/*#####################################################################################
         COUNT PERCENT OF TIME SPENT IN DIFFERENT STATUS
#####################################################################################*/
//calculate total


  var extDry = filterData.filter(function(d){return d.status==="Extremely Dry"; }).length;
  var veryDry = filterData.filter(function(d){return d.status==="Very Dry"; }).length;
  var modDry = filterData.filter(function(d){return d.status==="Moderately Dry"; }).length;
  var modWet = filterData.filter(function(d){return d.status==="Moderately Wet"; }).length;
  var veryWet = filterData.filter(function(d){return d.status==="Very Wet"; }).length;
  var extWet = filterData.filter(function(d){return d.status==="Extremely Wet"; }).length;
  var totalSites = extDry+veryDry+modDry+modWet+veryWet+extWet;

  //Percent time in current status
  var currentStatus = filterData.filter(function(d) {return d.julian === recentDate; }).map(function(d) { return d.status; });
  var maxCategoryD = filterData.filter(function(d){ return d.status === currentStatus[0]; }).length;
  var currentPercent = Math.round(maxCategoryD/totalSites*100*10)/10;
//  console.log(currentStatus); console.log(maxCategoryD); console.log(currentStatus);


document.getElementById("selectMetadata").innerHTML = "<p>Data from: " + filterData[0].startYr + "-" + 
         filterData[0].endYr + " (" + filterData[0].Nobs + " years with recorded observations) <br><span style='color: rgb(26,131,130);'>This site is " + 
         currentStatus + ", spending " + currentPercent + "% of the year to date in this status.</span></p>";

});// end D3
} //END CREATE CHART FUNCTION ##########################################################



