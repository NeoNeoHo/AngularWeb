'use strict';

var express = require('express');
var controller = require('./alpha.controller');

var router = express.Router();

router.get('/:market/:da/:ndays', controller.getAlpha);


module.exports = router;
