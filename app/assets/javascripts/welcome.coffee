# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

`$(function() {
    if ($(location).attr('pathname') != '/' && $(location).attr('pathname') != '/welcom/index') return;
    // The graph instance.
    var curUseGraph;
    var graphData;
    // Set every 10s refresh the graph.
    var myVar = setInterval(myTimer, 10000);
    $.get("/usages/newest", function(data) {
        if (data.length < 10)
            document.getElementById("welcome_index_current_value").innerHTML = data + " W";
    });
    
    $.get("/usages/newestday", function(data) {
        // Convert ISO-8601 formate datetime to normal datetime: 2017-04-06T00:01:01.000Z => 2017-04-06 00:01:01.000
        data = data.replace(/T/g," ");
        data = data.replace(/Z/g, "");
        var jsonObj = JSON.parse(data);
        graphData = JSON.parse(data);
        curUseGraph = Morris.Area({
            element: 'morris-area-chart', 
            data: jsonObj,
            xkey: 'timestamp',
            ykeys: ['power'],
            labels: ['power'],
            pointSize: 0,
            lineWidth: 1,
            postUnits: "W",
            hideHover: 'auto',
            resize: true
        });
        // Set the visibility of the graph to visible after loaded.
        // $("#morris-area-chart").css("display", "block");
        
        $("#current-usage-spinner").hide();
        $("#morris-area-chart").css("display", "block");
        // TODO: BUG, if no resize, then not consistent.
        $("#morris-area-chart").resize();

    });

    // Get the data and update the graph.
    function myTimer() {
        $.get("/usages/newest", function(data) {
            if (data.length < 1000) {
                document.getElementById("welcome_index_current_value").innerHTML = JSON.parse(data)["power"] + " W";
                graphData.push(data);
                //curUseGraph.setData(graphData);
                //console.log(graphData[graphData.length - 1]);
                //console.log(graphData.length);
            }
        });
        
    }

    Morris.Donut({
        element: 'morris-donut-chart',
        data: [{
            label: "Consume In Day Time",
            value: 61.5
        }, {
            label: "Consume In the Night",
            value: 38.5
        }],
        resize: true
    });
    $.get("/usages/last7days", function(data) {
        var jsonObj = JSON.parse(data);
        graphData = JSON.parse(data);
        last7daysGraph = Morris.Bar({
            element: 'last7days-chart', 
            data: jsonObj,
            xkey: 'date',
            ykeys: ['kwh'],
            labels: ['kwh'],
            pointSize: 0,
            lineWidth: 1,
            postUnits: "kWh",
            hideHover: 'auto',
            resize: true
        });
        // Set the visibility of the graph to visible after loaded.
        // $("#morris-area-chart").css("display", "block");
        
        $("#last-7-spinner").hide();
        $("#last7days-chart").css("display", "block");
        // TODO: BUG, if no resize, then not consistent.
        $("#last7days-chart").resize();
    });
});`


