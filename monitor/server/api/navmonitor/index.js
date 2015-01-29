'use strict';

var express = require('express');
var controller = require('./navmonitor.controller');

var router = express.Router();

router.get('/:market', controller.getNav);


module.exports = router;
