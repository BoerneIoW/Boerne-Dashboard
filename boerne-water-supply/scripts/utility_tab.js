//##############################################################################################
//                   MY UTILITY TAB
//                   Function to create utility tab on selection
//##############################################################################################
//capitlizae first letter
function toTitleCase(str) {
    return str.replace(/\w\S*/g, function(txt){
        return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
    });
}

console.log(document.getElementById('setSystem'))
//read in d3 with basic info
function myUtilityInfo(myUtility){
  //Fill in form
    var utilityText = document.getElementById("utilityResult");
    
    
    if (myUtility === "none"){ 
      map.setLayoutProperty('utilities-selected', 'visibility', 'none');

      utilityText.innerHTML = "<h4 style='color: rgb(26,131,130);'><strong>No utility service provider found.</strong></h4>"; 
      document.getElementById("utilityTableHeader").innerHTML = "";
      document.getElementById("utilityTable").innerHTML = "";
    }
    
    if (myUtility !== "none"){
      map.setFilter('utilities-selected', ['in', 'pwsid', myUtilityID]);
      map.setLayoutProperty('utilities-selected', 'visibility', 'visible');

      //try to set zoom for selected drop down
      var myFeatures = map.querySourceFeatures('utilities-source', {
        sourceLayer: 'utilities-source',
        filter: ["in", "pwsid", myUtilityID]
      });
      //zoom to utility
    var coordinates = myFeatures[0].geometry.coordinates[0]; 
    //var bounds = coordinates.reduce(function (bounds, coord) {
        //return bounds.extend(coord);
      //}, new mapboxgl.LngLatBounds(coordinates[0], coordinates[0]));
      //map.fitBounds(bounds, { padding: 125 });
    
      
     //load data 
     d3.csv("data/basic_info.csv").then(function(dataCSV){
     var selectData = dataCSV.filter(function(d) {return d.utility_name === myUtility; });
     //console.log(dataCSV); console.log(selectData);
     var myUtilityWebsite = selectData[0].utility_website; 
     //var myUtilityDrought = selectData[0].drought_status;
     var myUtilityWaterPlan = selectData[0].water_shortage_plans;
     var myUtilityUpdatePlan = selectData[0].last_update;
     var myUtilityStage = selectData[0].stage;
            
     utilityText.innerHTML = "<h3 class='chartTitles'>You are located in the <a href = " + myUtilityWebsite + " target='_blank'>" + myUtility + "</a> service area</h3><br>" + 
      "<p> My water conservation status is: <b>" + toTitleCase(myUtilityStage) + "</b><br>" + 
      "To learn more about my utility's water conservation plan, click <a href = " + myUtilityWaterPlan + " target='_blank'>here</a>. <br>This plan was last updated in " + myUtilityUpdatePlan + ".<br></p>";


    //create table for utility conservation status
    document.getElementById("utilityTableHeader").innerHTML = myUtility + " Water Conservation Activities";

    //read in data
    d3.csv("data/water_shortage_responses.csv").then(function(shortCSV){
      shortSelect = shortCSV.filter(function(d){return d.utility_name === myUtility; });
      
     //create table --- scroll options on table height, etc are in the css portion
    var myUtilityTable = "<table class='table table-bordered table-striped' style='font-size: 12px; text-align: left;'>";
    
    //create column header
    myUtilityTable += "<thead><tr>";
    myUtilityTable += "<th>Activity</th>";
    var tableHeaders = shortSelect.map(function(d){ return d.stage; });
    tableHeaders = Array.from(new Set(tableHeaders));
    var columnNumber;
   
   //loop through and add headers based on number of stages
    for (var i = 0, len = tableHeaders.length; i < len; i++) {
      if (tableHeaders[i] === myUtilityStage){
        myUtilityTable += "<th style = 'background-color: #edca6b; border thick solid #b98d16;'>" + tableHeaders[i] + "</th>";
        columnNumber = i;
      }
      else {myUtilityTable += "<th>" + tableHeaders[i] + "</th>";}
    }
   
   //end header and start body to loop through by activity
    myUtilityTable += "</thead><tbody'>";
    var activity = shortSelect.map(function(d) { return d.activity; });
    activity = Array.from(new Set(activity)); //returns unique value

    var activityResponse = [];
  //loop through and add headers based on number of stages
    for (i = 0, len = activity.length; i < len; i++) {
      myUtilityTable += "<tr>";
      myUtilityTable += "<td>" + activity[i] + "</td>";

      //fill in response
      activityResponse = shortSelect.filter(function(d) {return d.activity === activity[i]; }).map(function(m) { return m.stage_response; });

      for (var j = 0, len2 = activityResponse.length; j < len2; j++){
        if (j === columnNumber){
            myUtilityTable += "<td style = 'background-color: #edca6b; border thick solid #b98d16;'>" + activityResponse[j] + "</td>";
        }
        else { myUtilityTable += "<td>" + activityResponse[j] + "</td>";}
      }
      myUtilityTable += "</tr>";
    }

    myUtilityTable += "</tbody></table><br><br>"; 

  //load table
  document.getElementById("utilityTable").innerHTML = myUtilityTable;

        }); //end d3 water shortage
      }); //end d3 basic info
  }// end if a utility is selected
    
return myUtility;
} //end myUtilityInfo function

