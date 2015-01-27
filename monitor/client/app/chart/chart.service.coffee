
angular.module 'nodeApp'
.factory 'InventoryFactory', ['$http', ($http) ->
  obj =
    getInventory: (market, da) ->
      $http.get('/api/inventory/'+market+'/'+da)
  obj
]


