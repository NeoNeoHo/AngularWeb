'use strict'

angular.module 'nodeApp'
.controller 'StkNumCtrl', ($scope, $http) ->
  $scope.market = 'cn'
  $scope.target = 'AnnR'
#    'AnnR',
#  'Sharpe',
#  'MDD'

  capitaliseFirstLetter = (string)->
    return string.charAt(0).toUpperCase() + string.slice(1);

  getFormattedDate = (date)->
    year = date.getFullYear()
    month = (1 + date.getMonth()).toString()
    if month.length == 1
      month = '0' + month
    day = date.getDate().toString()
    if day.length == 1
      day = '0' + day
    year + '-' + month + '-' + day

  $scope.date = new Date()
  $scope.dt = $scope.date
  $scope.NavChartConfig = {
    useHighStocks: true,
    options: {
      tooltip: {
        style: {
          padding: 10,
          fontWeight: 'bold'
        },
        enabled: true
      },
      legend: {
        enabled: true
      }
    },
    chart: {
      plotBorderWidth: 2,
      zoomType: 'x',
    },
    title: {
      text: 'Number of Stocks Effects (100 Random Samples)'
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
      title: {text: null}
    },
    series: [{
      name: "Nav",
      data:[]
    }]
  }

  $scope.updateChart = () ->
    $http.get('/api/navmonitor/'+$scope.market+'/'+getFormattedDate($scope.dt)).success (rtn) ->
      $scope.NavChartConfig.series[0].data = rtn.data
      console.log($scope.NavChartConfig.series)

  $scope.updateChart()

  $scope.changeMarket = (market) ->
    $scope.market = market
    $scope.updateChart()

  $scope.changeType = (aType) ->
    $scope.type = aType
    $scope.updateChart()







