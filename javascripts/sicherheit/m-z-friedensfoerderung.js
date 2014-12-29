(function() {
  $(function() {
    var civilMilitaryPath;
    if ($('#friedensfoerderung').length > 0) {
      civilMilitaryPath = "" + rootPath + "/data/security/friedensfoerderung/military-civil-germany.csv";
      return d3.csv(civilMilitaryPath, function(data) {
        var chart, options, stackedData;
        data.forEach(function(d) {
          return d.year = new Date(d.year, 0, 1);
        });
        stackedData = ["civil", "military"].map(function(name) {
          return {
            name: name,
            values: data.map(function(d) {
              return {
                date: d.year,
                y: parseFloat(d[name])
              };
            })
          };
        });
        options = {
          width: $('.zmf').width(),
          height: 300,
          margin: {
            top: 40,
            right: 50,
            left: 50,
            bottom: 20
          }
        };
        chart = new this.AreaChart(stackedData, options);
        chart.setYDomain([
          0, d3.max(data, function(d) {
            return parseFloat(d.military) + parseFloat(d.civil);
          })
        ]);
        chart.setXDomain(d3.extent(data, function(d) {
          return d.year;
        }));
        chart.setDateKey("date");
        chart.setDataKey("y");
        return chart.render(".zmf");
      });
    }
  });

}).call(this);
