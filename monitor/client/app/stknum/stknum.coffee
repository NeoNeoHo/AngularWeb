'use strict'

angular.module 'nodeApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'stknum',
    url: '/stknum'
    templateUrl: 'app/stknum/stknum.html'
    controller: 'StkNumCtrl'
