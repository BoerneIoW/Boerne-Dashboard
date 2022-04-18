parseDate = d3.timeParse("%Y-%m-%d");

d3.csv("data/demand/all_boerne_pop.csv").then(function(popAnnual){
    popAnnual.forEach(function(d){
        d.clb_pop = +d.clb_pop;
        d.wsb_pop = +d.wsb_pop;
        d.year = +d.year;
       });

  var selPopAnnual = popAnnual.filter(function(d){return d.pwsid === popID.toString(); });
  var xYear = selPopAnnual.map(function(d) {return d.year; });
  var yPop = selPopAnnual.map(function(d) {return d.clb_pop; });
  var minVal = Math.max(yPop);

  traceAnnual = {
    type: 'scatter',
    x: xYear,  y: yPop,
    text: "yearly Pop",
    mode: 'lines+markers',
    name: 'Yearly CLB Population',
    marker: { color: "black", size: 5, opacity: 0.8},
    line: { color: 'gray',  width: 1},
    hovertemplate:
              "Yearly Pop: %{y:.2f} in %{x}"
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
      line: {color: "#745508", width: "2"}
    }],
    
};
var data = [traceAnnual];
Plotly.newPlot('popPlot', data, poplayout, config);
});//end D3
