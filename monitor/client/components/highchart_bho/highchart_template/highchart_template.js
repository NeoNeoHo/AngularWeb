    // var get_many_series_element = function(name, type, yAxis, data_set){
    //     var series_num = Object.keys(data_set).length

    // }

    var get_chart_config = function(){
        return {
            useHighStocks: true,
            options: {
                legend: {
                    enabled: true
                }
            },
            chart: {
                plotBorderWidth: 2,
                zoomType: 'x'
            },
            title: {
                text: ""
            },
            legend: {
                enabled: false
            },
            xAxis: {
                labels: {
                    format: '{value:%Y-%m}'
                }
            },
            yAxis: {
                title: {text: ""}
            },
            series: []
        }
    }

    var get_series_element = function (name, type, yAxis, color, data, dashStyle, id, dataGrouping, linewidth){
        if (typeof(dashStyle) === 'undefined') {
            dashStyle = '';
        }
        if (typeof(id) === 'undefined') {
            id = '';
        }
        if (typeof(dataGrouping) === 'undefined') {
            dataGrouping = '';
        }
        if (typeof(linewidth) === 'undefined') {
            linewidth = 2;
        }
        return {
            name : name,
            type: type,
            color: color,
            data : data,
            yAxis: yAxis,
            id: id,
            lineWidth: linewidth,
            dataGrouping: {
                units: dataGrouping
            },
            dashStyle: dashStyle,
            tooltip: {
                valueDecimals: 4
            }
        }
    };

    var get_flag_element = function(data, onSeries, yAxis, shape, width){
        return {
            type : 'flags',
            yAxis: yAxis,
            data : data,
            onSeries : onSeries,
            shape : shape,
            width : width
        }
    };

    var get_yAxis_element = function(text, top, height, opposite, plotLines){
        if (typeof(opposite) === 'undefinded') {
            opposite = 'false';
        }
        if (typeof(plotLines) === 'undefinded') {
            plotLines = '';
        }
        return {
            title: {
                text: text,
                style:{
                    fontSize: '24px',
                }
            },
            offset: 0,
            top: top,
            plotLines: plotLines,
            height: height,
            opposite: opposite,
            startOnTick: true,
            endOnTick: true,
            gridLineWidth: 1
        }
    };
