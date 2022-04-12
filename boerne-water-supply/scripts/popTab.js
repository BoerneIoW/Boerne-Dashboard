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