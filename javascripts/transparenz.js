(function() {
  $(function() {
    var saferworldPath;
    if ($('#transparenz .saferworld').length > 0) {
      saferworldPath = "" + rootPath + "/data/security/transparenz/saferworld.csv";
      return d3.csv(saferworldPath, function(data) {
        var options, saferworldChart;
        options = {
          showExtent: true,
          rotate: {
            x: true
          }
        };
        saferworldChart = new this.Barchart(data, options);
        _.map(data, function(d) {
          return d.Average = parseInt(d.Average);
        });
        data = _.sortBy(data, function(d) {
          return d.Average;
        });
        saferworldChart.setXDomain(data.map(function(d) {
          return d.Country;
        }));
        saferworldChart.setYDomain([
          d3.min(data, function(d) {
            return d.Average;
          }), 100
        ]);
        saferworldChart.setValueKey('Average');
        saferworldChart.setGroupKey('Country');
        return saferworldChart.render('.saferworld');
      });
    }
  });

}).call(this);
