//##############################################################################################
//                             DRAW MAP
//                   created by Lauren Patterson
//##############################################################################################
function drawMap(){

// //build initial index of tiles
// var tileIndex = geojsonvt(utilities,
//   {
//     maxZoom: 14,  // max zoom to preserve detail on; can't be higher than 24
//     tolerance: 3, // simplification tolerance (higher means simpler)
//     extent: 4096, // tile extent (both width and height)
//     buffer: 64,   // tile buffer on each side
//     debug: 0,     // logging level (0 to disable, 1 or 2)
//     lineMetrics: false, // whether to enable line metrics tracking for LineString/MultiLineString features
//     promoteId: null,    // name of a feature property to promote to feature.id. Cannot be used with `generateId`
//     generateId: false,  // whether to generate feature ids. Cannot be used with `promoteId`
//     indexMaxZoom: 5,       // max zoom in the initial tile index
//     indexMaxPoints: 100000 // max number of points per tile in the index
//   });
// //console.log(tileIndex)

// //request a particular tile
// var tile = tileIndex.getTile();
// console.log(tileIndex);

//LOAD MAPS----------------------------------------------------------------
  //have to add sources on load
  map.on('load', function() {
    //add utilities to the map------------------------------------------------
    map.addSource('utilities-source',{
      type: 'geojson',
      data: utilities
    }); // end addSource

    map.addLayer({
      'id': 'utilities-selected',
      'type': 'fill',
      'source': 'utilities-source',
      //'filter': ['in', 'ncpwsid', myUtilityID],
      'paint': {'fill-color': '#4980b7',
                'fill-opacity': 0.8 },
      'layout': {'visibility':'none'}
      });
    //map.setFilter('utilities-selected', ['in', 'ncpwsid', 'NC0332010']);

    map.addLayer({
    'id': 'utilities-layer',
    'type': 'fill',
    'source': 'utilities-source',
    'filter': ['in', 'data', 'yes'],
    'paint': {'fill-color': '#708090', 
              'fill-outline-color': 'black',
              'fill-opacity': 0.75,
             },
    'layout': {"visibility": 'visible'}
    });

    map.addLayer({
      'id': 'no-utilities-layer',
      'type': 'fill',
      'source': 'utilities-source',
      //'filter': ['in', 'data', 'no'],
      'paint': {'fill-color': '#708090', 
              'fill-opacity': 0.2,
             },
      'layout': {"visibility": 'visible'}
    });

    map.addLayer({
    'id': 'utilities-layer-line',
    'type': 'line',
    'source': 'utilities-source',
    // 'paint': {'line-color': 'black', 'line-width': 0.25 },
    'paint': {'line-color': [
            'match',
              ['get', 'data'],
                'yes', 'black',
                'no', 'darkgray',
                /* other */ '#ccc'
            ],
            'line-width': 0.25
    },
    'layout': {"visibility": 'visible'}
    }); //if want thicker line


//#########################################################################################
//         ADD Water Supply Source Here
//#########################################################################################
  //WATER SOURCE DATA
  //console.log(myUtilityID);
    map.addSource('water_supply', {
      type: 'geojson',
      data: 'data/huc6.geojson'
    });
    map.addLayer({
      'id': 'water_supply',
      'type': 'fill',
      'source': 'water_supply',
      'filter': ['in', 'drawFile','none'],
      'layout': { 'visibility': 'none',  },
      'paint': {'fill-color': '#92b4f2', 
              'fill-outline-color': 'blue',
              'fill-opacity': 0.55,
             }
    });
   map.addLayer({
    id: "water_supply_name",
    type: "symbol",
    source: "water_supply",
    filter: ['in', 'drawFile', 'none'],
    layout: {
        "visibility": 'none',
        "text-field": "{name}",
        "text-size": 10,
        'symbol-placement': "point"
    },
    paint: {
        "text-color": "rgb(0,0,200)",
        "text-halo-color": "#fff",
        "text-halo-width": 1,    "text-halo-blur": 0,
    }
  });

//#########################################################################################
//         ADD DROUGHT, PRECIP AND FORECAST OVERLAYS
//#########################################################################################
        //add drought to the map------------------------------------------------
    map.addSource('drought',{
      type: 'geojson',
      data: 'data/drought/current_drought.geojson'
    }); // end addSource
    map.addLayer({
    'id': 'drought',
    'type': 'fill',
    'source': 'drought',
    'layout': {'visibility': 'none',  },
    'paint': {'fill-color': [
              'match',
              ['get', 'Name'],
                '0', '#FFFF00',
                '1', '#FCD37F',
                '2', '#FFAA00',
                '3', '#E60000',
                '4', '#730000',
              /* other */ '#ccc'
            ],
              'fill-outline-color': 'black',
              'fill-opacity': 0.3,
             }
    });

 //add pcp 7 day observation to map------------------------------------------------
    map.addSource('pcp7obsv',{
      type: 'geojson',
      data: 'data/pcp/pcp_7day_obsv.geojson'
    }); // end addSource
    map.addLayer({
    'id': 'pcp7obsv',
    'type': 'fill',
    'source': 'pcp7obsv',
    'layout': {'visibility': 'none',  },
    'paint': {'fill-color': {
                property: 'bands', 
                stops: [
                  [0, 'white'],
                  [0.01, '#3fc1bf'],
                  [0.1, '#87b2c0'],
                  [0.25, '#000080'],
                  [0.5, "#00fc02"],
                  [1, '#56b000'],
                  [1.5, '#316400'],
                  [2, "yellow"],
                  [3, '#f7e08b'],
                  [4, "orange"],
                  [5, "red"],
                  [6, '#9a0000'],
                  [8, '#4e0000'],
                  [10, '#e00079'],
                  [15, '#8e2eff'],
                  [20, 'black']
                ]
            },
              'fill-opacity': 0.4,
             }
    });
  
  //add pcp 7 day percent normal to map------------------------------------------------
    map.addSource('pcp7norm',{
      type: 'geojson',
      data: 'data/pcp/pcp_7day_percent_normal.geojson'
    }); // end addSource
    map.addLayer({
    'id': 'pcp7norm',
    'type': 'fill',
    'source': 'pcp7norm',
    'layout': {'visibility': 'none',  },
    'paint': {'fill-color': {
                property: 'bands', 
                stops: [
                  [0, 'white'],
                  [5, '#4e0000'],
                  [10, '#9a0000'],
                  [25, "red"],
                  [50, 'orange'],
                  [75, '#f7e08b'],
                  [90, "yellow"],
                  [100, '#316400'],
                  [110, "#00fc02"],
                  [125, "#56b000"],
                  [150, '#316400'],
                  [200, '#3fc1bf'],
                  [300, '#000080'],
                  [400, '#8e2eff'],
                  [600, '#e00079'],
                  [800, 'black']
                ]
            },
              'fill-opacity': 0.4,
             }
    });


      //add pcp 6-10 forecast to map------------------------------------------------
    map.addSource('forecastPCP',{
      type: 'geojson',
      data: 'data/pcp/pcp610forecast.geojson'
    }); // end addSource
    map.addLayer({
    'id': 'forecastPCP',
    'type': 'fill',
    'source': 'forecastPCP',
    'layout': {'visibility': 'none',  },
    'paint': {'fill-color': [
                'match',
                ['get', 'colorVal'],
                  "white", "white", // Normal
                  "#d4f8d4", "#d4f8d4", //33-39% above normal
                  "#90ee90","#90ee90", //40-49% above normal
                  "#4ce44c","#4ce44c", //50-59% above normal
                  "#1ec31e","#1ec31e", //60-69% above normal
                  "#169016","#169016", //70-79% above normal
                  "#0c4c0c","#0c4c0c", //>=80% above normal
                  "#e1d9d2","#e1d9d2", //33-39% below normal
                  "#b9a797","#b9a797", //40-49% below normal
                  "#b19d8c","#b19d8c", //50-59% below normal
                  "#776250","#776250",//60-69% below normal
                  "#5f4f40","#5f4f40",//70-79%below normal
                  "#312821","#312821",//80% below normal
                  '#ccc'
            ],
              'fill-opacity': 0.4,
             }
    });

          //add pcp 6-10 forecast temp to map------------------------------------------------
    map.addSource('forecastTEMP',{
      type: 'geojson',
      data: 'data/pcp/temp610forecast.geojson'
    }); // end addSource
    map.addLayer({
    'id': 'forecastTEMP',
    'type': 'fill',
    'source': 'forecastTEMP',
    'layout': {'visibility': 'none',  },
    'paint': {'fill-color': [
                'match',
                ['get', 'colorVal'],
                  "white", "white", // Normal
                  "#ffc4c4", "#ffc4c4", //33-39% above normal
                  "#ff7676","#ff7676", //40-49% above normal
                  "#ff2727","#ff2727", //50-59% above normal
                  "#eb0000","#eb0000", //60-69% above normal
                  "#b10000","#b10000", //70-79% above normal
                  "#760000","#760000", //>=80% above normal
                  "#d8d8ff","#d8d8ff", //33-39% below normal
                  "#9d9dff","#9d9dff", //40-49% below normal
                  "#4e4eff","#4e4eff", //50-59% below normal
                  "#1414ff","#1414ff",//60-69% below normal
                  "#0000d8","#0000d8",//70-79%below normal
                  "#00009d","#00009d",//80% below normal
                  '#ccc'
            ],
              'fill-opacity': 0.4,
             }
    });

    //add QPF Total 7 Day Precip
              //add pcp 7 day obxervation to map------------------------------------------------
    map.addSource('qpf7day',{
      type: 'geojson',
      data: 'data/pcp/qpf1-7dayforecast.geojson'
    }); // end addSource
    map.addLayer({
    'id': 'qpf7day',
    'type': 'fill',
    'source': 'qpf7day',
    'layout': {'visibility': 'none',  },
    'paint': {'fill-color': [
                'match',
                ['get', 'bands'],
                  //"0", "white", // 0
                  "0.01", "#7cfc00", //0.01
                  "0.1", "#228b22", //0.1
                  "0.25", "#2cb42c", //#0.25
                  "0.5", "#000080", //0.5
                  "0.75", "#1e1eff", //0.75
                  "1", "#005fbf", //1
                  "1.25", "#007cfa", //1.25,
                  "1.5", "#00bfbf", //1.5
                  "1.75", "#9370db", //1.75
                  "2", "#663399", //2
                  "2.5", "#800080", //2.5
                  "3", "darkred", //3
                  "4", "red", //4
                  "5", "#ff4500", //5
                  "7", "orange", //7
                  "10", "#8b6313", //10
                  "15", "#daa520", //15
                  "20", "yellow", //20
                  //'black', "black", //other or >20
                  '#ccc'
              ],
              'fill-opacity': 0.3, //Sometimes there is a problem with file have extra layers
             }
    });


//#####################################################################################################################


//#########################################################################################
//         ADD BOUNDARIES DATA
//#########################################################################################
    //ADD LAYERS TO TURN ON AND OFF - SET TOGGLES OUTSIDE OF MAP ON TOP IF CAN
    // ORDER MATTERS... THE FIRST ONE GOES UNDER OTHERS

    //COUNTY + LABELS----------------------------------------------
    map.addSource('county', {
      type: 'geojson',
      data: 'data/county.geojson'
    });
    map.addLayer({
      'id': 'county',
      'type': 'line',
      'source': 'county',
      'layout': {
        'visibility': 'none',
      },
      'paint': {'line-color': 'darkgray', 'line-width': 3}
    });
   map.addLayer({
    id: "county_name",
    type: "symbol",
    source: "county",
    layout: {
        "visibility": 'none',
        "text-field": "{name}",
        'symbol-placement': "point"
    },
    paint: {
        "text-color": "black",
        "text-halo-color": "#fff",
        "text-halo-width": 4,
        "text-halo-blur": 0,
    }
    });

    //GMAs + LABELS----------------------------------------------
    map.addSource('gma', {
      type: 'geojson',
      data: 'data/gmas.geojson'
    });
    map.addLayer({
      'id': 'gma',
      'type': 'line',
      'source': 'gma',
      'layout': {
        'visibility': 'none',
      },
      'paint': {'line-color': 'black', 'line-width': 4}
    });
    map.addLayer({
    id: "GMAnum",
    type: "symbol",
    source: "gma",
    layout: {
        "visibility": 'none',
        "text-field": "{GMAnum}",
        'symbol-placement': "point"
    },
    paint: {
        "text-color": "white",
        "text-halo-color": "#000000",
        "text-halo-width": 4,
        "text-halo-blur": 0,
    }
    });

    //RIVER BASINS: HUC6 + LABELS----------------------------------------------
    map.addSource('riverbasins', {
      type: 'geojson',
      data: 'data/huc6.geojson'
    });
    map.addLayer({
      'id': 'riverbasins',
      'type': 'line',
      'source': 'riverbasins',
      'layout': {'visibility': 'none', },
      'paint': {'line-color': 'navy', 'line-width': 4}
    });
   map.addLayer({
    id: "huc6_name",
    type: "symbol",
    source: "riverbasins",
    layout: {
        "visibility": 'none',
        "text-field": "{name}",
        'symbol-placement': "point"
    },
    paint: {
        "text-color": "navy",
        "text-halo-color": "#fff",
        "text-halo-width": 4,
        "text-halo-blur": 0,
    }
    });

    //WATERSHEDS: HUC8 + LABELS----------------------------------------------
    map.addSource('watersheds', {
      type: 'geojson',
      data: 'data/huc8.geojson'
    });
    map.addLayer({
      'id': 'watersheds',
      'type': 'line',
      'source': 'watersheds',
      'layout': { 'visibility': 'none',  },
      'paint': {'line-color': 'rgb(0,0,200)', 'line-width': 2}
    });
   map.addLayer({
    id: "huc8_name",
    type: "symbol",
    source: "watersheds",
    layout: {
        "visibility": 'none',
        "text-field": "{name}",
        'symbol-placement': "point"
    },
    paint: {
        "text-color": "rgb(0,0,200)",
        "text-halo-color": "#fff",
        "text-halo-width": 2,    "text-halo-blur": 0,
    }
  });





   //MAJOR RIVERS + LABELS----------------------------------------------
    map.addSource('rivers', {
      type: 'geojson',
      data: 'data/texas_rivers.geojson'
    });
    map.addLayer({
      'id': 'rivers',
      'type': 'line',
      'source': 'rivers',
      'layout': {'visibility': 'none'},
      'paint': {'line-color': 'blue', 'line-width': 1}
    });
   map.addLayer({
    id: "river_name",
    type: "symbol",
    source: "rivers",
    layout: {
        "visibility": 'none',
        "text-field": "{SEG_NAME}",
        "text-size": 10,
        'symbol-placement': "line"
    },
    paint: {
        "text-color": "blue",
        "text-halo-color": "#fff",
        "text-halo-width": 2,   "text-halo-blur": 0,
    }
  });


//https://docs.mapbox.com/help/tutorials/custom-markers-gl-js/ - TRY THIS FOR MARKERS
 //Groundwater------------------------------------------------------
   map.addSource('groundwater', {
    'type': 'geojson',
    'data': 'data/gw/all_gw_sites.geojson',
    'generateId': true
   });
    map.addLayer({
      'id': 'groundwater',
      'type': 'circle',
      'source': 'groundwater',
      'layout': {
        'visibility': 'none',
        },//end layout
        'paint': {
          'circle-radius': 5,
          'circle-color': [ 
              'match',
              ['get', 'status'],
                'Extremely Dry','darkred',
                'Very Dry', 'red',
                'Moderately Dry', 'orange',
                'Moderately Wet', 'cornflowerblue',
                'Very Wet', 'blue',
                'Extremely Wet', 'navy',
                'unknown', 'gray',
              /* other */ '#ccc'
            ],
            'circle-stroke-width': 1,
            'circle-stroke-color' : 'black'
        }//end paint
    }); //end addLayer


//#########################################################################################
//         ADD GAUGE DATA HERE
//#########################################################################################
 //STREAM GAUGES------------------------------------------------------
   map.addSource('streamgauges', {
    'type': 'geojson',
    'data': 'data/streamflow/all_stream_gauge_sites.geojson',
    'generateId': true
   });
    map.addLayer({
      'id': 'streamgauge-layer',
      'type': 'circle',
      'source': 'streamgauges',
      'layout': {
        'visibility': 'none',
        },//end layout
        'paint': {
        // make circles larger as the user zooms from z12 to z22
          //'circle-radius': 5,
          'circle-radius': {
            property: 'flow50',
            stops:[
              [1, 2],
              [21,4],
              [100, 6],
              [500, 8],
              [1000, 10],
            ]
          },
          'circle-color': [ 
              'match',
              ['get', 'status'],
                'Extremely Dry','darkred',
                'Very Dry', 'red',
                'Moderately Dry', 'orange',
                'Moderately Wet', 'cornflowerblue',
                'Very Wet', 'blue',
                'Extremely Wet', 'navy',
                'unknown', 'gray',
              /* other */ '#ccc'
            ],
            'circle-stroke-width': 1,
            'circle-stroke-color' : 'black'
          /*https://docs.mapbox.com/mapbox-gl-js/example/data-driven-circle-colors/*/
        }//end paint
    }); //end addLayer


   map.addSource('reservoirs', {
    'type': 'geojson',
    'data': 'data/reservoirs/all_canyon_lake_site.geojson',
    'generateId': true
   });
    map.addLayer({
      'id': 'reservoirs',
      'type':  'circle',     //triangle-15.svg
      'source': 'reservoirs',
      'layout': {
        'visibility': 'none',
        //'icon-image': 'triangle-15'
        },//end layout
      'paint': {
          'circle-radius': 10,
          'circle-color': [ 
              'match',
              ['get', 'status'],
                'Extremely Dry','darkred',
                'Very Dry', 'red',
                'Moderately Dry', 'orange',
                'Moderately Wet', 'cornflowerblue',
                'Very Wet', 'blue',
                'Extremely Wet', 'navy',
                'unknown', 'gray',
              /* other */ '#ccc'
            ],
            'circle-stroke-width': 1,
            'circle-stroke-color' : 'black'
        }//end paint*/
    }); //end addLayer

    map.addSource('precipitation', {
    'type': 'geojson',
    'data': 'data/pcp/all_pcp_sites.geojson',
    'generateId': true
   });
    map.addLayer({
      'id': 'precipitation',
      'type':  'circle',     //triangle-15.svg
      'source': 'precipitation',
      'layout': {
        'visibility': 'none',
        //'icon-image': 'triangle-15'
        },//end layout
      'paint': {
          'circle-radius': 5,
          'circle-color': [ 
              'match',
              ['get', 'status'],
                'Extremely Dry','darkred',
                'Very Dry', 'red',
                'Moderately Dry', 'orange',
                'Moderately Wet', 'cornflowerblue',
                'Very Wet', 'blue',
                'Extremely Wet', 'navy',
                'unknown', 'gray',
              /* other */ '#ccc'
            ],
            'circle-stroke-width': 1,
            'circle-stroke-color' : 'black'
        }//end paint*/
    }); //end addLayer

  });//end map on load
}//end Draw Map


//Script to call button has to go after function is defined
$('button').on('click', function(){ 
    var clickedLayer = this.id;

    if(clickedLayer.length > 0){
      var mapLayer;
    //change visibility based on menu grabbed
      if (clickedLayer === "menuUtility") {mapLayer = "utilities-layer";}
      if (clickedLayer === "menuCounty") {mapLayer = "county";}
      if (clickedLayer === "menuGMA") {mapLayer = "gma";}
      if (clickedLayer === "menuDrought") {mapLayer = "drought";}
      if (clickedLayer === "menuWatershed") {mapLayer = "watersheds";}
      if (clickedLayer === "menuBasins") {mapLayer = "riverbasins";}
      if (clickedLayer === "menuSource") {mapLayer = "water_supply";}
      if (clickedLayer === "menuRivers") {mapLayer = "rivers";}
      if (clickedLayer === "menuStreamGages") {mapLayer = "streamgauge-layer";}
      if (clickedLayer === "menuReservoirs") {mapLayer = "reservoirs";}
      if (clickedLayer === "menuGroundwater") {mapLayer = "groundwater";}
      if (clickedLayer === "menuPrecipitation") {mapLayer = "precipitation";}
      if (clickedLayer === "menuPCP7DayObsv") {mapLayer = "pcp7obsv"; }
      if (clickedLayer === "menuPCP7DayNorm") {mapLayer = "pcp7norm"; }
      if (clickedLayer === "menuQPF7day") {mapLayer = "qpf7day"; }
      if (clickedLayer === "menuForecastPCP6") {mapLayer = "forecastPCP"; }
      if (clickedLayer === "menuForecastTEMP6") {mapLayer = "forecastTEMP"; }

      var visibility = map.getLayoutProperty(mapLayer, 'visibility'); //buggy with menuUtility
      
    // toggle layer visibility by changing the layout object's visibility property
      if (visibility === 'visible') {
        map.setLayoutProperty(mapLayer, 'visibility', 'none');
          //for buttons with different backgrounds and classes, we remove and add those classes as needed
          if(clickedLayer==="menuQPF7day" || clickedLayer==="menuForecastPCP6" || clickedLayer==="menuForecastTEMP6"){ 
            document.getElementById(clickedLayer).classList.add("forecast"); 
            if(clickedLayer==="menuQPF7day"){
            document.getElementById("moreForecastInfo").style.display = "none";
            }
          }
          this.style.backgroundColor = 'lightgray';
          this.style.color = "black";
        } else {
          map.setLayoutProperty(mapLayer, 'visibility', 'visible');
            if(clickedLayer==="menuQPF7day" || clickedLayer==="menuForecastPCP6" || clickedLayer==="menuForecastTEMP6"){ 
              document.getElementById(clickedLayer).classList.remove("forecast"); 
              if(clickedLayer==="menuQPF7day"){
               document.getElementById("moreForecastInfo").style.display = "block";
              }
            }
          this.style.backgroundColor = '#001d67';
          this.style.color = "#98d801";
        }


      //for utilities, turn other layers on/off
      if (mapLayer === "utilities-layer"){ 
        if(visibility === 'visible'){
          map.setLayoutProperty('no-utilities-layer', 'visibility', 'none');
          map.setLayoutProperty('utilities-layer-line', 'visibility', 'none');
        } else {
          map.setLayoutProperty('no-utilities-layer', 'visibility', 'visible');
          map.setLayoutProperty('utilities-layer-line', 'visibility', 'visible');
        }
      }

      //add label text as needed
      if (mapLayer === "watersheds"){ 
        if (visibility === 'none') {
            map.setLayoutProperty('huc8_name', 'visibility', 'visible');
          } else {
            map.setLayoutProperty('huc8_name', 'visibility', 'none');
          }
        }//end if mapLayer

        if (mapLayer === "county"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('county_name', 'visibility', 'visible');
          } else {
            map.setLayoutProperty('county_name', 'visibility', 'none');
          }
        }//end if mapLayer

        if (mapLayer === "gma"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('GMAnum', 'visibility', 'visible');
          } else {
            map.setLayoutProperty('GMAnum', 'visibility', 'none');
          }
        }//end if mapLayer

        if (mapLayer === "riverbasins"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('huc6_name', 'visibility', 'visible');
          } else {
            map.setLayoutProperty('huc6_name', 'visibility', 'none');
          }
        }//end if mapLayer

        if (mapLayer === "water_supply"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('water_supply_name', 'visibility', 'visible');
          } else {
            map.setLayoutProperty('water_supply_name', 'visibility', 'none');
          }
        }//end if mapLayer

        if (mapLayer === "rivers"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('river_name', 'visibility', 'visible');
          } else {
            map.setLayoutProperty('river_name', 'visibility', 'none');
          }
        }//end if mapLayer

        //set up legend for streamflow, reservoirs, and precipitation
       //streamLegend = document.getElementById('stream-legend');
       streamLegend.innerHTML = "<h4>Current Status</h4>";
        var layers = ["Extermely Dry (<10)", "Very Dry (10-25)", "Dry (26-50)", "Wet (51-75)", "Very Wet (76-90)", "Extremely Wet (>90)", "Unknown"];
        var colors = ["darkred", "red", "orange", "cornflowerblue", "blue", "navy", "grey"];

        for (i = 0; i < layers.length; i++) {
            var layer = layers[i];   var color = colors[i];
            var item = document.createElement('div');  
            var key = document.createElement('span');
            key.style.width = "10px"; //change default span width
            key.className = 'legend-key';
            key.style.backgroundColor = color;

            var value = document.createElement('span');
            value.style.width = "120px"; //change default span width
            value.innerHTML = layer;
            item.appendChild(key);
            item.appendChild(value);
            streamLegend.appendChild(item);
          }


        if (mapLayer === "streamgauge-layer"){ 
          if (visibility === 'none') {
            map.setLayoutProperty("streamgauge-layer", 'visibility', 'visible');
              if (typeof map.getLayer("streamgauge-selected") !== 'undefined') { //show highlight if exists
                    map.setLayoutProperty('streamgauge-selected', 'visibility', 'visible');  
              }
               //put user onto tab
            $('[href="#waterSupplyStatus').tab('show'); //THIS AUTOMATICALLY GOES TO THE SURFACE PAGE AND TURNS ON RESERVOIRS
            //add legend to map
             streamLegend.style.display = 'block';
          } else {
            map.setLayoutProperty('streamgauge-layer', 'visibility', 'none');
            if (typeof map.getLayer("streamgauge-selected") !== 'undefined') { //hide highlight if exists
                    map.setLayoutProperty('streamgauge-selected', 'visibility', 'none');  
              }
            streamLegend.style.display = 'none';
          }
        }//end if mapLayer for streamflow----------------------------------------------------------------

        if (mapLayer === "reservoirs"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('reservoirs', 'visibility', 'visible');
            if (typeof map.getLayer("reservoir-selected") !== 'undefined') { //show highlight if exists
                    map.setLayoutProperty('reservoir-selected', 'visibility', 'visible');  
              }
            //put user onto tab
            $('[href="#waterSupplyStatus').tab('show');
                streamLegend.style.display = 'block';
              
          } else {
            map.setLayoutProperty('reservoirs', 'visibility', 'none');
             if (typeof map.getLayer("reservoir-selected") !== 'undefined') { //hide highlight if exists
                    map.setLayoutProperty('reservoir-selected', 'visibility', 'none');  
              }
            streamLegend.style.display = 'none';
          }
        }//end if mapLayer for reservoirs---------------------------------------------------------------------------


        if (mapLayer === "groundwater"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('groundwater', 'visibility', 'visible');
            if (typeof map.getLayer("gw-selected") !== 'undefined') { //show highlight if exists
                    map.setLayoutProperty('gw-selected', 'visibility', 'visible');  
              }
            //put user onto tab
            $('[href="#groundwater').tab('show');
              streamLegend.style.display = "block";
          } else {
            map.setLayoutProperty('groundwater', 'visibility', 'none');
            if (typeof map.getLayer("gw-selected") !== 'undefined') { //show highlight if exists
                    map.setLayoutProperty('gw-selected', 'visibility', 'none');  
              }
            streamLegend.style.display = 'none';
          }
        }//end if mapLayer for gw-----------------------------------------------------------------------

        if (mapLayer === "precipitation"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('precipitation', 'visibility', 'visible');
            if (typeof map.getLayer("precipitation-selected") !== 'undefined') { //hide highlight if exists
                    map.setLayoutProperty('precipitation-selected', 'visibility', 'visible');  
              }
            //put user onto tab
            $('[href="#pcpDrought').tab('show');
              streamLegend.style.display = "block";
          } else {
            map.setLayoutProperty('precipitation', 'visibility', 'none');
            if (typeof map.getLayer("precipitation-selected") !== 'undefined') { //hide highlight if exists
                    map.setLayoutProperty('precipitation-selected', 'visibility', 'none');  
              }
            streamLegend.style.display = 'none';
          }
        }//end if mapLayer for gw-----------------------------------------------------------------------



        if (mapLayer === "drought"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('drought', 'visibility', 'visible');

            //put user onto tab
            //$('[href="#pcpDrought').tab('show');

            //add legend to map
            droughtLegend = document.getElementById('drought-legend');
              droughtLegend.innerHTML = "<h4>Drought</h4>";
            var layers = ["None", "D0", "D1", "D2", "D3", "D4"];
            var colors = ["rgba(0,0,0,0)", '#FFFF00','#FCD37F','#FFAA00','#E60000','#730000'];

            for (i = 0; i < layers.length; i++) {
                var layer = layers[i];   var color = colors[i];
                var item = document.createElement('div');  
                var key = document.createElement('span');
                key.style.width = "10px"; //change default span width
                key.className = 'legend-key';
                key.style.backgroundColor = color;

                var value = document.createElement('span');
                value.style.width = "50px"; //change default span width
                value.innerHTML = layer;
                item.appendChild(key);
                item.appendChild(value);
                droughtLegend.appendChild(item);
                droughtLegend.style.display = 'block';
                // droughtLegend.style.marginTop = '0px';
              }
          } else {
            map.setLayoutProperty('drought', 'visibility', 'none');
            droughtLegend.style.display = 'none';
          }
        }//end if mapLayer for drought



        if (mapLayer === "pcp7obsv"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('pcp7obsv', 'visibility', 'visible');

            //put user onto tab
            //$('[href="#pcpDrought').tab('show');

            //add legend to map
            droughtLegend = document.getElementById('drought-legend');
              droughtLegend.innerHTML = "<h5>7-day Precip<br>Obsv (in)</h5>";
            var layers = ["0", "0.01-0.10", "0.11-0.25", "0.26-0.50", "0.51-1.00", "1.01-1.50", "1.51-2.00", "2.01-3.00", "3.01-4.00", "4.01-5.00",
                          "5.01-6.00","6.01-8.00", "8.01-10.00", "10.01-15.00", "15-20", ">20"];
            var colors = ["white",'#3fc1bf','#87b2c0', '#000080', "#00fc02", '#56b000', '#316400', "yellow", '#f7e08b', "orange", 'red',
                          '#9a0000', '#4e0000', '#e00079', '#8e2eff',"black"];
           

            for (i = 0; i < layers.length; i++) {
                var layer = layers[i];   var color = colors[i];
                var item = document.createElement('div');  
                var key = document.createElement('span');
                key.style.width = "10px"; //change default span width
                key.className = 'legend-key';
                key.style.backgroundColor = color;

                var value = document.createElement('span');
                value.style.width = "65px"; //change default span width
                value.innerHTML = layer;
                item.appendChild(key);
                item.appendChild(value);
                droughtLegend.appendChild(item);
                droughtLegend.style.display = 'block';
                // droughtLegend.style.marginTop = '0px';
              }
          } else {
            map.setLayoutProperty('pcp7obsv', 'visibility', 'none');
            droughtLegend.style.display = 'none';
          }
        }//end if mapLayer for pcp 7 days observ

        if (mapLayer === "pcp7norm"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('pcp7norm', 'visibility', 'visible');

            //put user onto tab
            //$('[href="#pcpDrought').tab('show');

            //add legend to map
            droughtLegend = document.getElementById('drought-legend');
              droughtLegend.innerHTML = "<h5>7-day Precip<br>% Normal</h5>";
            var layers = ["0", "1-5", "6-10", "11-25", "26-50", "51-75", "76-90", "91-100", "101-110",
                          "111-125","126-150", "151-200", "201-300", "301-400", "401-600", ">600"];
            var colors = ["white",'#4e0000','#9a0000', 'red', "orange",'#f7e08b', 'yellow', "#fafad2", '#00fc02',
                        "#56b000", "#316400", '#3fc1bf', 'blue', '#8e23ff', '#e00079',"black"];
   
            for (i = 0; i < layers.length; i++) {
                var layer = layers[i];   var color = colors[i];
                var item = document.createElement('div');  
                var key = document.createElement('span');
                key.style.width = "10px"; //change default span width
                key.className = 'legend-key';
                key.style.backgroundColor = color;

                var value = document.createElement('span');
                value.style.width = "65px"; //change default span width
                value.innerHTML = layer;
                item.appendChild(key);
                item.appendChild(value);
                droughtLegend.appendChild(item);
                droughtLegend.style.display = 'block';
                // droughtLegend.style.marginTop = '0px';
              }
          } else {
            map.setLayoutProperty('pcp7norm', 'visibility', 'none');
            droughtLegend.style.display = 'none';
          }
        }//end if mapLayer for pcp 7 days observ


        if (mapLayer === "qpf7day"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('qpf7day', 'visibility', 'visible');

            //put user onto tab
            //$('[href="#pcpDrought').tab('show');

            //add legend to map
            droughtLegend = document.getElementById('drought-legend');
              droughtLegend.innerHTML = "<h5>QPF 7-day</h5>";
            var layers = ["0.01-0.10", "0.11-0.25", "0.26-0.50","0.51-0.75", "0.76-1.00", "1.01-1.25", "1.26-1.50", "1.51-1.75",
                          "1.76-2.00", "2.01-2.50", "2.51-3.00", "3.01-4.00", "4.01-5.00", "5.01-7.00", "7.01-10.00", "10.01-15.0",
                          "15.1-20.0", ">20"];
            var colors = ["#7cfc00", "#228b22", "#2cb42c","#000080","#1e1eff","#005fbf", "#007cfa", "#00bfbf",
                          "#9370db", "#663399", "#800080", "darkred", "red", "#ff4500", "orange", "#8b6313", "#daa520", "yellow"];


            for (i = 0; i < layers.length; i++) {
                var layer = layers[i];   var color = colors[i];
                var item = document.createElement('div');  
                var key = document.createElement('span');
                key.style.width = "10px"; //change default span width
                key.className = 'legend-key';
                key.style.backgroundColor = color;

                var value = document.createElement('span');
                value.style.width = "65px"; //change default span width
                value.innerHTML = layer;
                item.appendChild(key);
                item.appendChild(value);
                droughtLegend.appendChild(item);
                droughtLegend.style.display = 'block';
                droughtLegend.style.marginBottom = '178px';
              }
          } else {
            map.setLayoutProperty('qpf7day', 'visibility', 'none');
            droughtLegend.style.display = 'none';
          }
        }//end if mapLayer for pcp 7 days observ




        if (mapLayer === "forecastPCP"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('forecastPCP', 'visibility', 'visible');

           //add legend to map
            droughtLegend = document.getElementById('drought-legend');
              droughtLegend.innerHTML = "<h5>6-10 Day<br>Precip Forecast</h5>";
            var layers = ["<80% below", "70-79% below", "60-69% below", "50-59% below", "40-49% below", "33-39% below", "normal",
                          "33-39% above","40-49% above", "50-59% above", "60-69% above", "70-79% above", ">80% above"];
            var colors = ["#312821","#5f4f40","#776250","#b19d8c","#b9a797","#e1d9d2","white","#d4f8d4", "#90ee90",
                          "#4ce44c","#1ec31e","#169016","#0c4c0c"];
                  
            for (i = 0; i < layers.length; i++) {
                var layer = layers[i];   var color = colors[i];
                var item = document.createElement('div');  
                var key = document.createElement('span');
                key.style.width = "10px"; //change default span width
                key.className = 'legend-key';
                key.style.backgroundColor = color;

                var value = document.createElement('span');
                value.style.width = "80px"; //change default span width
                value.innerHTML = layer;
                item.appendChild(key);
                item.appendChild(value);
                droughtLegend.appendChild(item);
                droughtLegend.style.display = 'block';
                droughtLegend.style.marginBottom = '180px';
              }
          } else {
            map.setLayoutProperty('forecastPCP', 'visibility', 'none');
            droughtLegend.style.display = 'none';
          }
        }//end if mapLayer for pcp 7 days observ


        if (mapLayer === "forecastTEMP"){ 
          if (visibility === 'none') {
            map.setLayoutProperty('forecastTEMP', 'visibility', 'visible');

            //add legend to map
            droughtLegend = document.getElementById('drought-legend');
              droughtLegend.innerHTML = "<h5>6-10 Day<br>Temp Forecast</h5>";
            var layers = ["<80% below", "70-79% below", "60-69% below", "50-59% below", "40-49% below", "33-39% below", "normal",
                          "33-39% above","40-49% above", "50-59% above", "60-69% above", "70-79% above", ">80% above"];
            var colors = ["#00009d","#0000d8","#1414ff","#4e4eff","#9d9dff","#d8d8ff", "white","#ffc4c4","#ff7676","#ff2727",
                          "#eb0000","#b10000","#760000"];
                  
            for (i = 0; i < layers.length; i++) {
                var layer = layers[i];   var color = colors[i];
                var item = document.createElement('div');  
                var key = document.createElement('span');
                key.style.width = "10px"; //change default span width
                key.className = 'legend-key';
                key.style.backgroundColor = color;

                var value = document.createElement('span');
                value.style.width = "80px"; //change default span width
                value.innerHTML = layer;
                item.appendChild(key);
                item.appendChild(value);
                droughtLegend.appendChild(item);
                droughtLegend.style.display = 'block';
                droughtLegend.style.marginBottom = '180px';
              }
          } else {
            map.setLayoutProperty('forecastTEMP', 'visibility', 'none');
            droughtLegend.style.display = 'none';
          }
        }//end if mapLayer for pcp 7 days observ





    }//end if clickedLayer>0 (need to do because mapbox zoom are buttons)
    
}); // end button script







