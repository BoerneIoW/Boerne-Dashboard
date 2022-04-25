function createTracePop(target) {
    checkedPop = [];
    $("input[name='checkPopYear']:checked").each(function () {
        checkedPop.push($(this).val());
    });

    Plotly.purge("popPlot");
    createPopInfo(myUtilityID, checkedPop);
    return checkedPop;
}

document.getElementById('longPopTitle').innerHTML = "Long-term Annual Population Trends";

function createPopInfo(myUtilityID, checkedPop) {
    //parse date to scale axis
    parseDate = d3.timeParse("%Y-%m-%d");
    
    d3.csv("data/demand/all_boerne_pop.csv").then(function(popAnnual){
        popAnnual.forEach(function(d){
            d.clb_pop = +d.clb_pop;
            d.wsb_pop = +d.wsb_pop;
            d.year = +d.year;
        });

        var selPopAnnual = popAnnual.filter(function(d){return d.pwsid === "TX300001"; });
        var xYear = selPopAnnual.map(function(d) {return d.year; });
        var yPop = selPopAnnual.map(function(d) {return d.clb_pop; });
        var yPopW = selPopAnnual.map(function(d) {return d.wsb_pop; });
        var minVal = Math.max(yPop);

        traceAnnualPop1 = {
            type: 'scatter',
            x: xYear,  y: yPop, yPopW,
            text: "CLB Pop",
            mode: 'lines+markers',
            name: 'Yearly CLB Population',
            marker: { color: "purple", size: 7, opacity: 0.8},
            line: { color: 'purple',  width: 2},
            hovertemplate:
                    "Pop: %{y:.2f} in %{x}"
        };

        traceAnnualPop2 = {
            type: 'scatter',
            x: xYear,  y: yPopW,
            text: "WSB Pop",
            mode: 'lines+markers',
            name: 'Yearly WSB Population',
            marker: { color: "blue", size: 7, opacity: 0.8},
            line: { dash: 'dot', color: 'blue',  width: 2},
            hovertemplate:
                    "Pop: %{y:.2f} in %{x}"
        };

        var poplayout = {
            yaxis: {
                title: "Yearly Population",
                titlefont: {color: 'rgb(0, 0, 0)', size: 14},
                tickfont: {color: 'rgb(0, 0, 0)', size: 12},
                showline: true,
                showgrid: false,
                range: [0, minVal],
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
            line: {color: "#745508", width: "0.5"}
            }],
            
        };

        var data = [traceAnnualPop1, traceAnnualPop2];
        Plotly.newPlot('popPlot', data, poplayout, config);
    });//end D3
} //END CREATE CHART FUNCTION ##########################################################    
