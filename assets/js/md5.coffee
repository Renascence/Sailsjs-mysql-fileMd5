md5Module = angular.module 'md5',['angularFileUpload']

md5Module.controller 'mainCtl',['$http','$scope',($http,$scope)->
  $scope.getFileMD5 = () ->
    console.log $scope.email
    $http.get('/files1.json')
    .then (res)->
      console.log '11',res
    .catch (err) ->
      console.log '22',err      
]