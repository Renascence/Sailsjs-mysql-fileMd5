
module.exports = {
  get: (req, res) ->
    getMd5.query 'select * from md5Info', (err, md5) ->
      res.send(md5)
      
  create: (req, res) ->
    getMd5.create({
      name : req.body.name,
      md5 : req.body.md5,
      type : req.body.type,
      hot: '0'
    })
    .then (res) ->
      res.send 200,"create success"
    .catch (err) ->
      res.send 500,err
};