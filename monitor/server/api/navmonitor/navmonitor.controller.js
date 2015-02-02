

var pg = require('pg');
var Q = require('q');
var dbconfig = require('../dbconfig');
var market_config = require('../market_config');

// Get a single thing
exports.getNav = function(req, res) {
  var market = req.params.market;
  var render_data = {};
  var promises = [];
  var p1 = get_model_nav(market);

  promises.push(p1);

  Q.all(promises)
    .then(function(data){
      render_data.model_nav = data[0];
      console.log(market_config.cn.index_code);
      return res.json(render_data);
    });
};

var get_model_nav = function(market){
  var def = Q.defer();
  var conString = "postgres://"+dbconfig.db99.user+":"+dbconfig.db99.passwd+"@" +
    dbconfig.db99.host+":"+dbconfig.db99.port+"/"+market;
  pg.connect(conString, function(err, client, done) {
    if(err) {
      return console.error('error fetching client from pool', err);
    }
    var sqlString = "SELECT to_char(da,'YYYY-MM-DD') as da,alpha from public.model_alpha where da>=$1 order by da asc;";
    client.query(sqlString, ["2012-05-25"], function(err, result) {
      if(err) {
        return console.error('error running query', err);
      }
      client.end();
      var ldata = {};
      var rows = result.rows;
      var nav = 1;
      var data = [];
      for(var i=0; i < rows.length; i++){
        var row = rows[i];
        var t_stamp = new Date(row.da).getTime();
        nav = nav * (1 + row.alpha);
        var row_data = [t_stamp, nav];
        data.push(row_data);
      }
      ldata.data = data;
      def.resolve(ldata);
    });
  });
  return def.promise;
};

var get_index_nav = function(market){
  var def = Q.defer();
  var conString = "postgres://"+dbconfig.db99.user+":"+dbconfig.db99.passwd+"@"+
      dbconfig.db99.host+":"+dbconfig.db99.port+"/daily";
};
