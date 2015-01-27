'use strict'

angular.module 'nodeApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'chart',
    url: '/chart'
    templateUrl: 'app/chart/chart.html'
    controller: 'ChartCtrl'
