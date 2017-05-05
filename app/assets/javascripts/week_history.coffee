# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

`function getWeekNumber(d) {
        // Copy date so don't modify original
        d = new Date(+d);
        d.setHours(0,0,0,0);
        // Set to nearest Thursday: current date + 4 - current day number
        // Make Sunday's day number 7
        d.setDate(d.getDate() + 4 - (d.getDay()||7));
        // Get first day of year
        var yearStart = new Date(d.getFullYear(),0,1);
        // Calculate full weeks to nearest Thursday
        var weekNo = Math.ceil(( ( (d - yearStart) / 86400000) + 1)/7);
        // Return array of year and week number
        // return [d.getFullYear(), weekNo];
        return weekNo;
}`

`$(function() {
    if ($(location).attr('pathname') != '/week_history/index') return;
    /* For a given date, get the ISO week number
    *
    * Based on information at:
    *
    *    http://www.merlyn.demon.co.uk/weekcalc.htm#WNR
    *
    * Algorithm is to find nearest thursday, it's year
    * is the year of the week number. Then get weeks
    * between that date and the first day of that year.
    *
    * Note that dates in one year can be weeks of previous
    * or next year, overlap is up to 3 days.
    *
    * e.g. 2014/12/29 is Monday in week  1 of 2015
    *      2012/1/1   is Sunday in week 52 of 2011
    */

    $.get("/usages/dailyConsume", function(data) {
        // Convert ISO-8601 formate datetime to normal datetime: 
        // 2017-04-06T00:01:01.000Z => 2017-04-06 00:01:01.000
        var jsonObj = JSON.parse(data);
        var weeklyData = [[]], j = 0;
        var weekNum = 0;
        for (var i = 0; i < jsonObj.length; i++) {
            var d = new Date(jsonObj[i]['date']);
            console.log(getWeekNumber(d));
            if (getWeekNumber(d) != weekNum && i) {
                j++;
                weeklyData.push([])
            }
            weekNum = getWeekNumber(d);
            weeklyData[j].push(jsonObj[i])
        }
        console.log(weeklyData);
        for (var i = weeklyData.length - 1; i >= 0; i--) {
            $("#weekly-charts").append("<div><h3>Week"+(i+1)+"</h3></div><div id=\"weekCharts" + i+ "\"></div>");
            curUseGraph = Morris.Bar({
                element: 'weekCharts' + i, 
                data: weeklyData[i],
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
            $("#weeklyCharts"+i).css("display", "block");
            // TODO: BUG, if no resize, then not consistent.
            $("#weeklyCharts"+i).resize();
        }
        

    });
});`