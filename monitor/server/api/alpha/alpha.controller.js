

var pg = require('pg');

var dbconfig = require('../dbconfig');

// Get a single thing
exports.getAlpha = function(req, res) {
  var market = req.params.market;
  var da = req.params.da;
  var ndays = req.params.ndays;
  var conString = "postgres://"+dbconfig.db99.user+":"+dbconfig.db99.passwd+"@" +
    dbconfig.db99.host+":"+dbconfig.db99.port+"/www";
  pg.connect(conString, function(err, client, done) {
    if(err) {
      return console.error('error fetching client from pool', err);
    }
    var sqlString = "select vender, count(vender) as vender_count from top100_stock_performance where market=$1 and da=$2 group by vender order by count(vender) desc;";
    client.query(sqlString, [market, da], function(err, result) {
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

