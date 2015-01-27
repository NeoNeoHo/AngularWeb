'use strict'

angular.module 'nodeApp'
.controller 'ChartCtrl', ($scope, $http, InventoryFactory) ->

  $scope.targetmatch = {}
  $scope.market = 'tw'
  $scope.ndays = 10
  $scope.type = 'alpha'
  $scope.venderClass = []

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


  $scope.changeType = (aType)->
    $scope.type = aType
    $scope.chartConfig.title.text = 'Top 100 Vender Class Distribution ' + capitaliseFirstLetter($scope.type)

  $scope.changeNdays = (ndays)->
    $scope.ndays = ndays
    $scope.update_chart()

  $scope.changeMarket = (aMarket)->
    $scope.market = aMarket
    $scope.update_chart()

  $scope.today = new Date()
  $scope.dt = new Date()

  $scope.gridOptions = {
    data: 'myData'
  }

  $scope.chartConfig = {
    options: {
      chart: {
        type: 'bar',
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
    series: [{
      name: "Stock Count",
      data: []
    }],
    title: {
      text: 'Top 100 Vender Class Distribution ' + capitaliseFirstLetter($scope.type)
    },
    loading: false,
    yAxis: {
      title: {text: null}
    },
    xAxis: {
      categories: [],
      title: {text: null}
    },
    useHighStocks: false
  }


  $scope.update_icodes = () ->
    $http.get('/api/inventory/'+$scope.market+'/'+getFormattedDate($scope.dt)).success (rtn) ->
      $scope.icodes = []
      $scope.targetmatch = {}
      for item in rtn.data
        bcode = item.code.split(" ")[0]
        item = {
          code: bcode,
          highlight: bcode in $scope.tcodes
        }
        $scope.icodes.push(item)
      $scope.update_top100_table()


  $scope.update_tcodes = () ->
    sqlstr = "select code from top100_stock_performance where market='"+$scope.market+
        "' and da='"+getFormattedDate($scope.dt)+"' order by ret_2_days desc"
    $http.post('/api/pgdb/query', {dbname:'www', sqlstring:sqlstr}).success (rtn) ->
      $scope.tcodes = []
      for item in rtn.data
        bcode = item.code.split(" ")[0]
        if bcode not in $scope.tcodes
          $scope.tcodes.push(item.code.split(" ")[0])
#        console.log $scope.tcodes
      $scope.update_icodes()


  $scope.update_top100_table = () ->
    sqlstr = "select * from top100_stock_performance where market='"+$scope.market+
      "' and da='"+getFormattedDate($scope.dt)+"' order by ret_2_days desc"
    $http.post('/api/pgdb/query', {dbname:'www', sqlstring:sqlstr}).success (rtn) ->
      $scope.myData = []
      for item in rtn.data
        bcode = item.code.split(" ")[0]
        item = {
          code: bcode,
          'vender': item.vender.replace(" Index", "")
          'ret_2_days %': (item.ret_2_days * 100).toFixed(2)
          'ret_20_days %': (item.ret_20_days * 100).toFixed(2)
          'ret_50_days %': (item.ret_50_days * 100).toFixed(2)
          'ret_100_days %': (item.ret_100_days * 100).toFixed(2)
          'dt - mt': (item.dt_minus_mt).toFixed(2)
          'dt+wt+mt': (item.dtwtmt).toFixed(2)
          'strength': (item.abs_dtwtmt).toFixed(2)
          'wt': (item.wt).toFixed(2)
        }
        $scope.myData.push(item)


  $scope.update_chart = () ->
    $http.get('/api/alpha/'+$scope.market+'/'+getFormattedDate($scope.dt)+'/'+$scope.ndays).success (rtn) ->
      $scope.data = []
      $scope.venderClass = []
      for item in rtn.data
        $scope.data.push(parseInt(item.vender_count))
        $scope.venderClass.push(item.vender.replace(" Index", ""))
      if $scope.data.length > 0
#        console.log $scope.data
#        console.log $scope.venderClass
        $scope.chartConfig.series[0].data = $scope.data
        $scope.chartConfig.xAxis.categories = $scope.venderClass
#        $scope.chartConfig.yAxis.currentMax = $scope.data[0]
#        $scope.chartConfig.yAxis.currentMin = $scope.data[$scope.data.length-1]
        $scope.update_tcodes()





  $scope.update_chart()



