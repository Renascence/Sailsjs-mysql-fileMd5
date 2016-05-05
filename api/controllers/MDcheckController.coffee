
module.exports = {
  get: (req, res) ->
    getMd5.query 'select * from md5Info', (err, md5) ->
      res.send(md5)
      
  delete: (req,res) ->
    getMd5.destroy({id : req.body.id})
    .then (data) ->
      res.send "delete success"

  create: (req, res) ->
    getMd5.create({
      name : req.body.name,
      md5 : req.body.md5,
      type : req.body.type,
      hot: 0
    })
    .then (data) ->
      res.send 200,"create success"
    .catch (err) ->
      res.send 500,err
      
  update: (req,res) ->
    getMd5.update({id:req.body.id},{hot:req.body.hot})
    .then (data) ->
      res.send "update success"
};