'use strict'

angular.module 'nodeApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ui.router',
  'ui.bootstrap',
  'highcharts-ng',
  'ui.grid',
  'ui.grid.resizeColumns',
  'ui.grid.moveColumns'
]
.config ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $urlRouterProvider
  .otherwise '/chart'

  $locationProvider.html5Mode true
