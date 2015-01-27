'use strict';

var express = require('express');
var controller = require('./inventory.controller');

var router = express.Router();

router.get('/:market/:da', controller.getInventory);


module.exports = router;
