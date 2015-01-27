'use strict';

var express = require('express');
var controller = require('./pgdb.controller');

var router = express.Router();

//:dbname/:sqlstring
router.post('/query', controller.query);


module.exports = router;
