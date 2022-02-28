/*############################################################################################################################
#
#           FUNCTION TO CREATE DROUGHT PLOT OVER TIME BASE ON HUC SELECTION
#
#################################################################################################################################*/

///////////////////////////////////////////////////////////////////////////////////////////////////
function setHUCThis(target) {
    //Change variable
    myHUC = document.getElementById("setHUC").value;

    if (myHUC === "none") {
        Plotly.purge("droughtPlot");
        document.getElementById("hucDroughtTitle").innerHTML = "";
        document.getElementById("curDBlocks").style.display = "none";
    }

    if (myHUC !== "none") {
        plotDroughtTime(myHUC);
    }
    return myHUC;
} // end setStateThis function

function plotDroughtTime(myHUC) {
    //turno n drought
    document.getElementById("curDBlocks").style.display = "block";
    document.getElementById("droughtPlot").innerHTML = ""; //set blank plot
    //parse date to scale axis
    parseDate = d3.timeParse("%Y-%m-%d");
    //load current demand
    d3.csv("data_state/drought/percentAreaHUC.csv").then(function (drought) {
        drought.forEach(function (d) {
            d.date2 = parseDate(d.date);
            d.none = +d.none;
            d.d0x = +d.d0x;
            d.d1x = +d.d1x;
            d.d2x = +d.d2x;
            d.d3x = +d.d3x;
            d.d4x = +d.d4x;
        });
        var selDrought = drought.filter(function (d) {
            return d.huc8 === myHUC;
        });
        var currentDrought =
            selDrought[
                Object.keys(selDrought)[Object.keys(selDrought).length - 1]
            ];
        //console.log(currentDrought);

        //create a header and
        document.getElementById("hucDroughtTitle").innerHTML =
            "Percent of " +  currentDrought.name + " basin by drought status (" +  currentDrought.date + ")<br>";
        document.getElementById("dnonediv").innerHTML =  currentDrought.none + "%<br>none";
        document.getElementById("d0div").innerHTML = currentDrought.d0x + "%<br>mild";
        document.getElementById("d1div").innerHTML = currentDrought.d1x + "%<br>moderate";
        document.getElementById("d2div").innerHTML = currentDrought.d2x + "%<br>severe";
        document.getElementById("d3div").innerHTML = currentDrought.d3x + "%<br>extreme";
        document.getElementById("d4div").innerHTML = currentDrought.d4x + "%<br>exceptional";

        xTime = selDrought.map(function (d) { return d.date2; });
        yNone = selDrought.map(function (d) { return d.none; });
        yd0 = selDrought.map(function (d) { return d.d0x; });
        yd1 = selDrought.map(function (d) { return d.d1x; });
        yd2 = selDrought.map(function (d) { return d.d2x; });
        yd3 = selDrought.map(function (d) { return d.d3x; });
        yd4 = selDrought.map(function (d) { return d.d4x; });

        //PLOTLY
        var nonetrace = {
            y: yNone,
            x: xTime,
            line: { color: "darkgray", width: 1 },
            //fill: 'tozeroy',
            stackgroup: "one",
            fillcolor: "white",
            type: "scatter",
            name: "No Drought",
            hovertemplate: "%{y}% with no drought on %{x}",
        };

        var d0trace = {
            y: yd0,
            x: xTime,
            line: { color: "#FFFF00", width: 1 },
            //fill: 'tonexty',
            stackgroup: "one",
            fillcolor: "#FFFF00",
            type: "scatter",
            name: "D0",
            hovertemplate: "%{y}% in mild drought on %{x}",
        };

        var d1trace = {
            y: yd1,
            x: xTime,
            line: { color: "FCD37F", width: 1 },
            stackgroup: "one", //fill: 'tonexty',
            fillcolor: "#FCD37F",
            type: "scatter",
            name: "D1",
            hovertemplate: "%{y}% in moderate drought on %{x}",
        };

        var d2trace = {
            y: yd2,
            x: xTime,
            line: { color: "#FFAA00", width: 1 },
            stackgroup: "one", //fill: 'tonexty',
            fillcolor: "#FFAA00",
            type: "scatter",
            name: "D2",
            hovertemplate: "%{y}% in severe drought on %{x}",
        };

        var d3trace = {
            y: yd3,
            x: xTime,
            line: { color: "#E60000", width: 1 },
            stackgroup: "one", //fill: 'tonexty',
            fillcolor: "#E60000",
            type: "scatter",
            name: "D3",
            hovertemplate: "%{y}% in extreme drought on %{x}",
        };

        var d4trace = {
            y: yd4,
            x: xTime,
            line: { color: "#730000", width: 1 },
            type: "scatter",
            name: "D4",
            stackgroup: "one", //fill: 'tonexty',
            fillcolor: "#730000",
            hovertemplate: "%{y}% in exceptional drought on %{x}",
        };

        var layout = {
            yaxis: {
                title: "Percent Area in Drought (%)",
                titlefont: { color: "rgb(0, 0, 0)", size: 14 },
                tickfont: { color: "rgb(0, 0, 0)", size: 12 },
                showline: false,
                showgrid: true,
                showticklabels: true,
                range: [0, 100],
            },
            xaxis: {
                showline: false,
                showgrid: true,
                showticklabels: true,
                title: "",
                titlefont: { color: "rgb(0, 0, 0)", size: 14 },
                tickfont: { color: "rgb(0, 0, 0)", size: 12 },
            },
            hovermode: "closest",
            height: 250,
            showlegend: false,
            margin: { t: 30, b: 30, r: 40, l: 40 },
        };

        data = [d4trace, d3trace, d2trace, d1trace, d0trace, nonetrace];
        Plotly.newPlot("droughtPlot", data, layout, config);
    }); //end D3
}
//plotDroughtTime(myHUC);
