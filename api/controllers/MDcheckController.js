/**
 * MDcheckController
 *
 * @description :: Server-side logic for managing Mdchecks
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {
  hi: function (req, res) {
    var json = {
      "tc":'1',
      "ali":'2',
      'baidu':'3'
    }
    return res.send(json);
  },
  get: function (req,res) {
    return res.getMd5.findOne({id:'1'})
  },
  bye: function (req, res) {
    return res.redirect("http://www.sayonara.com");
  }
};

