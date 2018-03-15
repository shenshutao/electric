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
    function achieveGoal(baseline, goal, real, lang) {
        // For language settings.
        var langDict = {
            "cn":[
                "您节省了 __%! 目标完成! 请保持您的好习惯! ",
                "您节省了 __%! 目标没有完成哦! 加油啦! ",
                "哎呀, 目标没有完成哦 ( __% 的差距)! 请您不要忘记您的目标哦! "
            ],
            "en":[
                "Saved __%! Goal achieved! Keep up your good behaviour!",
                "Saved __%! Goal not achieved! Huat lah!",
                "Oops, goal not achieved ( __% away)! Remember your goal!"
            ]
        };
        var goalUsage = baseline * (1 - goal);
        if (real <= goalUsage) {
            return langDict[lang][0].replace("__", ((baseline - real) / baseline * 100).toFixed(2));
        } else if (real <= baseline) {
            return langDict[lang][1].replace("__", ((baseline - real) / baseline * 100).toFixed(2));
        } else {
            return langDict[lang][2].replace("__", ((real - goal) / baseline * 100).toFixed(2));
        }
    }

    // Calculate how much money has been saved.
    // group: the group of users, possible value 'group1', 'group2', 'group3'.
    // week: the week number, can affect the feedbackB content. possible value '1', '2', ..., '3'.
    function moneyAmount(baseline, goal, real, group, week, lang) {
        var langDict = {
            "cn":[
                // Group 1 
                "一年之后，您的家庭将会节省 $__ 。",
                "如果您能按计划完成您的目标， 一年之后，您的家庭将会节省 $__ 。",
                "如果您能按计划完成您的目标， 一年之后，您的家庭将会节省 $__ 。",

                // group 2
                "您的努力有助于在一年中减少__公斤二氧化碳排放量。",
                "如果您能按计划完成您的目标，您的努力有助于在一年中减少__公斤二氧化碳排放量。",
                "如果您能按计划完成您的目标，您的努力有助于在一年中减少__公斤二氧化碳排放量。",

                // Group 3
                "您的努力减少了城市发电量，进而影响到城市的环境。这将使得__的风险降低。",
                "您的努力有助于缓解对城市生活的负面影响。 这将使得__的风险降低。",
                "如果您能完成您的目标， 您的努力有助于缓解对城市生活的负面影响。 这将使得__的风险降低。"
            ], 
            "en":[
                // Group1
                "This can result in a saving of $__ for your household in one year.",
                "You could have saved $__ for your household in one year if you had achieved your goal.",
                "You could have saved $ for your household in one year if you had achieved your goal.",

                // Group2
                "Your efforts have helped to reduce __ kg of CO2 emissions for one year.",
                "You could have reduced __ kg of CO2 emissions for one year if you had achieved your goal.",
                "You could have reduced __ kg of CO2 emissions for one year if you had achieved your goal.",

                // Group3
                "Your efforts have helped to mitigate the negative impact on urban habitat. This will lead to decreased risk of __",
                "If you had achieved your goal, you could have reduced negative impact on urban habitat. This could lead to decreased risk of __",
                "If you had achieved your goal, you could have reduced negative impact on urban habitat. This could lead to decreased risk of __"
            ]
            };
        

        var goalUsage = baseline * (1 - goal);
        if (group == "group1") {
            // Current SG electricity price is 21.39 cent per kwh.
            // One year has 52 weeks, so we multiply the price by 52 to get the annually saving.
            var price = 0.2139 * 52;
            var str;
            if (real <= goalUsage) {
                //str = "This can result in a saving of $" + ((baseline - real) * price).toFixed(2) + " for your household in one year.";
                str = langDict[lang][0].replace("__",((baseline - real) * price).toFixed(2));
            } else if (real <= baseline) {
                str = langDict[lang][1].replace("__",((baseline - real) * price).toFixed(2));
            } else {
                str = langDict[lang][2].replace("__",((baseline - real) * price).toFixed(2));
            }
            return str + " " + feedbackB( ((baseline - real) * price).toFixed(2), group, week, lang);
        } else if (group == "group2") {
            var str;
            if (real <= goalUsage) {
                str = langDict[lang][3];
            } else if (real <= baseline) {
                str = langDict[lang][4];
            } else {
                str = langDict[lang][5];
            }
            return str + " " + feedbackB( ((baseline - real) * price).toFixed(2), group, week, lang);
        } else if (group == "group3") {
            var str;
            if (real <= goalUsage) {
                str = langDict[lang][6];
            } else if (real <= baseline) {
                str = langDict[lang][7];
            } else {
                str = langDict[lang][8];
            }
            return str.replace("__", feedbackB( ((baseline - real) * price).toFixed(2), group, week), lang);
        }
    }

    // Return a Int between [min, max]
    function getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    // Refers to the B1 - B10 feedbacks in PPT, which calculate the equivalent money amount.
    function feedbackB(money, group, week, lang) {
        var weekNum = parseInt(week);
        if (group == "group1") {
            var stringArray = {
                "cn": [
                    "您可以用您省的这笔钱邀请__位您的家人一起去新加坡摩天轮欣赏夜景。",
                    "您可以用您省的这笔钱享受__次免费的士。",
                    "您可以用您省的这笔钱享受__次健身房的专业指导，比如健身指导或者瑜伽练习。",
                    "您可以用您省的这笔钱在剧院观看__次电影。",
                    "您可以用您省的这笔钱享受__分钟的足底按摩。",
                    "您可以用您省的这笔钱去圣淘沙海底世界玩耍__次。",
                    "您可以用您省的这笔钱邀请__位您的家人或朋友享受一顿丰富的BBQ 大餐。",
                    "您可以用您省的这笔钱为您的家人订购__件美味的Bak Kwa礼品包。"
                ],
                "en": [
                    "With this money you could have an unforgettable experience in Singapore flyer with xx family members.",
                    "With this money you could get xx times free rides by taxi.",
                    "With this money you could get in xx training classes such as fitness training and yoga at the gym.",
                    "With this money you could watch xx movies at theatre.",
                    "With this money you could enjoy xx minutes foot massage.",
                    "With this money you could visit Sentosa Aquarium for xx times.",
                    "With this money you could have an enjoyable BBQ buffet with a family of xx members.",
                    "With this money you could order xx delicious Bak Kwa gift package(s) for your family."
                ]
            };
            var priceArray = [34.0, 33.0, 10.0, 20.0, 25.0, 1.0, 10.0, 21.0, 25.0, 20.0];
            //var rand = getRandomInt(0, 9);
            console.log(weekNum - 1);
            console.log(lang);
            console.log(stringArray[lang][weekNum - 1]);
            return stringArray[lang][weekNum - 1].replace("__", (money / priceArray[weekNum - 1]).toFixed(2));

        } else if (group == "group2") {
            var stringArray = {
                "cn": [
                    "这将有助于防止海平面上升。 目前，海平面以每年3.2毫米惊人的速度上升，主要是由于温室气体排放。 保持这个速度，新加坡将在本世纪末消失约10％的土地。",
                    "这有助于减轻全球变暖。 按照目前的全球变暖速度，到2100年，全球气温预计将上升5.6摄氏度。",
                    "这有助于防止冰盖融化。 北冰洋冰盖每十年融化15.1％。 到2100年，80％的冰帽将消失。",
                    "这有助于物种灭绝的速度减慢。 目前，受人类活动影响的物种灭绝比自然选择快100倍。",
                    "这有助于提高户外空气质量。 在新加坡，家庭用电量每增长百分之一可能导致PM2.5浓度增长约20％ （长期效应）。",
                    "这有助于增加新加坡的好天气。家庭电力消费每增加3.0％，就会导致每月多出5个雨天。",
                    "这有助于减缓有害藻类的生长速度。2015年曾由于全球变暖，在新加坡有多达600吨的鱼类被有害藻类杀死。",
                    "这有助于减少海洋酸化。海洋已经吸收了人类活动产生的二氧化碳的1/3，这使得海洋现在酸度达到了30％。 保持这个速度，到2050年，活珊瑚礁和珊瑚礁可能会从热带地区消失。"
                ],
                "en": [
                    "You will make contribution to prevent sea level from rising. Currently, sea level is rising at an astonishing rate of 3.2 mm per year mainly due to the greenhouse gas emissions. Keeping this speed, about 10% land of Singapore will disappear.", 
                    "You will help to mitigate global warming. With current pace of global warming, worldwide temperature is expected to increase up to 5.6℃ by 2100.", 
                    "You will help to prevent ice caps from melting. Ice caps in the Arctic Ocean are diminishing at a rate of 15.1% per decade. By 2100, 80% of the ice caps would be vanished.", 
                    "You will help to slow down the speed of species extinction.  Currently, the species extinction affected by human activities is 100 times faster than that by natural selection.", 
                    "You will help to improve the outdoor air quality. Currently, for Singapore, every percentage increase in the household electricity consumption may lead to an approximately 20% increase in the PM2.5 concentration in the long-run.",
                    "You will help to add more good-weather days in Singapore. Currently, a 3.0% increase in household electricity consumption leads to 5 more rainy days per month.", 
                    "You will help to slow down the growth rate of harmful algal blooms. During early February 2015, up to 600 tonnes of fishes have been killed by harmful algal blooms in Singapore due to global warming.",
                    "You will help to reduce ocean acidification. The ocean has absorbed about 1/3 of the CO2 produced from human activities which make the ocean 30% more acidic now. Keeping this rate, live corals and reefs may disappear from the tropics by 2050."
                ]
            };
            return stringArray[lang][weekNum - 1];

        } else if (group == "group3") {
            var stringArray = {
                "cn": [
                    "成人患肺癌",
                    "成年人患呼吸系统疾病",
                    "成年人定期头晕",
                    "65岁以上人群患心血管疾病",
                    "青年人患咳嗽和支气管哮喘",
                    "城市居民患感冒流行性感冒",
                    "城市居民患皮肤病和皮肤癌",
                    "城市居民平均预期寿命缩短"
                ],
                "en": [
                    "lung cancer for adults.",
                    "respiratory disease for adults.",
                    "regular dizziness for adults.",
                    "cardiovascular disease for people older than 65 years old.",
                    "suffering from cough and bronchial asthma for your children.",
                    "malaria for your children.",
                    "influenza for your family.",
                    "dermatosis and skin cancer for your family.",
                    "reduction in life expectancy of your family."
                ]
            };
            return stringArray[lang][weekNum - 1];

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
        var goal = jsonObj['goal'], groupNum = jsonObj['groupNum'], locale = jsonObj['locale'];
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
                $('#history-content').text(achieveGoal(baseline, goal, real, locale) + " " + moneyAmount(baseline, goal, real, group, week, locale));
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
        $('#history-content').text(achieveGoal(baseline, goal, jsonObj[jsonObj.length - 1]['kwh'], locale) + " " + moneyAmount(baseline, goal, jsonObj[jsonObj.length - 1]['kwh'], groupNum, jsonObj[jsonObj.length - 1]['week'][4], locale));
        $('#history-content').append(' <a tabindex="0" href="#" data-toggle="popover" title="Disclaimer" data-content="All information and data contained in this report is based on individual household energy consumption, personal preferences, research articles, and market conditions, individual experience and research literature and it is subject to change. It is for your reference only."><sup>[</sup> * <sup>]</sup></a>');
        $('[data-toggle="popover"]').popover({placement: 'bottom', trigger: 'click', container: 'body'});
    });

    
});`
