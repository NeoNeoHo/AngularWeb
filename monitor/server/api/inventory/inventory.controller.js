

var pg = require('pg');

var dbconfig = require('../dbconfig');

// Get a single thing
exports.getInventory = function(req, res) {
  var market = req.params.market;
  var da = req.params.da;
  var conString = "postgres://"+dbconfig.db99.user+":"+dbconfig.db99.passwd+"@" +
    dbconfig.db99.host+":"+dbconfig.db99.port+"/"+market;
  pg.connect(conString, function(err, client, done) {
    if(err) {
      return console.error('error fetching client from pool', err);
    }
    client.query('SELECT code from inventory where da=$1 order by code asc', [da], function(err, result) {
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
