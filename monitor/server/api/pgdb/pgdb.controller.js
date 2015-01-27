

var pg = require('pg');

var dbconfig = require('../dbconfig');

// Get a single thing
exports.query = function(req, res) {
  var database = req.body.dbname;
  var sqlstring = req.body.sqlstring;
  console.log(sqlstring);
  var conString = "postgres://"+dbconfig.db99.user+":"+dbconfig.db99.passwd+"@" +
    dbconfig.db99.host+":"+dbconfig.db99.port+"/"+database;
  pg.connect(conString, function(err, client, done) {
    if(err) {
      return console.error('error fetching client from pool', err);
    }
    client.query(sqlstring, [], function(err, result) {
      if(err) {
        return console.error('error running query', err);
      }
      client.end();
      var ldata = {};
      ldata.data = result.rows;
      console.log(result);
      return res.json(ldata);
    });
  });
};
