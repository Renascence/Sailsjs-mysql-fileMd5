md5Module = angular.module 'md5',['angular-md5','ngTable','ngCookies']

md5Module.service 'httpService',['$http',($http)->
  _getFileInfo = () ->
    $http.get('/filesInfo.json')
    .then (res) ->
      return res.data  
    
  _delFileInfo = (_id) ->
    $http.post('/deleteInfo.json',_id)
    .then (res) ->
      console.log res
  return {
    getFileInfo : _getFileInfo
    delFileInfo : _delFileInfo
  }
]

md5Module.controller 'mainCtl',['$http','$scope','md5','httpService','NgTableParams','$cookieStore','$cookies',($http,$scope,md5,httpService,NgTableParams,$cookieStore,$cookies)->
  
  $scope.createName = ""
  $scope.createMd5Value = ""
  $scope.createType = ""
  $scope.filesInfoTable = ""
  $scope.cookieUsername = $cookieStore.get('name') || ""

  httpService.getFileInfo()
  .then (res) ->
    $scope.filesInfoTable = new NgTableParams({
      page:1,
      count:10
    },{data:res})
    $scope.filesInfoTable.settings().counts.length = []

  $scope.login = () ->
    data = 
      username:$scope.username
      password:$scope.password
    console.log data
    $http.post('/login.json',data)
    .then (res)->
      if res.data is "login success"
        $cookieStore.put("name",$scope.username);
        $scope.cookieUsername = $cookieStore.get('name') || ""
        $scope.username = ""
        $scope.password = ""
        
  $scope.logout = () ->
    $cookieStore.remove("name")
    $scope.cookieUsername = $cookieStore.get('name') || ""
    
  $scope.$watch 'inputString' ,()-> 
    if !$scope.inputString
      $scope.message = ""
    else
      $scope.message = md5.createHash($scope.inputString||"")
    

  $scope.createMd5Info = () ->
    console.log 1112
    data = 
      name : $scope.createName
      md5 : $scope.createMd5Value
      type : $scope.createType
    $http.post('/createMd5.json',data)
    .then () ->
      $scope.createName = ""
      $scope.createMd5Value = ""
      $scope.createType = ""
      console.log "add success"
      httpService.getFileInfo()
      .then (data) ->
        $scope.filesInfoTable.settings().data = data
        $scope.filesInfoTable.reload()
  
  $scope.deleteMd5 = (_id) ->
    data = 
      id: _id
    httpService.delFileInfo(data)
    .then (res) ->
      httpService.getFileInfo()
      .then (data) ->
        $scope.filesInfoTable.settings().data = data
        $scope.filesInfoTable.reload()
]