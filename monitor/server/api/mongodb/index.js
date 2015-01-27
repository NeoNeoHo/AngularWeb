'use strict';

var express = require('express');
var router = express.Router();

var mongo = require("mongoskin");
var _ = require("underscore")._;

var connect = function(dbName,next){
  var db = mongo.db("mongodb://localhost:27017/" + dbName, {safe : true});
  next(db);
};

router.get("/", function(req,res){
  var out = {
    root : "/api/mongodb/dbs",
    database : "/api/mongodb/:database",
    collection : "/api/mongodb/:database/:collection",
    document : "/api/mongodb/:database/:collection/:id"
  };
  res.json(out);
});


//list of all databases
router.get("/dbs",function(req,res){
  var out = [];
  connect("admin",function(db){
    db.admin.listDatabases(function(err,result){
      var out = [];
      _.each(result.databases,function(item){
        var formatted = {
          name : item.name,
          details : "/" + item.name,
          type : "database"
        };
        out.push(formatted);
      });
      res.json(out);
    });
  });
});

router.delete("/dbs",function(req,res){
  var dbName = req.query.name
  if(!dbName) throw {error : "Need a db to delete"}
  connect(dbName, function(db){
    db.dropDatabase(function(err,result){
      if(err) throw({error : err});
      res.send("OK");
    });
  });
});


router.post("/dbs",function(req,res){
  var dbName = req.body.name;
  if(!dbName) throw({error : "Need a database name"});
  connect(dbName, function(db){
    db.createCollection("users",function(err,result){
      res.json(formatDbResponse(dbName));
    });
  });

});


router.get("/:db",function(req,res){
  var dbName = req.params.db;
  connect(dbName, function(db){
    var out = [];
    db.collectionNames(function(err,collNames){
      _.each(collNames, function(collName){
        var cleanName = collName.name.replace(dbName + ".","");
        var formatted = {
          name : cleanName,
          details : "/" + dbName + "/" + cleanName,
          database : dbName,
          type : "collection"
        };
        if(cleanName != "system.indexes")
          out.push(formatted);
      });
      res.json(out);
    });
  });
});


router.post("/:db",function(req,res){
  //adds a collection
  var collectionName = req.body.name;
  var dbName = req.params.db;
  var out = [];
  connect(dbName, function(db){
    db.createCollection(collectionName, function(err,result){
      var out = {
        name : collectionName,
        type : "collection",
        details : "/" + db + "/" + collectionName
      };
      res.json(out);
    });
  });
});


router.get("/:db/:collection",function(req,res){
  var dbName = req.params.db;
  var collName = req.params.collection;
  var out = [];
  connect(dbName, function(db){
    db.collection(collName).find().limit(50).toArray(function(err,items){
      var out = [];
      _.each(items,function(item){
        var formatted = {
          name : item.name,
          id : item._id,
          details : "/" + dbName + "/" + collName + "/" + item._id,
          type : "document"
        };
        out.push(formatted)
      });

      res.json(out);
    });
  });
});


router.get("/:db/:collection/:id",function(req,res){
  var dbName = req.params.db;
  var id = req.params.id;
  var collName = req.params.collection;
  connect(dbName, function(db){
    db.collection(collName).findById(id,function(err,doc){
      var out = {
        database : dbName,
        collection : collName,
        id : id,
        document : doc
      };
      res.json(out);
    });
  });
});

//stubbed query method for later use
router.post("/query", function(req,res){
  var dbName = req.body.db;
  var collection = req.body.collection;
  var queryText = req.body.query;

  if(queryText.substring(0,1) != "{"){
    queryText = "{" + queryText + "}";
  }
  var query = JSON.parse(queryText);
  connect(dbName, function(db){
    db.collection(collection).find(query).toArray(function(err,response){
      res.json(response);
    });
  })

});


router.delete("/:db", function(req,res) {
  var dbName = req.params.db;
  var collectionName = req.query.name;
  connect(dbName, function(db){
    db.dropCollection(collectionName,function(err,result){
      res.json(result);
    });
  });
});


router.post("/:db/:collection",function(req,res){
  var dbName = req.params.db;
  connect(dbName, function(db){
    var doc = req.body;
    db.collection(req.params.collection).insert(doc, function(err,result){
      var out ={error : err, result : result};
      res.json(out);
    });
  });
});

router.put("/:db/:collection/:id",function(req,res){
  var dbName = req.params.db;
  connect(dbName, function(db){
    var doc = req.body;
    delete doc._id;
    db.collection(req.params.collection).updateById(req.params.id, doc, {}, function(err,result){
      var out ={error : err, result : result};
      res.json(out);
    });
  });
});

module.exports = router;


