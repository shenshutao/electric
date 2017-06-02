# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

`$(function() {
    function dateAdd(date, interval, units) {
    var ret = new Date(date); //don't change original date
    var checkRollover = function() { if(ret.getDate() != date.getDate()) ret.setDate(0);};
    switch(interval.toLowerCase()) {
        case 'year'   :  ret.setFullYear(ret.getFullYear() + units); checkRollover();  break;
        case 'quarter':  ret.setMonth(ret.getMonth() + 3*units); checkRollover();  break;
        case 'month'  :  ret.setMonth(ret.getMonth() + units); checkRollover();  break;
        case 'week'   :  ret.setDate(ret.getDate() + 7*units);  break;
        case 'day'    :  ret.setDate(ret.getDate() + units);  break;
        case 'hour'   :  ret.setTime(ret.getTime() + units*3600000);  break;
        case 'minute' :  ret.setTime(ret.getTime() + units*60000);  break;
        case 'second' :  ret.setTime(ret.getTime() + units*1000);  break;
        default       :  ret = undefined;  break;
    }
    return ret;
    }

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
        graphData = JSON.parse(data);
        console.log(graphData.length);
        var D1 = new Date(graphData[graphData.length-1]['timestamp']);
        console.log(D1.toISOString());
        var hourNum = parseInt(D1.toISOString().slice(11,13));
        if (0 < hourNum && hourNum < 12) {
            while (parseInt(D1.toISOString().slice(11, 13)) < 12) {
                D1 = dateAdd(D1, 'minute', 5);
                console.log(D1.toISOString());
                graphData.push({power:null, timestamp:D1.toISOString()});
            }
        } else {
            // 12 <= hourNum && hourNum <= 23
            while (parseInt(D1.toISOString().slice(11, 13)) != 0) {
                D1 = dateAdd(D1, 'minute', 5);
                console.log(D1.toISOString());
                graphData.push({power:null, timestamp:D1.toISOString()});
            }
        }
        // Keep the last 12h data in the array. 12h * 12 = 144, every hour has 12 records.
        graphData = graphData.slice(graphData.length - 145, graphData.length);
        console.log(JSON.stringify(graphData));
        data = JSON.stringify(graphData);
        data = data.replace(/T/g," ");
        data = data.replace(/Z/g, "");
        var jsonObj = JSON.parse(data);
        
        curUseGraph = Morris.Line({
            element: 'morris-area-chart', 
            data: jsonObj,
            xkey: 'timestamp',
            ykeys: ['power'],
            labels: ['power'],
            pointSize: 0,
            lineWidth: 2,
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


