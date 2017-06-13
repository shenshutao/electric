# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

`$(function() {
    var today;
    // When press the 'previous button', buttonCount += 1, while press the 'next button', buttonCount -= 1.
    var buttonCount = 0;
    var displayTime;

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

    function dateToString(date) {
        return date.getFullYear() + "-" + ((date.getMonth() + 1) < 10 ? ("0" + (date.getMonth() + 1)):(date.getMonth() + 1)) + "-" + ((date.getDate()) < 10 ? ("0" + date.getDate()):(date.getDate())) + " " + date.toLocaleTimeString('en-US', {hour12:false});
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
    
    function initGraph() {
        $('#button-next').hide();
        $.get("/usages/newestday", function(data) {
            // Convert ISO-8601 formate datetime to normal datetime: 2017-04-06T00:01:01.000Z => 2017-04-06 00:01:01.000
            graphData = JSON.parse(data);
            document.getElementById("welcome_index_current_value").innerHTML = graphData[graphData.length-1]['power'] + " W";
            $("#usage-text-spinner").hide();
            // Get the last data point time.
            var D1 = new Date(graphData[graphData.length-1]['timestamp']);
            today = D1;
            displayTime = D1;
            //console.log(D1.toISOString());
            var hourNum = parseInt(D1.toISOString().slice(11,13));
            // Fill up the data with empty points.
            // if 00:00 - 12:00 AM
            if (0 < hourNum && hourNum < 12) {
                while (parseInt(D1.toISOString().slice(11, 13)) < 12) {
                    D1 = dateAdd(D1, 'minute', 5);
                    //console.log(D1.toISOString());
                    graphData.push({power:null, timestamp:D1.toISOString()});
                }
                displayTime.setHours(0);
                displayTime.setMinutes(0);
                displayTime.setSeconds(0);
            } else {
                // 12 <= hourNum && hourNum <= 23
                while (parseInt(D1.toISOString().slice(11, 13)) != 0) {
                    D1 = dateAdd(D1, 'minute', 5);
                    //console.log(D1.toISOString());
                    graphData.push({power:null, timestamp:D1.toISOString()});
                }
                displayTime.setHours(12);
                displayTime.setMinutes(0);
                displayTime.setSeconds(0);
            }
            // Keep the last 12h data in the array. 12h * 12 = 144, every hour has 12 records.
            graphData = graphData.slice(graphData.length - 145, graphData.length);
            //console.log(JSON.stringify(graphData));
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
            $("#power-graph-title").html("<strong>Power ( </strong>" + dateToString(displayTime) + " <strong>to</strong> " + dateToString(dateAdd(displayTime, 'hour', 12)) + "<strong> )</strong>");
        });
    }
    initGraph();
    // Get the data and update the graph.
    function myTimer() {
        $.get("/usages/newest", function(data) {
            if (data.length < 1000) {

                var pos = graphData.length - 1;  
                while (pos > 0 && graphData[pos]['power'] == null) { pos--; }
                pos++;
                // Now pos point to the first null value. we set the newest data at this point.
                if (JSON.parse(data)['timestamp'] != graphData[pos-1]['timestamp']) {
                    document.getElementById("welcome_index_current_value").innerHTML = JSON.parse(data)["power"] + " W";
                    graphData[pos] = JSON.parse(data);
                    var temp = JSON.stringify(graphData);
                    temp = temp.replace(/T/g," ");
                    temp = temp.replace(/Z/g, "");
                    var jsonObj = JSON.parse(temp);
                    curUseGraph.setData(jsonObj);
                    
                } else {
                    document.getElementById("welcome_index_current_value").innerHTML = "Server Error, please contact technical staff.";
                }
            }
        });
        
    }

    $.get("/usages/last7days", function(data) {
        var jsonObj = JSON.parse(data);
        console.log(jsonObj);
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
            resize: true,
            xLabelAngle: 30
        });
        // Set the visibility of the graph to visible after loaded.
        // $("#morris-area-chart").css("display", "block");
        
        $("#last-7-spinner").hide();
        $("#last7days-chart").css("display", "block");
        // TODO: BUG, if no resize, then not consistent.
        $("#last7days-chart").resize();
    });

    $("#button-previous").click(function() {
        $('#button-next').show();
        // The displayTime represtents the time point of the left most point on the graph.
        displayTime = dateAdd(displayTime, 'hour', -12);
        buttonCount++;
        $.get("/usages/peroid?startdate=" + dateToString(displayTime) + "&enddate=" + dateToString(dateAdd(displayTime, 'hour', 12)), function(data) {
            if (data.length == 2) {
                // data is a string '[]' returned by server, length == 2 means no data.
                // No more data at this time peroid.
                displayTime = dateAdd(displayTime, 'hour', 12);
                alert("No more data before this time peroid.");
                return;
            }
            data = data.replace(/T/g," ");
            data = data.replace(/Z/g, "");
            var jsonObj = JSON.parse(data);
            curUseGraph.setData(jsonObj);
        });
        $("#power-graph-title").html("<strong>Power ( </strong>" + dateToString(displayTime) + " <strong>to</strong> " + dateToString(dateAdd(displayTime, 'hour', 12)) + "<strong> )</strong>");
    });
    $("#button-next").click(function() {
        displayTime = dateAdd(displayTime, 'hour', 12);
        buttonCount--;
        $.get("/usages/peroid?startdate=" + dateToString(displayTime) + "&enddate=" + dateToString(dateAdd(displayTime, 'hour', 12)), function(data) {
            data = data.replace(/T/g," ");
            data = data.replace(/Z/g, "");
            var jsonObj = JSON.parse(data);
            if (buttonCount == 0) {
                var D1 = new Date(jsonObj[jsonObj.length-1]['timestamp']);
                while (jsonObj.length < 144) {
                    D1 = dateAdd(D1, 'minute', 5);
                    jsonObj.push({power:null, timestamp:D1.toISOString()});
                }
            }
            curUseGraph.setData(jsonObj);
            $("#power-graph-title").html("<strong>Power ( </strong>" + dateToString(displayTime) + " <strong>to</strong> " + dateToString(dateAdd(displayTime, 'hour', 12)) + "<strong> )</strong>");
        });

        if (buttonCount == 0) {
            // Hide the Next button.
            $('#button-next').hide();
        }
    });
});`


