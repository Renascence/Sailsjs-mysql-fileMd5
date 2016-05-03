$(document).ready ()->
  log = document.getElementById('log')
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
        # console.log '1',spark.end()
        document.getElementById('fileMD5').innerHTML = spark.end()
        # document.getElementById('fileMD5').innerHTML = spark.end()
        
        # console.log '2',spark.end()
        # log.innerHTML += '</p>\nfinished loading :)\n\ncomputed hash:\n' + spark.end() + '\n\nyou can select another file now!\n</p>'
        # console.log '3',spark.end()
      return

    frOnerror = ->
      log.innerHTML += '\noops, something went wrong.'
      return

    loadNext = ->
      fileReader = new FileReader
      fileReader.onload = frOnload
      fileReader.onerror = frOnerror
      start = currentChunk * chunkSize
      end = if start + chunkSize >= file.size then file.size else start + chunkSize
      fileReader.readAsArrayBuffer blobSlice.call(file, start, end)
      return
      
    # log.style.display = 'inline-block'
    document.getElementById('fileName').innerHTML = file.name
    document.getElementById('fileSize').innerHTML = file.size.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ',') + ' bytes'
    # log.innerHTML = 'file name: ' + file.name + ' (' + file.size.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ',') + ' bytes)\n'
    loadNext()
    return
