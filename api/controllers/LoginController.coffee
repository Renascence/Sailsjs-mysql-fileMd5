module.exports = {
  login: (req, res) ->
    console.log req.body
    userInfo.findOne ( {username:req.body.username} )
    .then (data) ->
      if data.password is req.body.password
        res.send "login success"
      else
        res.send "password err"
    .catch (err) ->
      res.send "no username"
};