md5Module = angular.module 'md5',['angular-md5','ngTable','ngCookies']

md5Module.service 'httpService',['$http',($http)->
  _getFileInfo = () ->
    $http.get('/filesInfo.json')
    .then (res) ->
      return res.data  
    
  _delFileInfo = (_id) ->
    $http.post('/deleteInfo.json',_id)
    .then (res) ->
      return res
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
  
  $scope.uploadfileName = ""
  
  $scope.uploadfileSize = ""
  
  $scope.uploadfileMd5 = ""
  
  $scope.recommendedFlag = false
  
  $scope.recommendArr = []
  
  $scope.loginErr = false
  
  $scope.createMd5Flag = false
  
  httpService.getFileInfo()
  .then (res) ->
    $scope.filesInfoTable = new NgTableParams({
      page:1,
      count:res.length  
    },{data:res})
    $scope.filesInfoTable.settings().counts.length = []

  $scope.login = () ->
    data = 
      username:$scope.username
      password:$scope.password
    $http.post('/login.json',data)
    .then (res)->
      if res.data is "login success"
        $scope.loginErr = false
        $cookieStore.put("name",$scope.username);
        $scope.cookieUsername = $cookieStore.get('name') || ""
        $scope.username = ""
        $scope.password = ""
        window.location.reload()
      else
        $scope.loginErr = true
        
  $scope.logout = () ->
    $cookieStore.remove("name")
    $scope.cookieUsername = $cookieStore.get('name') || ""
    window.location.reload()
    
    
  $scope.$watch 'inputString' ,()-> 
    if !$scope.inputString
      $scope.message = ""
    else
      $scope.message = md5.createHash($scope.inputString||"")
    

  $scope.createMd5Info = () ->
    if !$scope.createName or !$scope.createMd5Value or !createType
      $scope.createMd5Flag = true
      return
    else
      $scope.createMd5Flag = false 
      data = 
        name : $scope.createName
        md5 : $scope.createMd5Value
        type : $scope.createType
      $http.post('/createMd5.json',data)
      .then () ->
        $scope.createName = ""
        $scope.createMd5Value = ""
        $scope.createType = ""
        httpService.getFileInfo()
        .then (data) ->
          $scope.filesInfoTable.settings().data = data
          $scope.filesInfoTable.count(data.length)
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
        
  $('#uploadfile').click ->
    document.getElementById('fileName').innerHTML = ""
    document.getElementById('fileSize').innerHTML = ""
    document.getElementById('fileMD5').innerHTML = ""
    $('#processBar').css('width',0)
    $('#recommand').css('display','none')
    return
        
  $('#uploadfile').change ->
    blobSlice = File::slice or File::mozSlice or File::webkitSlice
    file = @files[0]
    chunkSize = 2097152
    chunks = Math.ceil(file.size / chunkSize)
    currentChunk = 0
    spark = new (SparkMD5.ArrayBuffer)

    frOnload = (e) ->
      spark.append e.target.result
      currentChunk++
      processWidth = currentChunk / chunks
      processWidth = processWidth*100 + "%"
      $('#processBar').css('width',processWidth)
      if currentChunk < chunks
        loadNext()
      else
        Md5 = spark.end()
        document.getElementById('fileMD5').innerHTML = Md5 
        $scope.uploadfileMd5 = Md5
        $scope.recommended(Md5)
      return
      
    frOnerror = ->
      alert("选择的文件无法上传，请重新选择")
      return
      
    loadNext = ->
      fileReader = new FileReader
      fileReader.onload = frOnload
      fileReader.onerror = frOnerror
      start = currentChunk * chunkSize
      end = if start + chunkSize >= file.size then file.size else start + chunkSize
      fileReader.readAsArrayBuffer blobSlice.call(file, start, end)
      return
    document.getElementById('fileName').innerHTML = file.name
    document.getElementById('fileSize').innerHTML = file.size.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ',') + ' bytes'
    loadNext()
    return
    
  $scope.recommended = (md5)->
    fileType = ""
    resArr = []
    
    for i in $scope.filesInfoTable.data
      if i.md5 is md5
        fileType = i.type
        
    if fileType == ""
      return
      
    $('#recommand').css('display','block')
    for i in $scope.filesInfoTable.data
      if i.type is fileType
        resArr.push i
    $.each(resArr,(i,obj)->
      $.each(resArr,(j,object)->
        if resArr[j+1]
          if resArr[j+1].hot > resArr[j].hot
            temp = resArr[j+1]
            resArr[j+1] = resArr[j]
            resArr[j] = temp
      )
    )
    $scope.recommendArr = resArr.splice(0,3)
    document.getElementById('recommand1').innerHTML = $scope.recommendArr[0].name.split(' ')[0]
    document.getElementById('recommand1').href = "http://cn.bing.com/search?q=" + $scope.recommendArr[0].name
    document.getElementById('recommand2').innerHTML = $scope.recommendArr[1].name.split(' ')[0]
    document.getElementById('recommand2').href = "http://cn.bing.com/search?q=" + $scope.recommendArr[1].name
    document.getElementById('recommand3').innerHTML = $scope.recommendArr[2].name.split(' ')[0]
    document.getElementById('recommand3').href = "http://cn.bing.com/search?q=" + $scope.recommendArr[2].name
    return
  
  $scope.updateHot = (num)->
    data = 
      id:$scope.recommendArr[num].id
      hot:$scope.recommendArr[num].hot+1
    $http.post('/updateHot.json',data)
    .catch(err) ->
      console.log err
]