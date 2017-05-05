# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

`function getMonthNumber(d) {
        return d.getMonth();
}`

`$(function() {
    if ($(location).attr('pathname') != '/month_history/index') return;

    $.get("/usages/dailyConsume", function(data) {
        // Convert ISO-8601 formate datetime to normal datetime: 
        // 2017-04-06T00:01:01.000Z => 2017-04-06 00:01:01.000
        var jsonObj = JSON.parse(data);
        var monthlyData = [[]], j = 0;
        var monthNum = 0;
        for (var i = 0; i < jsonObj.length; i++) {
            var d = new Date(jsonObj[i]['date']);
            console.log(getMonthNumber(d));
            if (getMonthNumber(d) != monthNum && i) {
                j++;
                monthlyData.push([])
            }
            monthNum = getMonthNumber(d);
            monthlyData[j].push(jsonObj[i])
        }
        console.log(monthlyData);
        for (var i = monthlyData.length - 1; i >= 0; i--) {
            $("#monthly-charts").append("<div><h3>Month"+(i+1)+"</h3></div><div id=\"monthlyCharts" +i+ "\"></div>");
            curUseGraph = Morris.Bar({
                element: 'monthlyCharts' + i, 
                data: monthlyData[i],
                xkey: 'date',
                ykeys: ['kwh'],
                labels: ['kwh'],
                xLabels: "day",
                pointSize: 0,
                lineWidth: 1,
                postUnits: "kWh",
                hideHover: 'false',
                resize: true
            });
            // Set the visibility of the graph to visible after loaded.
            // $("#morris-area-chart").css("display", "block");
            
            $("#current-usage-spinner").hide();
            $("#monthlyCharts"+i).css("display", "block");
            // TODO: BUG, if no resize, then not consistent.
            $("#monthlyCharts"+i).resize();
        }
        

    });
});`