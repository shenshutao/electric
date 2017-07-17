# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
`$(function() {
    if ($(location).attr('pathname') != '/your_goal/index') return;

    // functino achieveGoal and moneyAmount refers to the A1, A2, A3 feedbacks in PPT, which give the result of whether achieved goal or not.
    // baseline: the ave of first two weeks.
    // goal: the percentege of saving refering to the baseline.
    // real: real usage of this week.
    // RETURN: a string of feedback.
    function achieveGoal(baseline, goal, real) {
        var goalUsage = baseline * (1 - goal);
        console.log(real, goalUsage);
        if (real <= goalUsage) {
            return "Saved " + ((baseline - real) / baseline * 100).toFixed(2) + "%! Goal achieved! Keep up your good energy-saving behaviour!";
        } else if (real <= baseline) {
            return "Saved " + ((baseline - real) / baseline * 100).toFixed(2) + "%! Goal not achieved! Huat lah!"
        } else {
            return "Oops, goal not achieved ( " + ((real - goal) / baseline * 100).toFixed(2) + "% away)! Remember your goal!"
        }
    }

    // Calculate how much money has saved.
    // group: the group of users, possible value 'group1', 'group2', 'group3'.
    // week: the week number, can affect the feedbackB content. possible value '1', '2', ..., '3'.
    function moneyAmount(baseline, goal, real, group, week) {
        var goalUsage = baseline * (1 - goal);
        if (group == "group1") {
            // Current SG electricity price is 21.39 cent per kwh.
            var price = 0.2139;
            var str;
            if (real <= goalUsage) {
                str = "This can result in a saving of  $" + ((baseline - real) * price).toFixed(2) + " for your household in one year.";
            } else if (real <= baseline) {
                str = "You could have saved $" + ((baseline - goal) * price).toFixed(2) + " for your household in one year if you had achieved your goal.";
            } else {
                str = "You could have saved $" + ((baseline - goal) * price).toFixed(2) + " for your household in one year if you had achieved your goal.";
            }
            return str + " " + feedbackB( ((baseline - real) * price).toFixed(2), group, week);
        } else if (group == "group2") {
            var str;
            if (real <= goalUsage) {
                str = "Your efforts have helped to reduce __ kg of CO2 emissions for one year."
            } else if (real <= baseline) {
                str = "You could have reduced __ kg of CO2 emissions for one year if you had achieved your goal."
            } else {
                str = "You could have reduced __ kg of CO2 emissions for one year if you had achieved your goal."
            }
            return str + " " + feedbackB( ((baseline - real) * price).toFixed(2), group, week);
        } else if (group == "group3") {
            var str;
            if (real <= goalUsage) {
                str = "Your efforts have helped to mitigate the negative impact on urban habitat. This will lead to decreased risk of ";
            } else if (real <= baseline) {
                str = "If you had achieved your goal, you could have reduced negative impact on urban habitat. This could lead to decreased risk of ";
            } else {
                str = "If you had achieved your goal, you could have reduced negative impact on urban habitat. This could lead to decreased risk of ";
            }
            return str + " " + feedbackB( ((baseline - real) * price).toFixed(2), group, week);
        }
    }

    // Return a Int between [min, max]
    function getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    // Refers to the B1 - B10 feedbacks in PPT, which calculate the equivalent money amount.
    function feedbackB(money, group, week) {
        var weekNum = parseInt(week);
        if (group == "group1") {
            var stringArray = [
                "With this money you could save a round trip to Batam island with a family of  __ members.",
                "With this money you could have unforgettable experience in Singapore Flyer with __ family members.",
                "With this money you could get __ times free rides by taxi. ",
                "With this money you could get in __ fitness/yoga training classes at gym. ",
                "With this money you could afford __ months’ internet coverage at home. ",
                "With this money you could enjoy __ minutes foot massage. ",
                "With this money you could watch __ movies at theatre. ",
                "With this money you could visit S.E.A. Aquarium __ times in Sentosa.",
                "With this money you could enjoy your BBQ buffet with __ family members.",
                "With this money you could order __ delicious Bak Kwa gift packages for your family and friend."
            ];
            var priceArray = [34.0, 33.0, 10.0, 20.0, 25.0, 1.0, 10.0, 21.0, 25.0, 20.0];
            //var rand = getRandomInt(0, 9);

            return stringArray[weekNum - 1].replace("__", (money / priceArray[weekNum - 1]).toFixed(2));

        } else if (group == "group2") {
            var stringArray = [
                "You will make contribution to prevent sea level from rising. Currently, sea level is rising at an astonishing rate of 3.2 mm per year mainly due to the greenhouse gas emissions. Keeping this speed, about 10% land of Singapore will disappear.", 

                "You will help to mitigate global warming. With current pace of global warming, worldwide temperature is expected to increase up to 5.6℃ by 2100.", 

                "You will help to prevent ice caps from melting. Ice caps in the Arctic Ocean are diminishing at a rate of 15.1% per decade. By 2100, 80% of the ice caps would be vanished.", 

                "You will help to slow down the speed of species extinction.  Currently, the species extinction affected by human activities is 100 times faster than that by natural selection.", 

                "You will help to improve the outdoor air quality. Currently, for Singapore, every percentage increase in the household electricity consumption may lead to an approximately 20% increase in the PM2.5 concentration in the long-run.",

                "You will help to add more good-weather days in Singapore. Currently, a 3.0% increase in household electricity consumption leads to 5 more rainy days per month.", 

                "You will help to slow down the growth rate of harmful algal blooms. During early February 2015, up to 600 tonnes of fishes have been killed by harmful algal blooms in Singapore due to global warming.",

                "You will help to reduce ocean acidification. The ocean has absorbed about 1/3 of the CO2 produced from human activities which make the ocean 30% more acidic now. Keeping this rate, live corals and reefs may disappear from the tropics by 2050."
            ];
            return stringArray[weekNum - 1];

        } else if (group == "group3") {
            var stringArray = [
                "lung cancer for adults.",
                "respiratory disease for adults.",
                "regular dizziness for adults.",
                "cardiovascular disease for people older than 65 years old.",
                "suffering from cough and bronchial asthma for your children.",
                "malaria for your children.",
                "influenza for your family.",
                "dermatosis and skin cancer for your family.",
                "reduction in life expectancy of your family."
            ];
            return stringArray[weekNum - 1];

        }
    }

    // Attention! Since the website will only be used in 2017, we set the default value to 2017.
    function getDateOfISOWeek(w, y=2017) {
        var simple = new Date(y, 0, 1 + (w - 1) * 7);
        var dow = simple.getDay();
        var ISOweekStart = simple;
        if (dow <= 4)
            ISOweekStart.setDate(simple.getDate() - simple.getDay() + 1);
        else
            ISOweekStart.setDate(simple.getDate() + 8 - simple.getDay());
        return ISOweekStart;
    }

    $.get("/usages/weeklyConsume", function(data) {
        var jsonObj = JSON.parse(data);
        var goal = jsonObj['goal'], groupNum = jsonObj['groupNum'];
        var startDate = [];
        jsonObj = jsonObj['usage'];
        for (var i = 0; i < jsonObj.length; i++) {
            startDate.push(getDateOfISOWeek(parseInt(jsonObj[i]['week'])));
        }
        console.log(startDate);
        jsonObj[0]['week'] = "Pre-week1";
        jsonObj[1]['week'] = "Pre-week2";
        var pw1_consume = jsonObj[0]['kwh'];
        var pw2_consume = jsonObj[1]['kwh'];
        var baseline = (pw1_consume + pw2_consume) / 2;
        $("#baseline-legend").text("Baseline: " + baseline.toFixed(2) + " kWh");
        $("#goal-legend").text("Goal: " + ((1 - goal) * baseline).toFixed(2) + " kWh (%" + (goal * 100).toFixed(2) + ")");
        for (var i = 2; i < jsonObj.length; i++) {
            jsonObj[i]['week'] = "Week" + (i - 1);
        }
        // Append the start date of a week in the array.
        for (var i = 0; i < jsonObj.length; i++) {
            jsonObj[i]['week'] = jsonObj[i]['week'] + "\n(from " + startDate[i].toString().slice(4, 10) + ")";
        }
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
            gridTextSize: 8,
            goals: [(1 - goal) * baseline, baseline],
            goalStrokeWidth: 2,
            goalLineColors: ['#FF0000', '#00FF00'],
            resize: true,
            xLabelAngle: 30,
            padding: 50,
            barColors: function (row, series, type) {
                if(row.label.indexOf("Pre-week1") != -1 || row.label.indexOf("Pre-week2") != -1) return "#b3b3b3";
                else return "#0c64a0";
            }
        });
        // After graph, delete the date after week.
        for (var i = 0; i < jsonObj.length; i++) {
            jsonObj[i]['week'] = jsonObj[i]['week'].split('\n')[0];
        }
        // Set the visibility of the graph to visible after loaded.
        // $("#morris-area-chart").css("display", "block");
        
        $("#current-usage-spinner").hide();
        $("#week-goal-chart").css("display", "block");
        // TODO: BUG, if no resize, then not consistent.
        $("#week-goal-chart").resize();

        //jsonObj = jsonObj.slice(0, jsonObj.length - 1);

        function listenOnDropdown(i, real, group, week) {
            $("#button-" + jsonObj[i]['week']).click(function() {
                $('#history-heading').html("Result of " + jsonObj[i]['week']);
                //TODO: set the text of description. and the logic of % values.
                $('#history-content').text(achieveGoal(baseline, goal, real) + " " + moneyAmount(baseline, goal, real, group, week));
                $('#history-content').append(' <a tabindex="0" href="#" data-toggle="popover" title="Disclaimer" data-content="All information and data contained in this report is based on individual household energy consumption, personal preferences, research articles, and market conditions, individual experience and research literature and it is subject to change. It is for your reference only."><sup>[</sup> * <sup>]</sup></a>');
                $('[data-toggle="popover"]').popover({placement: 'bottom', trigger: 'click', container: 'body'});
            });
        }

        for (var i = jsonObj.length - 1; i >= 2; i--) {
            $("#dropdown-history").append("<li><a id=\"button-" + jsonObj[i]['week'] +  "\" href=\"#\">" + jsonObj[i]['week'] + "</a></li>");
            listenOnDropdown(i, jsonObj[i]['kwh'], groupNum, jsonObj[i]['week'][4]);
        }

        // initial the history content to the latest week.
        $('#history-heading').html("Result of " + jsonObj[jsonObj.length - 1]['week']);
        $('#history-content').text(achieveGoal(baseline, goal, jsonObj[jsonObj.length - 1]['kwh']) + " " + moneyAmount(baseline, goal, jsonObj[jsonObj.length - 1]['kwh'], groupNum, jsonObj[jsonObj.length - 1]['week'][4]));
        $('#history-content').append(' <a tabindex="0" href="#" data-toggle="popover" title="Disclaimer" data-content="All information and data contained in this report is based on individual household energy consumption, personal preferences, research articles, and market conditions, individual experience and research literature and it is subject to change. It is for your reference only."><sup>[</sup> * <sup>]</sup></a>');
        $('[data-toggle="popover"]').popover({placement: 'bottom', trigger: 'click', container: 'body'});
    });

    
});`