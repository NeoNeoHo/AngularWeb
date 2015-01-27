'use strict'

angular.module 'nodeApp'
.controller 'NavbarCtrl', ($scope, $location) ->
  $scope.menu = [
    {
      title: 'VenderClass'
      link: '/chart'
    },{
      title: 'Monitor'
      link: '/stknum'
    }

  ]
  $scope.isCollapsed = true

  $scope.isActive = (route) ->
    route is $location.path()
