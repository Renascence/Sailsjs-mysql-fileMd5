/**
 * MDcheckController
 *
 * @description :: Server-side logic for managing Mdchecks
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {
  hi: function(req, res) {
    var json = {
      "tc": '1',
      "ali": '2',
      'baidu': '3'
    }
    return res.send(json);
  },
  get: function(req, res) {
    getMd5.findOne({id:"1"})
      .exec(function(err, md5) {
        if (err) {
          console.log('err',err)
          return res.json(err)
        }
        console.log("md5",md5)
        return res.send(md5);
      })
    // console.log(data)
    // return res.send(data.data)
  }
};