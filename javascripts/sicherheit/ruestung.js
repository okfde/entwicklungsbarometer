(function() {
  $(function() {
    var exportPath;
    if ($('#ruestung').length > 0) {
      exportPath = "" + rootPath + "/data/security/armsexports/weighted_exports_historical.csv";
      return d3.csv(exportPath, function(data) {
        var exportChart, options;
        options = {
          rotate: {
            x: true
          }
        };
        exportChart = new this.Barchart(data, options);
        _.map(data, function(d) {
          return d.WeightedExports = parseFloat(d.WeightedExports) * (-1);
        });
        data = _.sortBy(data, function(d) {
          return d.WeightedExports;
        });
        exportChart.setXDomain(data.map(function(d) {
          return d.Country;
        }));
        exportChart.setYDomain(d3.extent(data, function(d) {
          return parseFloat(d.WeightedExports);
        }));
        exportChart.setValueKey('WeightedExports');
        exportChart.setGroupKey('Country');
        return exportChart.render('.exports-percent-gdp');
      });
    }
  });

}).call(this);
