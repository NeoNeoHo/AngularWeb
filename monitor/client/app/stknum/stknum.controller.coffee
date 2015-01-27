'use strict'

angular.module 'nodeApp'
.controller 'StkNumCtrl', ($scope, $http) ->
  $scope.market = 'cn'
  $scope.target = 'AnnR'
#    'AnnR',
#  'Sharpe',
#  'MDD'
  $scope.date = new Date()

  $scope.stknumChartConfig = {
    options: {
      chart: {
        type: 'boxplot',
        renderTo: 'chartContainer',
        reflow: true
      },
      tooltip: {
        style: {
          padding: 10,
          fontWeight: 'bold'
        },
        enabled: true
      },
      legend: {
        enabled: false
      }
    },
    title: {
      text: 'Number of Stocks Effects (100 Random Samples)'
    },
    legend: {
      enabled: false
    },
    xAxis: {
      categories: [],
      title: {
        text: 'Stock No.'
      }
    },
    yAxis: {
      title: {
        text: ""
      }
    },
    series: [{
      name: "",
      data: []
    }]
  }

  $scope.updateChart = () ->
    $http.get('/api/mongodb/pag/stk_number_effects/'+$scope.market+"_big").success (data) ->
      $scope.stk_effects_data = data.document.annr
      if $scope.target == "Sharpe"
        $scope.stk_effects_data = data.document.sharpe
      if $scope.target == "MDD"
        $scope.stk_effects_data = data.document.mdd
      $scope.stk_num = data.document.stk_num
      $scope.stknumChartConfig.xAxis.categories = $scope.stk_num
      $scope.stknumChartConfig.series[0].data = $scope.stk_effects_data
      $scope.stknumChartConfig.yAxis.title.text = $scope.target
      $scope.stknumChartConfig.series[0].name = $scope.target

  $scope.updateChart()

  $scope.changeMarket = (market) ->
    $scope.market = market
    $scope.updateChart()

  $scope.changeType = (aType) ->
    $scope.type = aType
    $scope.updateChart()







