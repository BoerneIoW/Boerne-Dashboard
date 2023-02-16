function createTraceDemand(target) {
    checkedDemand = [];
    $("input[name='checkDemandYear']:checked").each(function () {
        checkedDemand.push($(this).val());
    });

    Plotly.purge("demandPlot");
    Plotly.purge("demandCumPlot");
    createDemandInfo(myUtilityID, checkedDemand);
    return checkedDemand;
}

//##################################################################################################################
//               READ IN TIME SERIES
//##################################################################################################################
function createDemandInfo(myUtilityID, checkedDemand) {
    //parse date to scale axis
    parseDate = d3.timeParse("%Y-%m-%d");

    //console.log(checkedDemand);
    //read in demand data
    d3.csv("data/demand/all_total_demand.csv").then(function (demandData) {
        demandData.forEach(function (d) {
            d.date3 = parseDate("2023-" + d.date2.substring(5, d.date2.length));
            d.demand_mgd = +d.demand_mgd;
            d.month = +d.month;
            d.year = +d.year;
            d.peak_demand = +d.peak_demand;
        });

        var selDemand = demandData.filter(function (d) {
            return d.pwsid === myUtilityID && d.year >= 1997;
        });
        //console.log(selDemand)

        if (selDemand.length <= 0) {
            console.log("no utility");
            //Plotly.purge('demandPlot');
            document.getElementById("demandTitle").innerHTML =
                "Select a utility with data to see demand";
            document.getElementById("demandPlot").innerHTML =
                '<img src="img/demand_chart_icon.png" style="width: 350px; height: 350px; display: block; margin-left: auto; margin-right: auto;">';
        }

        if (selDemand.length > 0) {
            document.getElementById("demandPlot").innerHTML = ""; //set blank plot
            var maxYValue = (
                d3.max(selDemand, function (d) {
                    return d.peak_demand;
                }) * 1.1
            ).toFixed(0);
            //console.log(maxYValue);
            //create multiple traces
            var data = [];
            var xMonths = selDemand.map(function (d) {
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
            var OtherYearTrace;

            for (i = 0; i < xYears.length - 1; i++) {
                tempSelect = xYears[i];
                temp = selDemand.filter(function (d) {
                    return d.year === tempSelect;
                });
                tempName = "%{y:.1f} mgd in " + tempSelect;
                //xDate = temp.map(function(d){ return d.date; });
                yOther = temp.map(function (d) {
                    return d.demand_mgd;
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

            for (i = 0; i < checkedDemand.length; i++) {
                tempSelect = Number(checkedDemand[i]);
                selectYears = selDemand
                    .filter(function (d) {
                        return d.year === tempSelect;
                    })
                    .map(function (d) {
                        return d.demand_mgd;
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
            selDemandNow = selDemand.filter(function (d) {
                return d.year === currentYear;
            });
            var ySelect = selDemandNow.map(function (d) {
                return d.demand_mgd;
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
                    title: "Daily Demand (MGD)",
                    titlefont: { color: "rgb(0, 0, 0)", size: 14 },
                    tickfont: { color: "rgb(0, 0, 0)", size: 12 },
                    showline: false,
                    showgrid: true,
                    showticklabels: true,
                    range: [0, 6],
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
                margin: { t: 30, b: 50, r: 10, l: 50 },
            };


            data.push(seltrace);
            Plotly.newPlot("demandPlot", data, layout, config);

            //load document names
            if (myUtility === "none") {
                document.getElementById("demandTitle").innerHTML =
                    "Select a utility on the map to learn more";
            }

            if (myUtility !== "none") {
                var selCurDemand = selDemand.map(function (d) {
                    return d.demand_mgd;
                });
                var thisWeekDemand = selCurDemand[selCurDemand.length - 1];
                var lastWeekDemand = selCurDemand[selCurDemand.length - 8];

                //now how does this compare to last week?
                var demandTrajectory;
                if (thisWeekDemand > lastWeekDemand) {
                    demandTrajectory = "higher";
                }
                if (thisWeekDemand < lastWeekDemand) {
                    demandTrajectory = "lower";
                }
                if (thisWeekDemand.toFixed(1) === lastWeekDemand.toFixed(1)) {
                    demandTrajectory = "equal";
                }

                document.getElementById("demandTitle").innerHTML =
                    myUtility +
                    " has " +
                    demandTrajectory +
                    " demand than the previous marked week";
            }
        } //end if we have utility data for selectect utility
    }); // end D3
    //##################################################################################################################################
    //                     END THAT PLOT
    //##################################################################################################################################

    //Cmulative data plot
    d3.csv("data/demand/all_demand_cum.csv").then(function (cumdemand) {
        cumdemand.forEach(function (d) {
            //d.date = parseDate(("2020-"+d.date));
            d.year = +d.year;
            d.julian = +d.julian;
            d.demand_mgd = +d.demand_mgd;
        }); //end for each

        //if dont use julian, Feb 29th creates problems
        var seldemand = cumdemand.filter(function (d) {
            return d.pwsid === myUtilityID && d.date !== "Feb-29";
        });

        //console.log(seldemand);
        //create a trace for each year
        var cumdata = [];
        var xJulian = [];
        for (var i = 0; i <= 365; i++) {
            xJulian.push(i);
        }
        var yOther;
        var OtherYearTrace;
        //draw the traces for all years but current
        var xYear = [];
        var minYear = d3.min(
            seldemand.map(function (d) {
                return d.year;
            })
        );

        for (var i = minYear; i <= 2020; i++) {
            xYear.push(i);
        }

        for (i = 0; i < xYear.length - 1; i++) {
            tempSelect = xYear[i];
            temp = seldemand.filter(function (d) {
                return d.year === tempSelect;
            });
            tempName = "%{y:.1f} mgd by %{x} of " + tempSelect;
            xJulian = temp.map(function (d) {
                return d.date;
            });
            yOther = temp.map(function (d) {
                return d.demand_mgd;
            });
            //create individual trace
            OtherYearTrace = {
                x: xJulian,
                y: yOther,
                mode: "lines",
                type: "scatter",
                hovertemplate: tempName,
                opacity: 0.4,
                line: { color: "#c5c5c5", width: 1 }, //light coral
                name: "",
            };
            //push trace
            cumdata.push(OtherYearTrace);
        } // end for loop

        //draw other selected years
        var selectYears;
        var selectTraces;
        var colorLine;
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

        for (i = 0; i < checkedDemand.length; i++) {
            tempSelect = Number(checkedDemand[i]);
            selectYears = seldemand
                .filter(function (d) {
                    return d.year === tempSelect;
                })
                .map(function (d) {
                    return d.demand_mgd;
                });
            tempName = "%{y:.1f} mgd by %{x} day of " + tempSelect;
            xJulian = temp.map(function (d) {
                return d.date;
            });
            colorLine = colorLineAll[i];
            if (tempSelect === 2011) {
                colorLine = "red";
            }
           // if (tempSelect === 2007) {
           //     colorLine = "darkred";
           // }
            selectTraces = {
                x: xJulian,
                y: selectYears,
                mode: "lines",
                type: "scatter",
                hovertemplate: "%{y:.1f} mgd by %{x} of " + tempSelect,
                opacity: 1,
                line: { color: colorLine, width: 2 },
                name: "",
            };
            cumdata.push(selectTraces);
        }

        //draw current year
        var yCurrent = seldemand
            .filter(function (d) {
                return d.year === currentYear;
            })
            .map(function (d) {
                return d.demand_mgd;
            });
        xJulian = seldemand
            .filter(function (d) {
                return d.year === currentYear;
            })
            .map(function (d) {
                return d.date;
            });
        var trace2020 = {
            x: xJulian,
            y: yCurrent,
            mode: "lines",
            type: "scatter",
            hovertemplate: "%{y:.1f} mgd by %{x} " + currentYear,
            opacity: 1,
            line: { color: "black", width: 3 },
            name: "",
        };
        cumdata.push(trace2020);

        //PLOT CHART
        var layout = {
            yaxis: {
                title: "Cumulative Demand (MG)",
                titlefont: { color: "rgb(0, 0, 0)", size: 14 },
                tickfont: { color: "rgb(0, 0, 0)", size: 12 },
                showline: false,
                showgrid: false,
                showticklabels: true,
                range: [0, 1500],
            },
            xaxis: {
                showline: false,
                showgrid: false,
                showticklabels: true,
                title: "",
                tickformat: "%b-%d",
                titlefont: { color: "rgb(0, 0, 0)", size: 14 },
                tickfont: { color: "rgb(0, 0, 0)", size: 12 },
            },
            hovermode: "closest",
            height: 300,
            showlegend: false,
            margin: { t: 30, b: 50, r: 10, l: 50 },

            shapes: [
                {
                    type: "line",
                    x0: 31,
                    y0: 0,
                    x1: 31,
                    y1: 1,
                    yref: "paper",
                    layer: "below",
                    line: { color: "grey", width: 1, dash: "dot" },
                },
                {
                    type: "line",
                    x0: 59,
                    y0: 0,
                    x1: 60,
                    y1: 1,
                    yref: "paper",
                    layer: "below",
                    line: { color: "grey", width: 1, dash: "dot" },
                },
                {
                    type: "line",
                    x0: 90,
                    y0: 0,
                    x1: 91,
                    y1: 1,
                    yref: "paper",
                    layer: "below",
                    line: { color: "grey", width: 1, dash: "dot" },
                },
                {
                    type: "line",
                    x0: 120,
                    y0: 0,
                    x1: 121,
                    y1: 1,
                    yref: "paper",
                    layer: "below",
                    line: { color: "grey", width: 1, dash: "dot" },
                },
                {
                    type: "line",
                    x0: 151,
                    y0: 0,
                    x1: 152,
                    y1: 1,
                    yref: "paper",
                    layer: "below",
                    line: { color: "grey", width: 1, dash: "dot" },
                },
                {
                    type: "line",
                    x0: 181,
                    y0: 0,
                    x1: 182,
                    y1: 1,
                    yref: "paper",
                    layer: "below",
                    line: { color: "grey", width: 1, dash: "dot" },
                },
                {
                    type: "line",
                    x0: 213,
                    y0: 0,
                    x1: 213,
                    y1: 1,
                    yref: "paper",
                    layer: "below",
                    line: { color: "grey", width: 1, dash: "dot" },
                },
                {
                    type: "line",
                    x0: 244,
                    y0: 0,
                    x1: 244,
                    y1: 1,
                    yref: "paper",
                    layer: "below",
                    line: { color: "grey", width: 1, dash: "dot" },
                },
                {
                    type: "line",
                    x0: 274,
                    y0: 0,
                    x1: 274,
                    y1: 1,
                    yref: "paper",
                    layer: "below",
                    line: { color: "grey", width: 1, dash: "dot" },
                },
                {
                    type: "line",
                    x0: 305,
                    y0: 0,
                    x1: 305,
                    y1: 1,
                    yref: "paper",
                    layer: "below",
                    line: { color: "grey", width: 1, dash: "dot" },
                },
                {
                    type: "line",
                    x0: 335,
                    y0: 0,
                    x1: 335,
                    y1: 1,
                    yref: "paper",
                    layer: "below",
                    line: { color: "grey", width: 1, dash: "dot" },
                },
            ],

            annotations: [
                {
                    xref: "x",
                    yref: "paper",
                    x: 1,
                    y: 1,
                    xanchor: "left",
                    yanchor: "top",
                    text: "Jan",
                    showarrow: false,
                    font: { size: 10 },
                },
                {
                    xref: "x",
                    yref: "paper",
                    x: 33,
                    y: 1,
                    xanchor: "left",
                    yanchor: "top",
                    text: "Feb",
                    showarrow: false,
                    font: { size: 10 },
                },
                {
                    xref: "x",
                    yref: "paper",
                    x: 61,
                    y: 1,
                    xanchor: "left",
                    yanchor: "top",
                    text: "Mar",
                    showarrow: false,
                    font: { size: 10 },
                },
                {
                    xref: "x",
                    yref: "paper",
                    x: 92,
                    y: 1,
                    xanchor: "left",
                    yanchor: "top",
                    text: "Apr",
                    showarrow: false,
                    font: { size: 10 },
                },
                {
                    xref: "x",
                    yref: "paper",
                    x: 122,
                    y: 1,
                    xanchor: "left",
                    yanchor: "top",
                    text: "May",
                    showarrow: false,
                    font: { size: 10 },
                },
                {
                    xref: "x",
                    yref: "paper",
                    x: 153,
                    y: 1,
                    xanchor: "left",
                    yanchor: "top",
                    text: "Jun",
                    showarrow: false,
                    font: { size: 10 },
                },
                {
                    xref: "x",
                    yref: "paper",
                    x: 183,
                    y: 1,
                    xanchor: "left",
                    yanchor: "top",
                    text: "Jul",
                    showarrow: false,
                    font: { size: 10 },
                },
                {
                    xref: "x",
                    yref: "paper",
                    x: 214,
                    y: 1,
                    xanchor: "left",
                    yanchor: "top",
                    text: "Aug",
                    showarrow: false,
                    font: { size: 10 },
                },
                {
                    xref: "x",
                    yref: "paper",
                    x: 245,
                    y: 1,
                    xanchor: "left",
                    yanchor: "top",
                    text: "Sep",
                    showarrow: false,
                    font: { size: 10 },
                },
                {
                    xref: "x",
                    yref: "paper",
                    x: 275,
                    y: 1,
                    xanchor: "left",
                    yanchor: "top",
                    text: "Oct",
                    showarrow: false,
                    font: { size: 10 },
                },
                {
                    xref: "x",
                    yref: "paper",
                    x: 306,
                    y: 1,
                    xanchor: "left",
                    yanchor: "top",
                    text: "Nov",
                    showarrow: false,
                    font: { size: 10 },
                },
                {
                    xref: "x",
                    yref: "paper",
                    x: 336,
                    y: 1,
                    xanchor: "left",
                    yanchor: "top",
                    text: "Dec",
                    showarrow: false,
                    font: { size: 10 },
                },
            ],
        };
        Plotly.newPlot("demandCumPlot", cumdata, layout, config);
    }); //end d3
} //END CREATE CHART FUNCTION ##########################################################
