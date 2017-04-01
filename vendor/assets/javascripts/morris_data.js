$(function() {
    Morris.Area({
        element: 'morris-area-chart', 
        data: [{
            period: '2012-02-24 09:00',
            Yours: 2666,
            Average: null
        }, {
            period: '2012-02-24 10:00',
            Yours: 2778,
            Average: 2294
        }, {
            period: '2012-02-24 11:00',
            Yours: 4912,
            Average: 1969
        }, {
            period: '2012-02-24 12:00',
            Yours: 3767,
            Average: 3597
        }, {
            period: '2012-02-24 13:00',
            Yours: 6810,
            Average: 1914
        }, {
            period: '2012-02-24 14:00',
            Yours: 5670,
            Average: 4293
        }, {
            period: '2012-02-24 15:00',
            Yours: 4820,
            Average: 3795,
            itouch: 1588
        }, {
            period: '2012-02-24 16:00',
            Yours: 15073,
            Average: 5967
        }, {
            period: '2012-02-24 17:00',
            Yours: 10687,
            Average: 4460
        }, {
            period: '2012-02-24 18:00',
            Yours: 8432,
            Average: 5713
        }],
        xkey: 'period',
        ykeys: ['Yours', 'Average'],
        labels: ['Yours', 'Average'],
        pointSize: 2,
        hideHover: 'auto',
        resize: true
    });

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

    Morris.Bar({
        element: 'morris-bar-chart',
        data: [{
            y: '03/21/2017',
            YourCost: 100,
            Average: 90
        }, {
            y: '03/22/2017',
            YourCost: 75,
            Average: 65
        }, {
            y: '03/23/2017',
            YourCost: 50,
            Average: 40
        }, {
            y: '03/24/2017',
            YourCost: 75,
            Average: 65
        }, {
            y: '03/25/2017',
            YourCost: 50,
            Average: 40
        }, {
            y: '03/26/2017',
            YourCost: 75,
            Average: 65
        }, {
            y: '03/27/2017',
            YourCost: 100,
            Average: 90
        }],
        xkey: 'y',
        ykeys: ['YourCost', 'Average'],
        labels: ['YourCost', 'Average'],
        hideHover: 'auto',
        resize: true
    });
});
