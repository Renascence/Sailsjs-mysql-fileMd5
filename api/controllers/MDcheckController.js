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
    getMd5.query('select * from md5values',function(err,md5) {
      console.log(md5)
      return res.send(md5)
    })
  }
};