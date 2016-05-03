md5Module = angular.module 'md5',['angular-md5','ngTable']

md5Module.service 'httpService',['$http',($http)->
  _getFileInfo = () ->
    $http.get('/filesInfo.json')
    .then (res) ->
      return res.data
  
    
  return {
    getFileInfo : _getFileInfo
  }
]

md5Module.controller 'mainCtl',['$http','$scope','md5','httpService','NgTableParams',($http,$scope,md5,httpService,NgTableParams)->
  $scope.fileInfo = ""
  $scope.createName = ""
  $scope.createMd5Value = ""
  $scope.createType = ""
  $scope.$watch 'inputString' ,()-> 
    if !$scope.inputString
      $scope.message = ""
    else
      $scope.message = md5.createHash($scope.inputString||"")
    
  httpService.getFileInfo()
  .then (res) ->
    console.log res
    $scope.fileInfo = res
    $scope.filesInfoTable = new NgTableParams({
      page:1,
      count:20
    },{data:$scope.fileInfo})
    $scope.filesInfoTable.settings().counts.length = []
  
  $scope.createMd5 = () ->
    console.log "1111"
    data = 
      name : $scope.createName
      md5 : $scope.createMd5Value
      type : $scope.createType
    $http.post('/createMd5.json',data)
]