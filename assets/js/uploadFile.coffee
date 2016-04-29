$(document).ready ()->
  console.log "cahnge  "
  log = document.getElementById('log')
  $('#uploadfile').change ->
    blobSlice = File::slice or File::mozSlice or File::webkitSlice
    file = @files[0]
    chunkSize = 2097152
    chunks = Math.ceil(file.size / chunkSize)
    currentChunk = 0
    spark = new (SparkMD5.ArrayBuffer)

    frOnload = (e) ->
      log.innerHTML += '<p>read chunk number ' + parseInt(currentChunk + 1) + ' of ' + chunks + '</p>'
      spark.append e.target.result
      # append array buffer
      currentChunk++
      if currentChunk < chunks
        loadNext()
      else
        log.innerHTML += '\nfinished loading :)\n\ncomputed hash:\n' + spark.end() + '\n\nyou can select another file now!\n'
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

    log.style.display = 'inline-block'
    log.innerHTML = 'file name: ' + file.name + ' (' + file.size.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ',') + ' bytes)\n'
    loadNext()
    return
