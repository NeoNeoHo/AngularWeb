'use strict';

var express = require('express');
var controller = require('./alpha.controller');

var router = express.Router();

router.get('/:market/:da', controller.getAlpha);


module.exports = router;
