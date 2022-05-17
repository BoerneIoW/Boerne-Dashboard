//##############################################################################################
//                   HOVER, CLICK FUNCTIONS ON MAP
//                   Function to interact with map hovers and clicks
//##############################################################################################

/*-------------------------------------------------------------------------------------------------------
  ////////////    CREATE HOVER OVER MAP FUNCTIONS                                             ///////////
--------------------------------------------------------------------------------------------------------*/
// UTILITY HOVER ----------#############################################################################
var utilityID = null;
map.on("mousemove", "utilities-layer", function (e) {
    map.getCanvas().style.cursor = "pointer";
    //check if feature exist
    if (e.features.length > 0) {
        document.getElementById("map_hover_box").innerHTML =
            "<p><strong>Utility Information <br><br></strong>" +
            e.features[0].properties.utility_name +
            " (" +
            e.features[0].properties.pwsid +
            ")<br>Data Available</p>";
    } // end if hover over map

    console.log(e.features[0])
    utilityID = e.features[0].properties.pwsid;
    if (utilityID) {
        //console.log(utilityID);
        map.setFeatureState(
            { source: "utilities", sourceLayer: "utilities", id: utilityID },
            { hover: true }
        ); //end setFeatureState
    } //end if UtiltiydID
}); //end map.on

map.on("mouseleave", "utilities-layer", function () {
    if (utilityID) {
        map.setFeatureState(
            {
                source: "utilities",
                id: utilityID,
            },
            { hover: false }
        );
    }

    utilityID = null;
    document.getElementById("map_hover_box").innerHTML =
        "<p>Hover over a utility</p>";
    map.getCanvas().style.cursor = ""; //resent point
});

map.on("mousemove", "no-utilities-layer", function (e) {
    map.getCanvas().style.cursor = "pointer";
    //check if feature exist
    if (e.features.length <= 0) {
        document.getElementById("map_hover_box").innerHTML =
            "<p><strong>Utility Information <br><br></strong>" +
            e.features[0].properties.utility_name +
            " (" +
            e.features[0].properties.pwsid +
            ")<br>No Data Available</p>";
    } // end if hover over map

    utilityID = e.features[0].id;
    if (utilityID) {
        map.setFeatureState(
            { source: "utilities", sourceLayer: "utilities", id: utilityID },
            { hover: true }
        ); //end setFeatureState
    } //end if UtiltiydID
}); //end map.on

map.on("mouseleave", "utilities-layer", function () {
    if (utilityID) {
        map.setFeatureState(
            {
                source: "utilities",
                id: utilityID,
            },
            { hover: false }
        );
    }

    utilityID = null;
    document.getElementById("map_hover_box").innerHTML =
        "<p>Hover over a utility</p>";
    map.getCanvas().style.cursor = ""; //resent point
});

// STREAM GAUGE HOVER ----------#############################################################################
map.on("mousemove", "streamgauge-layer", function (e) {
    // Change the cursor style as a UI indicator.
    map.getCanvas().style.cursor = "pointer";
    var coordinates = e.features[0].geometry.coordinates.slice();
    var description =
        e.features[0].properties.name +
        "<br> last measured (" +
        e.features[0].properties.date +
        ")";

    // Ensure that if the map is zoomed out such that multiple copies of the feature are visible, the popup appears over the copy being pointed to.
    while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
        coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
    }
    // Populate the popup and set its coordinates based on the feature found.
    popup.setLngLat(coordinates).setHTML(description).addTo(map);
}); //end map on for stream gauges

map.on("mouseleave", "streamgauge-layer", function () {
    map.getCanvas().style.cursor = "";
    popup.remove();
});

// RESERVOIR GAUGE HOVER ----------#############################################################################
map.on("mousemove", "reservoirs", function (e) {
    // Change the cursor style as a UI indicator.
    map.getCanvas().style.cursor = "pointer";
    var coordinates = e.features[0].geometry.coordinates.slice();
    var description = e.features[0].properties.Name;

    // Ensure that if the map is zoomed out such that multiple copies of the feature are visible, the popup appears over the copy being pointed to.
    while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
        coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
    }
    // Populate the popup and set its coordinates based on the feature found.
    popup.setLngLat(coordinates).setHTML(description).addTo(map);
}); //end map on for stream gauges

map.on("mouseleave", "reservoirs", function () {
    map.getCanvas().style.cursor = "";
    popup.remove();
});

// Groundwater HOVER ----------#############################################################################
map.on("mousemove", "groundwater", function (e) {
    // Change the cursor style as a UI indicator.
    map.getCanvas().style.cursor = "pointer";
    var coordinates = e.features[0].geometry.coordinates.slice();
    var site_name = e.features[0].properties.SiteName;
    var now_date = e.features[0].properties.date;
    var aquifer = e.features[0].properties.LocalAquiferName 
    var agency = e.features[0].properties.AgencyCd 
    var depth = e.features[0].properties.WellDepth + " feet";
    var description =
        site_name +
        ": last measured (" +
        now_date +
        ")<br>Aquifer Name: " +
        aquifer +
        "<br>Agency: " +
        agency +
        "<br>Well Depth: " +
        depth;

    // Ensure that if the map is zoomed out such that multiple copies of the feature are visible, the popup appears over the copy being pointed to.
    while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
        coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
    }
    // Populate the popup and set its coordinates based on the feature found.
    popup.setLngLat(coordinates).setHTML(description).addTo(map);
}); //end map on for stream gauges

map.on("mouseleave", "groundwater", function () {
    map.getCanvas().style.cursor = "";
    popup.remove();
});

// RESERVOIR GAUGE HOVER ----------#############################################################################
map.on("mousemove", "precipitation", function (e) {
    // Change the cursor style as a UI indicator.
    map.getCanvas().style.cursor = "pointer";
    var coordinates = e.features[0].geometry.coordinates.slice();
    var now_date = e.features[0].properties.date;
    var description =
        e.features[0].properties.name +
        "<br>last measured (" +
        now_date +
        ")" +
        "<br>Network: " +
        e.features[0].properties.network;

    // Ensure that if the map is zoomed out such that multiple copies of the feature are visible, the popup appears over the copy being pointed to.
    while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
        coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
    }
    // Populate the popup and set its coordinates based on the feature found.
    popup.setLngLat(coordinates).setHTML(description).addTo(map);
}); //end map on for stream gauges

map.on("mouseleave", "precipitation", function () {
    map.getCanvas().style.cursor = "";
    popup.remove();
});

// PCP 7 Day Observation ----------#############################################################################
map.on("mousemove", "pcp7obsv", function (e) {
    map.getCanvas().style.cursor = "pointer";
    // Populate the popup and set its coordinates based on the feature found.
    var coordinates = e.lngLat;
    var description = e.features[0].properties.bands + " inches";
    popup.setLngLat(coordinates).setHTML(description).addTo(map);
}); //end map on for stream gauges

map.on("mouseleave", "pcp7obsv", function () {
    map.getCanvas().style.cursor = "";
    popup.remove();
});

// PCP 7 Day %Normal ----------#############################################################################
map.on("mousemove", "pcp7norm", function (e) {
    map.getCanvas().style.cursor = "pointer";
    // Populate the popup and set its coordinates based on the feature found.
    var coordinates = e.lngLat;
    var description = e.features[0].properties.bands + "%";
    popup.setLngLat(coordinates).setHTML(description).addTo(map);
}); //end map on for stream gauges

map.on("mouseleave", "pcp7norm", function () {
    map.getCanvas().style.cursor = "";
    popup.remove();
});

// PCP 7 Day Forecast ----------#############################################################################
map.on("mousemove", "qpf7day", function (e) {
    map.getCanvas().style.cursor = "pointer";
    // Populate the popup and set its coordinates based on the feature found.
    var coordinates = e.lngLat;
    var description = e.features[0].properties.bands + " inches";
    popup.setLngLat(coordinates).setHTML(description).addTo(map);
}); //end map on for stream gauges

map.on("mouseleave", "qpf7day", function () {
    map.getCanvas().style.cursor = "";
    popup.remove();
});

// PCP Forecast ----------#############################################################################
map.on("mousemove", "forecastPCP", function (e) {
    map.getCanvas().style.cursor = "pointer";
    // Populate the popup and set its coordinates based on the feature found.
    var coordinates = e.lngLat;
    var description = e.features[0].properties.Name;
    popup.setLngLat(coordinates).setHTML(description).addTo(map);
}); //end map on for stream gauges

map.on("mouseleave", "forecastPCP", function () {
    map.getCanvas().style.cursor = "";
    popup.remove();
});

// PCP Forecast ----------#############################################################################
map.on("mousemove", "forecastTEMP", function (e) {
    map.getCanvas().style.cursor = "pointer";
    // Populate the popup and set its coordinates based on the feature found.
    var coordinates = e.lngLat;
    var description = e.features[0].properties.Name;
    popup.setLngLat(coordinates).setHTML(description).addTo(map);
}); //end map on for stream gauges

map.on("mouseleave", "forecastTEMP", function () {
    map.getCanvas().style.cursor = "";
    popup.remove();
});

//########################################################################################################
/*-------------------------------------------------------------------------------------------------------
  ////////////    CREATE CLICK ON MAP FUNCTIONS                                             ///////////
--------------------------------------------------------------------------------------------------------*/
//########################################################################################################
// set up if utilities-layer is clicked
map.on("click", "utilities-layer", function (e) {
    //since multiple overlapping layers, need to set up so that utiliteis don't get clicked when clicking on point
    var f = map.queryRenderedFeatures(e.point, {
        layers: [
            "utilities-layer",
            "streamgauge-layer",
            "reservoirs",
            "groundwater",
            "precipitation",
        ],
    });
    //console.log(f);   console.log(f.length);
    if (f.length > 1) {
        return;
    }

    geocoder.clear();
    myUtilityID = e.features[0].properties.pwsid;
    myUtility = e.features[0].properties.utility_name;
    console.log(myUtilityID + ": " + myUtility);

    //set dropdown list to whatever is selected
    document.getElementById('setSystem').value = myUtilityID;

    //filter water supply watersheds?? Not sure how to do
    map.setFilter("water_supply", ["in", "drawFile", myUtilityID]);
    map.setFilter("water_supply_name", ["in", "drawFile", myUtilityID]);

    //run functions
    myUtilityInfo(myUtility);
    createCurrentSummary(myUtility);
    createDemandInfo(myUtilityID, checkedDemand);
    createReclaimedInfo(myUtilityID, checkedReclaimed)
    createPopInfo(myUtilityID, checkedPop)
    return myUtilityID;
});

map.on("click", "streamgauge-layer", function (e) {
    document.getElementById("switchStatsDiv").style.display = "block";

    var streamGaugeName = e.features[0].properties.name;
    streamID = e.features[0].properties.site;
    recentDate = e.features[0].properties.julian;
    //var urlLink = e.features[0].properties.url_link; //console.log(e.features);
    var urlLink =
        "https://waterdata.usgs.gov/monitoring-location/" +
        streamID +
        "/#parameterCode=00060";

    //highlight in map
    if (typeof map.getLayer("streamgauge-selected") !== "undefined") {
        map.removeLayer("streamgauge-selected");
    }
    map.addLayer({
        id: "streamgauge-selected",
        type: "circle",
        source: "streamgauges",
        filter: ["in", "site", streamID],
        paint: {
            "circle-radius": 20,
            "circle-color": "yellow",
            "circle-opacity": 0.5,
        }, //end paint
    }); //end add layer

    document.getElementById("selectDataName").innerHTML =
        "<h4>" +
        streamID +
        ": <a href=" +
        urlLink +
        " target='_blank'>" +
        streamGaugeName +
        "</a><h4>";
    fileName = "data/streamflow/all_boerne_stream_stats.csv";

    createDailyStatistics(streamID, streamPlotType);
});

map.on("click", "reservoirs", function (e) {
    document.getElementById("switchStatsDiv").style.display = "block";
    var reservoirName = e.features[0].properties.Name;
    streamID = e.features[0].properties.NIDID;
    recentDate = e.features[0].properties.julian;
    var urlLink = e.features[0].properties.url_link; //console.log(e.features);

    //highlight in map
    if (typeof map.getLayer("reservoir-selected") !== "undefined") {
        map.removeLayer("reservoir-selected");
    }
    map.addLayer({
        id: "reservoir-selected",
        type: "circle",
        source: "reservoirs",
        filter: ["in", "NIDID", streamID],
        paint: {
            "circle-radius": 20,
            "circle-color": "yellow",
            "circle-opacity": 0.5,
        }, //end paint
    }); //end add layer

    document.getElementById("selectDataName").innerHTML =
        "<h4>" +
        streamID +
        ": <u><a style='color: rgb(26,131,130);' href=" +
        urlLink +
        " target='_blank'>" +
        reservoirName +
        "</a></u><h4>";
    fileName = "data/reservoirs/all_canyon_reservoir_stats.csv";
    createDailyStatistics(streamID, streamPlotType);
});

map.on("click", "groundwater", function (e) {
    document.getElementById("switchGWStatsDiv").style.display = "block";
    var gwName = e.features[0].properties.SiteName;
    gwID = e.features[0].properties.site;
    recentDate = e.features[0].properties.julian;

    //highlight in map
    if (typeof map.getLayer("gw-selected") !== "undefined") {
        map.removeLayer("gw-selected");
    }
    map.addLayer({
        id: "gw-selected",
        type: "circle",
        source: "groundwater",
        filter: ["in", "site", gwID],
        paint: {
            "circle-radius": 20,
            "circle-color": "yellow",
            "circle-opacity": 0.5,
        }, //end paint
    }); //end add layer
    //var urlLink = e.features[0].properties.link; console.log(e.features);
    document.getElementById("groundwaterTitle").innerHTML =
        "<h4>" +
        e.features[0].properties.AgencyCd +
        " " +
        gwID +
        " " +
        gwName +
        "</h4>";
    createGWTab(gwID, recentDate, gwPlotType);
});

map.on("click", "precipitation", function (e) {
    var precipName = e.features[0].properties.name;
    pcpID = e.features[0].properties.id;
    //highlight in map
    if (typeof map.getLayer("precipitation-selected") !== "undefined") {
        map.removeLayer("precipitation-selected");
    }
    map.addLayer({
        id: "precipitation-selected",
        type: "circle",
        source: "precipitation",
        filter: ["in", "id", pcpID],
        paint: {
            "circle-radius": 20,
            "circle-color": "yellow",
            "circle-opacity": 0.5,
        }, //end paint
    }); //end add layer
    var pcpRef =
    "https://www.texmesonet.org/#" +
    pcpID +
    "&temporal=D target='_blank'>";
    document.getElementById("pcpTitle").innerHTML =
        pcpID + ": <a href=" + pcpRef + precipName + "</a>";
    document.getElementById("pcpMetadata").innterHTML =
        "(Last reading: " + e.features[0].properties.date + ")";
    plotPrecipitation(pcpID, checked);
});
