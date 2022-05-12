//#####################################################################################
//         create plot for average monthly observations
//#####################################################################################//
function createTraceGW(target) {
  checkedGW = [];
  $("input[name='checkGWYear']:checked").each(function () {
      checkedGW.push($(this).val());
  });

  Plotly.purge("gwPlot4");
  plotGroundwater(gwID, checkedGW);
  return checkedGW;
}

function plotGroundwater(gwID, checkedGW) {
  
  document.getElementById("gwPlot4").innerHTML = ""; //set blank plot
  //parse date to scale axis
  parseDate = d3.timeParse("%Y-%m-%d");

  d3.csv("data/gw/all_boerne_monthly_avg.csv").then(function (gwMonthly) {
      
    gwMonthly.forEach(function (d) {
      d.mean_depth_ft = +d.mean_depth_ft;
      d.month = +d.month;
      d.year = +d.year;
    });

    var selGWMonthly = gwMonthly.filter(function(d){
      return d.site === gwID.toString(); 
    });
    console.log(selGWMonthly)

    // create a trace for each year
    var data = [];
    var xMonth = selGWMonthly.map(function(d) {return d.month; });
    //var xMonth = [
      //"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    //];

    var yOther = [];
    var OtherYearTrace;

    //draw the traces for all years but current
    var xYear2 = [];
    var minYear = d3.min(selGWMonthly.map(function (d) {  return d.year; }) );
    for (var i = minYear; i <= 2022; i++) {
      xYear2.push(i);
    }
    var showLegVal = true;
    for (i = 0; i < xYear2.length - 1; i++) {
      tempSelect = xYear2[i];
      temp = selGWMonthly.filter(function (d) {
        return d.year === tempSelect;
      });
      tempName = "Median Depth (ft): %{y:.2f} in %{x} " + tempSelect;
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
      data.push(OtherYearTrace); 
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
      tempName = "Median Depth (ft): %{y:.2f} in %{x}, " + tempSelect;
      colorLine = colorLineAll[i];
      if (tempSelect === 2011) { colorLine = "red"; } // highlight drought years

      selectTraces = {
        x: xMonth,
        y: selectYears,
        mode: "lines+markers",
        type: "scatter",
        hovertemplate: "Median Depth (ft): %{y:.2f} in %{x}, " + tempSelect,
        opacity: 1,
        marker: { color: colorLine, size: 6 },
        line: { color: colorLine, width: 2 },
        name: tempSelect,
        showlegend: true,
      };
      data.push(selectTraces);
    }

    //draw 2022 year
    var yCurrent = selGWMonthly
      .filter(function (d) {
        return d.year === currentYear;
      })
      .map(function (d) {
        return d.mean_depth_ft;
      });
    var trace2022 = {
      x: xMonth,
      y: yCurrent,
      mode: "lines+markers",
      type: "scatter",
      hovertemplate: "Median Depth (ft): %{y:.2f} in %{x}, " + currentYear,
      opacity: 1,
      marker: { color: "black", size: 6 },
      line: { color: "black", width: 3 },
      name: currentYear,
      showlegend: true,
    };
    data.push(trace2022);

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
        showline: false,
        showgrid: true,
        showticklabels: true,
        tickformat: "%b-%d",
        title: "",
        titlefont: { color: "rgb(0, 0, 0)", size: 14 },
        tickfont: { color: "rgb(0, 0, 0)", size: 12 },
      },
      hovermode: "closest",
      height: 300,
      showlegend: true,
      legend: {x: 0, y: 0.95, xanchor: 'left', yanchor: 'right'},
      margin: {t: 30, b: 30, r: 10, l: 35 },
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
    Plotly.newPlot("gwPlot4", data, gwlayout4, config);
  }); // end D3
} //END CREATE MONTHLY CHART FUNCTION ##########################################################




