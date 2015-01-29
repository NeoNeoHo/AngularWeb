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
  $scope.NavChartConfig = get_chart_config()

  $scope.updateChart = () ->
    $http.get('/api/navmonitor/'+$scope.market).success (rtn_datas) ->
      rtn = rtn_datas.model_nav
      $scope.NavChartConfig = get_chart_config()
      $scope.NavChartConfig.title.text = "Model Monitor"
      $scope.NavChartConfig.yAxis.title.text = "Model NAV"
      $scope.NavChartConfig.series.push({ name: "Model Nav", color: "#000000", data: rtn.data})
      $scope.NavChartConfig.series.push({ name: "SMA 20", color: "#FF0000", data: SMA(rtn.data,20)})
      $scope.NavChartConfig.series.push({ name: "SMA 50", color: "#0000FF", data: SMA(rtn.data,50)})
      $scope.NavChartConfig.series.push({ name: "SMA 100", color: "#006400", data: SMA(rtn.data,100)})
      console.log($scope.NavChartConfig)

  $scope.updateChart()

  $scope.changeMarket = (market) ->
    $scope.market = market
    $scope.updateChart()

  $scope.changeType = (aType) ->
    $scope.type = aType
    $scope.updateChart()







