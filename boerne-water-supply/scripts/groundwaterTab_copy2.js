//#####################################################################################
//         create plot for average monthly observations
//#####################################################################################//
function createTraceGW(target) {
  checkedGW = [];
  $("input[name='checkGWYear']:checked").each(function () {
      checkedGW.push($(this).val());
  });

  Plotly.purge("gwPlot4");
  createGWInfo(gwID, checkedGW);
  return checkedGW;
}

function createGWInfo(gwID, checkedGW) {

    //console.log(checkedGW);
    //read in demand data
    d3.csv("data/gw/all_boerne_monthly_avg.csv").then(function (gwMonthly) {
      
      gwMonthly.forEach(function (d) {
        d.monthlyflow = +d.mean_depth_ft;
        d.month = +d.month;
        d.year = +d.year;
      });

      var selGWMonthly = gwMonthly.filter(function(d){return d.site === gwID.toString(); });
      //console.log(selGWMonthly)

        

      if (selGWMonthly.length > 0) {
        document.getElementById("gwPlot4").innerHTML = ""; //set blank plot
        var minVal = Math.max(yDepth);
          
        //create multiple traces
        var data = [];
        var xMonths = selGWMonthly.map(function(d) {return d.month; });
        let xMonth = xMonths.filter(
          (item, i, ar) => ar.indexOf(item) === i
        );

        //draw the traces for all years but current
        var xYears = [];
        for (var i = 2000; i <= currentYear; i++) {
          xYears.push(i);
        }

        var yOther = [];
        var OtherYearTrace;

        for (i = 0; i < xYears.length - 1; i++) {
          tempSelect = xYears[i];
          temp = selGWMonthly.filter(function (d) {
            return d.year === tempSelect;
          });
          tempName = "%{y:.1f} mgd in " + tempSelect;
          //xDate = temp.map(function(d){ return d.date; });
          yOther = temp.map(function (d) {
            return d.mean_depth_ft;
          });
          //create individual trace
          var showLegVal = true;
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
        } // end for loop

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
        var colorLine;

        for (i = 0; i < checkedGW.length; i++) {
          tempSelect = Number(checkedGW[i]);
          selectYears = selGWMonthly
            .filter(function (d) {
              return d.year === tempSelect;
            })
            .map(function (d) {
              return d.mean_depth_ft;
            });
          tempName = "%{y:.1f} mgd in %{x}, " + tempSelect;
          colorLine = colorLineAll[i];
          if (tempSelect === 2011) {
            colorLine = "red";
          }
          // if (tempSelect === 2007) {
          //     colorLine = "darkred";
          // }

          selectTraces = {
            x: xMonth,
            y: selectYears,
            mode: "lines",
            type: "scatter",
            hovertemplate: "%{y:.1f} mgd in %{x}, " + tempSelect,
            opacity: 1,
            line: { color: colorLine, width: 2 },
            name: tempSelect,
            showlegend: true,
          };
          data.push(selectTraces);
        }

        //draw median and selected year
        selGWMonthlyNow = selGWMonthly.filter(function (d) {
          return d.year === currentYear;
        });
        var ySelect = selGWMonthlyNow.map(function (d) {
          return d.mean_depth_ft;
        });

        //PLOTLY
        var seltrace = {
          y: ySelect,
          x: xMonth,
          /*marker: {
      size: 6, color: "rgb(43,28,88",
      line: {color: 'black', width: 1}
      },*/
          line: { color: "rgb(43,28,88", width: 3 },
          mode: "lines",
          type: "scatter",
          name: "2022",
          showlegend: true,
          hovertemplate: "%{y:.1f} mgd in %{x}",
        };

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
            //range: [0, 15]
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

        data.push(seltrace);
        Plotly.newPlot("gwPlot4", data, gwlayout4, config);

      } //end if we have utility data for selectect utility
    }); // end D3
} //END CREATE CHART FUNCTION ##########################################################
