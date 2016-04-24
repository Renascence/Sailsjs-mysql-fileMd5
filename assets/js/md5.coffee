md5Module = angular.module 'md5',[]

md5Module.controller 'mainCtl',['$http','$scope',($http,$scope)->
  $scope.postFile = () ->
    $http.post('/files1.json',{msg:'hello'})
    .then (res)->
      console.log '11',res.data
    .catch (err) ->
      console.log '22',err
]