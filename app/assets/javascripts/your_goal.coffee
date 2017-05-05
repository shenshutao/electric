# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
`$(function() {
    if ($(location).attr('pathname') != '/your_goal/index') return;

    $.get("/usages/weeklyConsume", function(data) {
        var jsonObj = JSON.parse(data);
        curUseGraph = Morris.Bar({
            element: 'week-goal-chart', 
            data: jsonObj,
            xkey: 'week',
            ykeys: ['kwh'],
            labels: ['kwh'],
            xLabels: "day",
            pointSize: 0,
            lineWidth: 1,
            postUnits: "kWh",
            hideHover: 'false',
            goals: [30],
            goalStrokeWidth: 2,
            goalLineColors: ['#FF0000'],
            resize: true
        });
        // Set the visibility of the graph to visible after loaded.
        // $("#morris-area-chart").css("display", "block");
        
        $("#current-usage-spinner").hide();
        $("#week-goal-chart").css("display", "block");
        // TODO: BUG, if no resize, then not consistent.
        $("#week-goal-chart").resize();
/*
        $.get("/usages/newest", function(data) {
            var newest = JSON.parse(data);
            newest = newest.replace(/T/g," ");
            newest = newest.replace(/Z/g, "");
            
        });*/
    });
});`