
Date.prototype.yyyymmdd = () ->
  yyyy = this.getFullYear().toString()
  mm = (this.getMonth()+1).toString()
  dd  = this.getDate().toString()
  if mm.length == 1
    mm = "0"+mm
  if dd.length == 1
    dd = "0"+dd
  out_str = yyyy + '-' + mm + '-' + dd
  return out_str


String.prototype.contains = (it) ->
  return (this.indexOf(it) != -1)

app.controller('StknumCtrl', [
  '$scope'
  '$location'
  '$http'
  '$modal'
  '$log'

  ($scope, $location, $http, $modal, $log) ->

    $scope.markets = [
      'cn',
      'au',
      'hk',
      'jp'
    ]

    $scope.targets = [
      'AnnR',
      'Sharpe',
      'MDD'
    ]

    $scope.market = $scope.markets[0]
    $scope.target = $scope.targets[0]
    $scope.date = new Date()



    $scope.renewData = () ->
      $http.get('http://192.168.1.42:3333/mongo-api/pag/stk_number_effects/'+$scope.market+"_big").success (data) ->
        $scope.stk_effects_data = data.document.annr
        if $scope.target == "Sharpe"
          $scope.stk_effects_data = data.document.sharpe
        if $scope.target == "MDD"
          $scope.stk_effects_data = data.document.mdd
        $scope.stk_num = data.document.stk_num
        $scope.renewChart()


    $scope.format = 'yyyy-MM-dd'

    $scope.renewChart = () ->
      $('#container').highcharts({
        chart:{
          type: 'boxplot'
        },
        title: {
          text: 'Number of Stocks Effects (Monte Carlo with 100 Samples)'
        },
        legend: {
          enabled: false
        },
        xAxis: {
          categories: $scope.stk_num,
          title: {
            text: 'Stock No.'
          }
        },
        yAxis: {
          title: {
            text: $scope.target
          }
        },
        series: [{
          name: $scope.target,
          data: $scope.stk_effects_data
        }]
      })

    $scope.renewData()

])
