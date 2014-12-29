(function() {
  var formatCurrency, generateDataForPointGraphFreeNotFreeRuestung, getNumberReducedByMagnitude, valueClassesForData;

  formatCurrency = d3.numberFormat(",");

  getNumberReducedByMagnitude = function(number, magnitude) {
    return Math.round(number / magnitude);
  };

  generateDataForPointGraphFreeNotFreeRuestung = function(data, year, multiplokator) {
    var freeNotFreeArray, freedomIndexObject, magnitudeFreeNotFree;
    if (multiplokator == null) {
      multiplokator = 15;
    }
    freedomIndexObject = _.findWhere(data, {
      time: year
    });
    freeNotFreeArray = [parseInt(freedomIndexObject.not_free), parseInt(freedomIndexObject.sum), parseInt(freedomIndexObject.partial_free), parseInt(freedomIndexObject.free)];
    magnitudeFreeNotFree = magnitude(d3.min(freeNotFreeArray));
    freedomIndexObject.not_free = getNumberReducedByMagnitude(freedomIndexObject.not_free, magnitudeFreeNotFree) * multiplokator;
    freedomIndexObject.sum = getNumberReducedByMagnitude(freedomIndexObject.sum, magnitudeFreeNotFree) * multiplokator;
    freedomIndexObject.free = getNumberReducedByMagnitude(freedomIndexObject.free, magnitudeFreeNotFree) * multiplokator;
    freedomIndexObject.partial_free = getNumberReducedByMagnitude(freedomIndexObject.partial_free, magnitudeFreeNotFree) * multiplokator;
    return freedomIndexObject;
  };

  valueClassesForData = function(data) {
    var _i, _j, _k, _ref, _ref1, _ref2, _ref3, _ref4, _results, _results1, _results2;
    return [
      {
        range: (function() {
          _results = [];
          for (var _i = 0, _ref = data.free; 0 <= _ref ? _i < _ref : _i > _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
          return _results;
        }).apply(this),
        className: "free"
      }, {
        range: (function() {
          _results1 = [];
          for (var _j = _ref1 = data.free, _ref2 = data.free + data.partial_free; _ref1 <= _ref2 ? _j < _ref2 : _j > _ref2; _ref1 <= _ref2 ? _j++ : _j--){ _results1.push(_j); }
          return _results1;
        }).apply(this),
        className: "partial-free"
      }, {
        range: (function() {
          _results2 = [];
          for (var _k = _ref3 = data.free + data.partial_free, _ref4 = data.sum; _ref3 <= _ref4 ? _k < _ref4 : _k > _ref4; _ref3 <= _ref4 ? _k++ : _k--){ _results2.push(_k); }
          return _results2;
        }).apply(this),
        className: "not-free"
      }
    ];
  };

  this.drawFreedomIndexPointVisualization = function(data) {
    var multipleOptions, multiplesData, pointGraph, sum2013, sumAllTime;
    sumAllTime = _.findWhere(data, {
      time: "all"
    }).sum;
    sum2013 = _.findWhere(data, {
      time: "2013"
    }).sum;
    generateDataForPointGraphFreeNotFreeRuestung(data, "all", 15);
    multiplesData = generateDataForPointGraphFreeNotFreeRuestung(data, "2013", 5);
    multipleOptions = {
      height: 100,
      circles: {
        radius: 8,
        padding: 5
      }
    };
    pointGraph = new this.PointGraph([multiplesData], multipleOptions);
    pointGraph.setValueKeys("sum", "free");
    pointGraph.setValueClasses(valueClassesForData(multiplesData));
    pointGraph.render("#multiples #multiple-exports");
    $('.export-volumes h2').text("$" + (formatCurrency(sum2013)));
    return $('#multiples form input').change(function(e) {
      if (this.value === 'all') {
        multiplesData = _.findWhere(data, {
          time: 'all'
        });
        pointGraph.setValueClasses(valueClassesForData(multiplesData));
        pointGraph.update([multiplesData]);
        return $('.export-volumes h2').text("$" + (formatCurrency(sumAllTime)));
      } else {
        multiplesData = _.findWhere(data, {
          time: '2013'
        });
        pointGraph.setValueClasses(valueClassesForData(multiplesData));
        pointGraph.update([multiplesData]);
        return $('.export-volumes h2').text("$" + (formatCurrency(sum2013)));
      }
    });
  };

  $(function() {
    var freedomIndexExportsPath;
    if ($('#freedom-index').length > 0) {
      freedomIndexExportsPath = rootPath + "/data/freedom_index_exports.csv";
      return d3.csv(freedomIndexExportsPath, function(data) {
        return this.drawFreedomIndexPointVisualization(data);
      });
    }
  });

}).call(this);
