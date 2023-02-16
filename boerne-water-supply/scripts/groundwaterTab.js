
/*########################################################################################################3
#
#
##########################################################################################################3*/
//function to toggle stats on and off
function toggleGWStats(target){
  var x = document.getElementById("switchGWStats").checked;
  if (x === true) { gwPlotType = "on";}
  if (x === false) { gwPlotType = "off";}
  
  Plotly.purge('gwPlot2');
  if(gwID !== "none"){
    createGWTab(gwID, recentDate, gwPlotType);
  }
  return gwPlotType;
}

//function to create yearly trace of monthly mean 
function createTraceGW(target) {
  checkedGW = [];
  $("input[name='checkGWYear']:checked").each(function () {
      checkedGW.push($(this).val());
  });

  Plotly.purge('gwPlot4');
  plotGroundwater(gwID, checkedGW);
  return checkedGW;
}
/*########################################################################################################3
#
#
##########################################################################################################3*/
function createGWTab(gwID, recentDate, gwPlotType) {
  document.getElementById('gwPlot2').innerHTML = "";
  document.getElementById('relGWTitle').innerHTML = "Groundwater Levels Relative to Historic Levels";
  document.getElementById('monthlyGWTitle').innerHTML = "Monthly Mean Trends";
  document.getElementById('longGWTitle').innerHTML = "Long-term Annual Trends";
  plotGroundwater(gwID, checkedGW);
//parse date to scale axis
parseDate = d3.timeParse("%Y-%m-%d");

//read in stream stats
d3.csv("data/gw/all_gw_stats.csv").then(function(gwStats){
    gwStats.forEach(function(d){
            d.julian = +d.julian;
            d.min = +d.min;
            d.flow10 = +d.flow10;
            d.flow25 = +d.flow25;
            d.flow50 = +d.flow50;
            d.flow75 = +d.flow75;
            d.flow90 = +d.flow90;
            d.flow = +d.depth_ft;
            d.max = +d.max;
            d.Nobs = +d.Nobs;
            d.start_yr = +d.startYr;
            d.end_yr = +d.endYr;
            d.date = parseDate(d.date2);
       });

var filterData = gwStats.filter(function(d){return d.site === gwID.toString(); });
var todayGW = filterData.filter(function(d){ return d.julian === recentDate; });
//console.log(filterData);
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
//console.log(filterData); 
//console.log(Ymed);

var rd2 = todayGW[0].end_yr + "-" + todayGW[0].date2.substring(5,10);
//console.log(rd2)

document.getElementById("selectGWMetadata").innerHTML = "Data from: " + filterData[0].start_yr + "-" + 
  filterData[0].end_yr + " <br><span style='color: rgb(26,131,130);'>The last measurement was taken on " + 
  parseDate(rd2).toLocaleDateString("en-US") + ".</span><br><br>";

/*#####################################################################################
         PLOT BY STATUS AS MARKERS
#####################################################################################*/
//Create Plotly Traces
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
  name: 'Current Yr',
  line: { color: 'rgb(26,121,131)',   width: 3  }
};


var data2; var x_axis_format = '%b-%d';
if(gwPlotType === "on"){
  x_axis_format =  '%b-%d';
  data2 = [trace10, trace25, trace50, trace75, trace90, traceThisYear];
}

//#####################################################################################
//         PLOT BY STATUS AS MARKERS
//#####################################################################################//
//read in long-term gw levels
d3.csv("data/gw/all_gw_status.csv").then(function(gwLevels){
    gwLevels.forEach(function(d){
            d.julian = +d.julian;
            d.flow = +d.depth_ft;
            d.date = parseDate(d.date);
       });
  //console.log(gwLevels)
  var selGWLevels = gwLevels.filter(function(d){return d.site === gwID.toString(); });
  var xDate = selGWLevels.map(function(d) {return d.date; });
  var yDepth = selGWLevels.map(function(d) {return d.flow; });
  var colorPoints = selGWLevels.map(function(d) {return d.colorStatus; });
  var streamStatus = selGWLevels.map(function(d) {return d.status; });
    var minVal = Math.max(yDepth);

  traceColorStatus = {
    type: 'scatter',
    x: xDate,  y: yDepth,
    text: streamStatus,
    mode: 'lines+markers',
    name: 'water level',
    marker: { color: colorPoints, size: 5, opacity: 0.8},
    line: { color: 'gray',  width: 1},
    hovertemplate:
              "<b>%{text}</b><br>" +
              "Depth (ft): %{y:.2f}<br>" +
              "Date: %{x}"
  };

  if(gwPlotType === "off"){
    x_axis_format =  '%b-%d-%Y';
    data2 = [traceColorStatus];
  }

  var gwlayout2 = {
    yaxis: {
        title: "Feet below surface (ft)",
        titlefont: {color: 'rgb(0, 0, 0)', size: 14},
        tickfont: {color: 'rgb(0, 0, 0)', size: 12},
        showline: true,
        showgrid: false,
        range: [0, minVal],
        autorange: "reversed"
    },
    xaxis: {
      showline: true,
      title: '',
      titlefont: {color: 'rgb(0, 0, 0)', size: 14},
      tickfont: {color: 'rgb(0, 0, 0)', size: 12},
      tickformat: x_axis_format,
    },
    height: 350,
    showlegend: true,
    legend: {x: 0, y: 0.95, xanchor: 'left', yanchor: 'right'},
    margin: {t: 30, b: 30, r: 30, l: 50 },
    shapes: [{
      type: 'line', xref: 'paper', yref: 'y',
      x0: 0, x1: 1, y0:0, y1: 0,
      line: {color: "#745508", width: "2"}
    }],
    annotations: [
        //above ground
          { xref: 'paper', yref: 'paper', //ref is assigned to x values
            x: 0.6, y: 1,
            xanchor: 'left', yanchor: 'top',
            text: "Land Surface", 
            font: {family: 'verdana', size: 11, color: '#745508'},
            showarrow: false,
          }
    ]
};

//console.log(data);
Plotly.newPlot('gwPlot2', data2, gwlayout2, config);
});//end D3
});//end D3


//#####################################################################################
//         PLOT BY STATUS AS MARKERS
//#####################################################################################//

//read in stream stats
d3.csv("data/gw/all_gw_annual.csv").then(function(gwAnnual){
  gwAnnual.forEach(function(d){
          d.flow = +d.medianDepth;
          d.year = +d.year;
     });

var selGWAnnual = gwAnnual.filter(function(d){return d.site === gwID.toString(); });
var xYear = selGWAnnual.map(function(d) {return d.year; });
var yDepth = selGWAnnual.map(function(d) {return d.flow; });
var minVal = Math.max(yDepth);

traceAnnual = {
  type: 'scatter',
  x: xYear,  y: yDepth,
  text: "median Depth",
  mode: 'lines+markers',
  name: 'Mean Water Levels',
  marker: { color: "black", size: 5, opacity: 0.8},
  line: { color: 'gray',  width: 1},
  hovertemplate:
            "Mean Depth (ft): %{y:.2f} in %{x}"
};
var gwlayout3 = {
  yaxis: {
      title: "Feet below surface (ft)",
      titlefont: {color: 'rgb(0, 0, 0)', size: 14},
      tickfont: {color: 'rgb(0, 0, 0)', size: 12},
      showline: true,
      showgrid: false,
      range: [0, minVal],
      autorange: "reversed"
  },
  xaxis: {
    showline: true,
    title: '',
    titlefont: {color: 'rgb(0, 0, 0)', size: 14},
    tickfont: {color: 'rgb(0, 0, 0)', size: 12},
  },
  height: 300,
  showlegend: true,
  legend: {x: 0, y: 0.95, xanchor: 'left', yanchor: 'right'},
  margin: {t: 30, b: 30, r: 30, l: 50 },
  shapes: [{
    type: 'line', xref: 'paper', yref: 'y',
    x0: 0, x1: 1, y0:0, y1: 0,
    line: {color: "#745508", width: "2"}
  }],
  annotations: [
      //above ground
        { xref: 'paper', yref: 'paper', //ref is assigned to x values
          x: 0.6, y: 1,
          xanchor: 'left', yanchor: 'top',
          text: "Land Surface", 
          font: {family: 'verdana', size: 11, color: '#745508'},
          showarrow: false,
        }
  ]
};
var data3 = [traceAnnual];
Plotly.newPlot('gwPlot3', data3, gwlayout3, config);
});//end D3
} //END CREATE GROUNDWATER TAB FUNCTION ##########################################################

//#####################################################################################
//         create plot for average monthly observations
//#####################################################################################//

function plotGroundwater(gwID, checkedGW) {
  
  document.getElementById('gwPlot4').innerHTML = ""; //set blank plot
  //parse date to scale axis
  parseDate = d3.timeParse("%Y-%m-%d");

  d3.csv("data/gw/all_monthly_avg.csv").then(function (gwMonthly) {
      
    gwMonthly.forEach(function (d) {
      d.mean_depth_ft = +d.mean_depth_ft;
      d.month = +d.month;
      d.year = +d.year;
    });

    var selGWMonthly = gwMonthly.filter(function(d){
      return d.site === gwID.toString(); 
    });
    

    // create a trace for each year
    var data4 = [];
    var xMonth = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    ];

    var yDepth = selGWMonthly.map(function(d) {return d.mean_depth_ft; });
    var minVal = Math.max(yDepth);
    
    var yOther = [];
    var OtherYearTrace;

    //draw the traces for all years but current
    var xYear2 = [];
    var minYear = d3.min(selGWMonthly.map(function (d) {  return d.year; }) );
    for (var i = minYear; i <= 2023; i++) {
      xYear2.push(i);
    }
    var showLegVal = true;
    for (i = 0; i < xYear2.length - 1; i++) {
      tempSelect = xYear2[i];
      temp = selGWMonthly.filter(function (d) {
        return d.year === tempSelect;
      });
      tempName = "Mean Depth (ft): %{y:.2f} in %{x} " + tempSelect;
      yOther = temp.map(function (d) {
        return d.mean_depth_ft;
      });
      //create individual trace
      if (i > 0) {
        showLegVal = false;
      }
      OtherYearTrace = {
        x: xMonth,
        y: yOther,
        mode: "lines",
        type: "scatter",
        hovertemplate: tempName,
        opacity: 0.4,
        line: { color: "#c5c5c5", width: 1 }, //light coral
        name: "years",
        showlegend: showLegVal,
      };
      //push trace
      data4.push(OtherYearTrace); 
      console.log(OtherYearTrace)
    }// end for loop

    //draw other selected years
    var selectYears;
    var selectTraces;
    //set array of colors
    var colorLineAll = [
      "rgb(26,121,131)",
      "#567258",
      "#bf9f4c",
      "#b9b59f",
      "#6f634d",
      "#314837",
      "#b0d76f",
      "#0ed0d0",
      "#246f8f",
      "5234578",
      "#900909",
      "#d16014",
      "#58381f",
    ];

    for (i = 0; i < checkedGW.length; i++) {
      tempSelect = Number(checkedGW[i]);
      selectYears = selGWMonthly
        .filter(function (d) {
          return d.year === tempSelect;
        })
        .map(function (d) {
          return d.mean_depth_ft;
        });
      tempName = "Mean Depth (ft): %{y:.2f} in %{x}, " + tempSelect;
      colorLine = colorLineAll[i];
      if (tempSelect === 2011) { colorLine = "red"; } // highlight drought years

      selectTraces = {
        x: xMonth,
        y: selectYears,
        mode: "lines+markers",
        type: "scatter",
        hovertemplate: "Mean Depth (ft): %{y:.2f} in %{x}, " + tempSelect,
        opacity: 1,
        marker: { color: colorLine, size: 6 },
        line: { color: colorLine, width: 2 },
        name: tempSelect,
        showlegend: true,
      };
      data4.push(selectTraces);
    }

    //draw 2023 year
    var yCurrent = selGWMonthly
      .filter(function (d) {
        return d.year === currentYear;
      })
      .map(function (d) {
        return d.mean_depth_ft;
      });
    var trace2023 = {
      x: xMonth,
      y: yCurrent,
      mode: "lines+markers",
      type: "scatter",
      hovertemplate: "Mean Depth (ft): %{y:.2f} in %{x}, " + currentYear,
      opacity: 1,
      marker: { color: "black", size: 6 },
      line: { color: "black", width: 3 },
      name: currentYear,
      showlegend: true,
    };
    data4.push(trace2023);

    //PLOT CHART
    var gwlayout4 = {
      yaxis: {
        title: "Feet below surface (ft)",
        titlefont: {color: 'rgb(0, 0, 0)', size: 14},
        tickfont: {color: 'rgb(0, 0, 0)', size: 12},
        showline: true,
        showgrid: false,
        range: [0, minVal],
        autorange: "reversed"
      },
      xaxis: {
        showline: true,
        showgrid: true,
        showticklabels: true,
        tickformat: "%b-%d",
        title: "",
        titlefont: { color: "rgb(0, 0, 0)", size: 14 },
        tickfont: { color: "rgb(0, 0, 0)", size: 12 },
      },
      hovermode: "closest",
      height: 375,
      showlegend: true,
      legend: {x: 0, y: 0.95, xanchor: 'left', yanchor: 'right'},
      margin: {t: 50, b: 30, r: 10, l: 50 },
      shapes: [{
        type: 'line', xref: 'paper', yref: 'y',
        x0: 0, x1: 1, y0:0, y1: 0,
        line: {color: "#745508", width: "2"}
      }],
      annotations: [
        //above ground
        { xref: 'paper', yref: 'paper', //ref is assigned to x values
          x: 0.6, y: 1,
          xanchor: 'left', yanchor: 'top',
          text: "Land Surface", 
          font: {family: 'verdana', size: 11, color: '#745508'},
          showarrow: false,
        },
      ]
    };
    Plotly.newPlot('gwPlot4', data4, gwlayout4, config);
    console.log(data4)
  }); // end D3
} //END CREATE MONTHLY CHART FUNCTION ##########################################################


