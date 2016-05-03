$(document).ready ()->
  $('#dropdownCtl').click () -> 
    $('#dropdownTarget').slideToggle(300)
  
  $('#uploadfile').click ->
    document.getElementById('fileName').innerHTML = ""
    document.getElementById('fileSize').innerHTML = ""
    document.getElementById('fileMD5').innerHTML = ""
    $('#processBar').css('width',0)    
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
        document.getElementById('fileMD5').innerHTML = spark.end()
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
