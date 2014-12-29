(function() {
  var valueClassesForData, wertschoepfungPerYear;

  valueClassesForData = function(data) {
    var _i, _ref, _results;
    return [
      {
        range: (function() {
          _results = [];
          for (var _i = _ref = 928 - data; _ref <= 928 ? _i < 928 : _i > 928; _ref <= 928 ? _i++ : _i--){ _results.push(_i); }
          return _results;
        }).apply(this),
        className: "german-exports-gdp"
      }
    ];
  };

  wertschoepfungPerYear = function(data, year) {
    if (year == null) {
      year = "2013";
    }
    return _.findWhere(data, {
      year: year
    });
  };

  $(function() {
    var gdpPath;
    if ($('#german-gdp').length > 0) {
      gdpPath = rootPath + "/data/security/gdp/wertschoepfung-magnitudes.csv";
      return d3.csv(gdpPath, function(data) {
        var options, pointGraph;
        data = wertschoepfungPerYear(data, "2011");
        options = {
          height: 750,
          circles: {
            radius: 6,
            padding: 5
          }
        };
        pointGraph = new PointGraph([data], options);
        pointGraph.setValueClasses(valueClassesForData(data["GDP.Ruestung"]));
        pointGraph.setValueKeys("GDP", "GDP.Ruestung");
        return pointGraph.render(".german-gdp");
      });
    }
  });

}).call(this);
