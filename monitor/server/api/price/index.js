'use strict';

var express = require('express');
var controller = require('./price.controller');

var router = express.Router();

router.get('/:id', controller.getClose);


module.exports = router;
