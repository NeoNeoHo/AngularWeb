

var pg = require('pg');

var dbconfig = require('../dbconfig');

// Get a single thing
exports.getClose = function(req, res) {
  var code = req.params.id;
  var conString = "postgres://"+dbconfig.db99.user+":"+dbconfig.db99.passwd+"@" +
    dbconfig.db99.host+":"+dbconfig.db99.port+"/daily";
  pg.connect(conString, function(err, client, done) {
    if(err) {
      return console.error('error fetching client from pool', err);
    }
    client.query('SELECT da,cl from price where code=$1 order by da asc', [code], function(err, result) {
      if(err) {
        return console.error('error running query', err);
      }
      client.end();
      var ldata = {};
      ldata.data = result.rows;
      return res.json(ldata);
    });
  });
};
