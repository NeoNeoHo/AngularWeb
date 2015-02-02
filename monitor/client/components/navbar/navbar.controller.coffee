'use strict'

angular.module 'nodeApp'
.controller 'NavbarCtrl', ($scope, $location) ->
  $scope.menu = [
    {
      title: 'Top150'
      link: '/chart'
    },{
      title: 'Nav Monitor'
      link: '/stknum'
    }

  ]
  $scope.isCollapsed = true

  $scope.isActive = (route) ->
    route is $location.path()
