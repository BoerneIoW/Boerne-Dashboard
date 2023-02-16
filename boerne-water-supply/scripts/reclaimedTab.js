function createTraceReclaimed(target) {
    checkedReclaimed = [];
    $("input[name='checkReclaimedYear']:checked").each(function () {
        checkedReclaimed.push($(this).val());
    });

    Plotly.purge("reclaimedPlot");
    Plotly.purge("percentoftotalPlot");
    createReclaimedInfo(myUtilityID, checkedReclaimed);
    return checkedReclaimed;
}

//##################################################################################################################
//               READ IN TIME SERIES
//##################################################################################################################
function createReclaimedInfo(myUtilityID, checkedReclaimed) {
    //parse date to scale axis
    parseDate = d3.timeParse("%Y-%m-%d");

    //console.log(checkedReclaimed);
    //read in reclaimed data
    d3.csv("data/demand/all_reclaimed_water.csv").then(function (reclaimedData) {
        reclaimedData.forEach(function (d) {
            d.date3 = parseDate("2023-" + d.date2.substring(5, d.date2.length));
            d.reclaimed = +d.reclaimed;
            d.month = +d.month;
            d.year = +d.year;
            d.peak_reclaimed = +d.peak_reclaimed;
        });

        var selReclaimed = reclaimedData.filter(function (d) {
            return d.pwsid === myUtilityID && d.year >= 1997;
        });
        //console.log(selReclaimed)

        if (selReclaimed.length <= 0) {
            console.log("no utility");
            //Plotly.purge('reclaimedPlot');
            document.getElementById("reclaimedTitle").innerHTML =
                "Select a utility with data to see reclaimed water produced";
            document.getElementById("reclaimedPlot").innerHTML =
                '<img src="img/demand_chart_icon.png" style="width: 350px; height: 350px; display: block; margin-left: auto; margin-right: auto;">';
        }

        if (selReclaimed.length > 0) {
            document.getElementById("reclaimedPlot").innerHTML = ""; //set blank plot
            var maxYValue = (
                d3.max(selReclaimed, function (d) {
                    return d.peak_reclaimed;
                }) * 1.1
            ).toFixed(0);
            //console.log(maxYValue);
            //create multiple traces
            var data = [];
            var xMonths = selReclaimed.map(function (d) {
                return d.date2;
            });
            let xMonth = xMonths.filter(
                (item, i, ar) => ar.indexOf(item) === i
            );

            //draw the traces for all years but current
            var xYears = [];
            for (var i = 2000; i <= currentYear; i++) {
                xYears.push(i);
            }

            var yOther = [];
            var otherYearTrace;

            for (i = 0; i < xYears.length - 1; i++) {
                tempSelect = xYears[i];
                temp = selReclaimed.filter(function (d) {
                    return d.year === tempSelect;
                });
                tempName = "%{y:.1f} mgd in " + tempSelect;
                //xDate = temp.map(function(d){ return d.date; });
                yOther = temp.map(function (d) {
                    return d.reclaimed;
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

            for (i = 0; i < checkedReclaimed.length; i++) {
                tempSelect = Number(checkedReclaimed[i]);
                selectYears = selReclaimed
                    .filter(function (d) {
                        return d.year === tempSelect;
                    })
                    .map(function (d) {
                        return d.reclaimed;
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
            selReclaimedNow = selReclaimed.filter(function (d) {
                return d.year === currentYear;
            });
            var ySelect = selReclaimedNow.map(function (d) {
                return d.reclaimed;
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
                name: "2023",
                showlegend: true,
                hovertemplate: "%{y:.1f} mgd in %{x}",
            };

            var layout = {
                yaxis: {
                    title: "Daily Reclaimed Water Used (MGD)",
                    titlefont: { color: "rgb(0, 0, 0)", size: 14 },
                    tickfont: { color: "rgb(0, 0, 0)", size: 12 },
                    showline: false,
                    showgrid: true,
                    showticklabels: true,
                    range: [0, maxYValue],
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
                hovermode: "closest",
                height: 375,
                //showlegend: true,
                margin: { t: 20, b: 50, r: 10, l: 40 },
            };

            data.push(seltrace);
            Plotly.newPlot("reclaimedPlot", data, layout, config);

            //load document names
            if (myUtility === "none") {
                document.getElementById("reclaimedTitle").innerHTML =
                    "Select a utility on the map to learn more";
            }

            if (myUtility !== "none") {
                var selCurReclaimed = selReclaimed.map(function (d) {
                    return d.reclaimed;
                });
                var thisWeekReclaimed = selCurReclaimed[selCurReclaimed.length - 1];
                var lastWeekReclaimed = selCurReclaimed[selCurReclaimed.length - 8];

                //now how does this compare to last week?
                var reclaimedTrajectory;
                if (thisWeekReclaimed > lastWeekReclaimed) {
                    reclaimedTrajectory = "higher";
                }
                if (thisWeekReclaimed < lastWeekReclaimed) {
                    reclaimedTrajectory = "lower";
                }
                if (thisWeekReclaimed.toFixed(1) === lastWeekReclaimed.toFixed(1)) {
                    reclaimedTrajectory = "equal";
                }

                document.getElementById("reclaimedTitle").innerHTML =
                    myUtility +
                    " has " +
                    reclaimedTrajectory +
                    " reclaimed than last week";
            }
        } //end if we have utility data for selectect utility
    }); // end D3

    //##################################################################################################################################        
    //                     END THAT PLOT
    //##################################################################################################################################

    //Percent of Total data plot

    d3.csv("data/demand/all_reclaimed_percent_of_total.csv").then(function (reclaimedpercentData) {
        reclaimedpercentData.forEach(function (d) {
            d.date3 = parseDate("2023-" + d.date2.substring(5, d.date2.length));
            d.reclaimedpercent = +d.percent_of_total;
            d.month = +d.month;
            d.year = +d.year;
            d.peak_reclaimed = +d.peak_reclaimed;
        });

        var selReclaimedPercent = reclaimedpercentData.filter(function (d) {
            return d.pwsid === myUtilityID && d.year >= 1997;
        });
        //console.log(selReclaimedPercent)


        if (selReclaimedPercent.length > 0) {
            document.getElementById("percentoftotalPlot").innerHTML = ""; //set blank plot
            var maxYValue = 100
                
            //console.log(maxYValue);
            //create multiple traces
            var datapercent = [];
            var xMonths = selReclaimedPercent.map(function (d) {
                return d.date2;
            });
            let xMonth = xMonths.filter(
                (item, i, ar) => ar.indexOf(item) === i
            );

            //draw the traces for all years but current
            var xYears = [];
            for (var i = 2000; i <= currentYear; i++) {
                xYears.push(i);
            }

            var yOther = [];
            var otherYearTrace;

            for (i = 0; i < xYears.length - 1; i++) {
                tempSelect = xYears[i];
                temp = selReclaimedPercent.filter(function (d) {
                    return d.year === tempSelect;
                });
                tempName = "%{y:.1f}% of total in " + tempSelect;
                //xDate = temp.map(function(d){ return d.date; });
                yOther = temp.map(function (d) {
                    return d.percent_of_total;
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
                datapercent.push(OtherYearTrace);
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

            for (i = 0; i < checkedReclaimed.length; i++) {
                tempSelect = Number(checkedReclaimed[i]);
                selectYears = selReclaimedPercent
                    .filter(function (d) {
                        return d.year === tempSelect;
                    })
                    .map(function (d) {
                        return d.percent_of_total;
                    });
                tempName = "%{y:.1f}% of total in %{x}, " + tempSelect;
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
                    hovertemplate: "%{y:.1f}% of total in %{x}, " + tempSelect,
                    opacity: 1,
                    line: { color: colorLine, width: 2 },
                    name: tempSelect,
                    showlegend: true,
                };
                datapercent.push(selectTraces);
            }

            //draw median and selected year
            selReclaimedPercentNow = selReclaimedPercent.filter(function (d) {
                return d.year === currentYear;
            });
            var ySelect = selReclaimedPercentNow.map(function (d) {
                return d.percent_of_total;
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
                name: "2023",
                showlegend: true,
                hovertemplate: "%{y:.1f}% of total in %{x}",
            };

            var layout = {
                yaxis: {
                    title: "Reclaimed Percent of Total Water (%)",
                    titlefont: { color: "rgb(0, 0, 0)", size: 14 },
                    tickfont: { color: "rgb(0, 0, 0)", size: 12 },
                    showline: false,
                    showgrid: true,
                    showticklabels: true,
                    range: [0, maxYValue],
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
                hovermode: "closest",
                height: 375,
                //showlegend: true,
                margin: { t: 20, b: 50, r: 10, l: 40 },
            };

            datapercent.push(seltrace);
            Plotly.newPlot("percentoftotalPlot", datapercent, layout, config);

        } //end if we have utility data for selectect utility
    }); // end D3
} //END CREATE CHART FUNCTION ##########################################################
