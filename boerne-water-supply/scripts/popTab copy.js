//##################################################################################################################
//               POPULATION DATA
//##################################################################################################################
function createTracePop(target) {
    checkedPop = [];
    $("input[name='checkPopYear']:checked").each(function () {
        checkedPop.push($(this).val());
    });

    Plotly.purge("popPlot");
    plotPopulation(myUtilityID, checkedPop);
    return checkedPop;
}

//##################################################################################################################
//               READ IN TIME SERIES POPULATION DATA
//##################################################################################################################
function plotPopulation(myUtilityID, checkedPop) {
    //parse date to scale axis
    parseDate = d3.timeParse("%Y-%m-%d");

    //console.log(checkedPop);
    //read in pop data
    d3.csv("data/demand/all_boerne_pop.csv").then(function (popData) {
        popData.forEach(function (d) {
            d.date = parseDate(d.date);
            d.clb_pop = +d.clb_pop;
            d.wsb_pop = +d.wsb_pop;
            d.month = +d.month;
            d.year = +d.year;
        });

        var selPop = popData.filter(function (d) {
            return d.pwsid === myUtilityID && d.year >= 1997;
        });
        //console.log(selPop)

        if (selPop.length <= 0) {
            console.log("no utility");
            //Plotly.purge('popPlot');
            document.getElementById("demandTitle").innerHTML =
                "Select a utility with data to see population growth";
            document.getElementById("demandPlot").innerHTML =
                '<img src="img/demand_chart_icon.png" style="width: 350px; height: 350px; display: block; margin-left: auto; margin-right: auto;">';
        }

        if (selPop.length > 0) {
            document.getElementById("popPlot").innerHTML = ""; //set blank plot
            var maxYValue = (
                d3.max(selPop, function (d) {
                    return d.clb_pop;
                }) * 1.1
            ).toFixed(0);
            //console.log(maxYValue);
            //create multiple traces
            var data = [];
            var xMonths = selPop.map(function (d) {
                return d.date;
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
                temp = selPop.filter(function (d) {
                    return d.year === tempSelect;
                });
                tempName = "%{y:.1f} thousands in " + tempSelect;
                //xDate = temp.map(function(d){ return d.date; });
                yOther = temp.map(function (d) {
                    return d.clb_pop;
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

            for (i = 0; i < checkedPop.length; i++) {
                tempSelect = Number(checkedPop[i]);
                selectYears = selPop
                    .filter(function (d) {
                        return d.year === tempSelect;
                    })
                    .map(function (d) {
                        return d.clb_pop;
                    });
                tempName = "%{y:.1f} thousands in %{x}, " + tempSelect;
                colorLine = colorLineAll[i];

                selectTraces = {
                    x: xMonth,
                    y: selectYears,
                    mode: "lines",
                    type: "scatter",
                    hovertemplate: "%{y:.1f} thousands in %{x}, " + tempSelect,
                    opacity: 1,
                    line: { color: colorLine, width: 2 },
                    name: tempSelect,
                    showlegend: true,
                };
                data.push(selectTraces);
            }

            //draw median and selected year
            selPopNow = selPop.filter(function (d) {
                return d.year === currentYear;
            });
            var ySelect = selPopNow.map(function (d) {
                return d.clb_pop;
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
                name: "2021",
                showlegend: true,
                hovertemplate: "%{y:.1f} thousands in %{x}",
            };

            var layout = {
                yaxis: {
                    title: "Yearly Population",
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
            Plotly.newPlot("popPlot", data, layout, config);

        } //end if we have utility data for selectect utility
    }); // end D3
} //END CREATE CHART FUNCTION ##########################################################






d3.csv("data/demand/all_boerne_pop.csv").then(function (popData) {
    popData.forEach(function (d) {
        d.date3 = parseDate("2022-" + d.date.substring(5, d.date.length));
        d.clb_pop = +d.clb_pop;
        d.wsb_pop = +d.wsb_pop;
        d.month = +d.month;
        d.year = +d.year;
    });

    let pop1 = [];
    let pop2 = [];
    let labels = [];

    for (let i=0; i<popData.length; i++) {

        let year = popData[i].year;
        labels.push(year);

        let clbpop = popData[i].clb_pop;
        pop1.push(clbpop);

        let wsbpop = popData[i].wsb_pop;
        pop2.push(wsbpop);
    }

    let options = {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                data: pop1, pop2,
                fill: false,
                pointRadius: 0,
                pointHoverRadius: 0,
                borderColor: 'rgb(100,100,100)'
            }]
        }
    };

    let chart = new
    Chart(document.getElementById('pop'), options);

});