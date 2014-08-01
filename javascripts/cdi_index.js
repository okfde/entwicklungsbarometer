(function() {
  this.subIndex = function(data, countryName) {
    var axisSubX, classes, country, indicators, margin, score, subHeight, subSvg, subX, subXAxis, subY, width, _i, _ref, _results;
    if (countryName == null) {
      countryName = 'Germany';
    }
    margin = {
      top: 10,
      right: 30,
      bottom: 150,
      left: 40
    };
    width = 900;
    subHeight = 200;
    classes = ['max-score', 'score'];
    country = _.rest(_.values(_.findWhere(data, {
      Country: countryName
    })));
    subY = d3.scale.linear().range([subHeight, 0]).domain([0, 10]);
    subX = d3.scale.ordinal().rangeRoundBands([0, width], .1).domain((function() {
      _results = [];
      for (var _i = 0, _ref = country.length; 0 <= _ref ? _i < _ref : _i > _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
      return _results;
    }).apply(this));
    axisSubX = d3.scale.ordinal().rangeRoundBands([0, width], .1).domain(_.rest(_.keys(data[0])));
    d3.select('.cdi-country-sub-index h2').text(countryName);
    subSvg = d3.select('.cdi-country-sub-index svg').attr("width", width + margin.left + margin.right).attr("height", subHeight + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    indicators = subSvg.selectAll('g').data(country);
    indicators.enter().append('g').attr('transform', function(d, i) {
      return "translate(" + (subX(i)) + ",0)";
    });
    indicators.append('rect').attr('y', 0).attr('width', subX.rangeBand()).attr('height', subHeight).attr('class', classes[0]);
    indicators.append('text').text(function(d) {
      return d;
    }).attr('y', function(d) {
      return subY(d) - 10;
    }).attr('x', subX.rangeBand() / 2).attr("text-anchor", "middle");
    score = indicators.append('rect');
    score.attr('y', function(d) {
      return subY(d);
    }).attr('width', subX.rangeBand()).attr('height', function(d, i) {
      return subHeight - subY(d);
    }).attr('class', function(d, i) {
      return classes[1];
    });
    subXAxis = d3.svg.axis().scale(axisSubX).orient("bottom");
    return subSvg.append("g").attr("class", "x axis").attr("transform", "translate(0," + subHeight + ")").call(subXAxis).selectAll("text").attr("y", 0).attr("x", 9).attr("dy", ".30em").attr("transform", "rotate(90)").style("text-anchor", "start");
  };

  this.cdi_index = function(element, key) {
    if (key == null) {
      key = 'Overall';
    }
    return d3.csv(rootPath + '/data/cdi.csv', function(err, data) {
      var classes, countries, dx, height, heights, margin, scale, score, subHeight, svg, width, x, xAxis, y;
      data = _.sortBy(data, function(d) {
        return d[key];
      });
      heights = [40, 20];
      dx = [0, 10];
      classes = ['max-score', 'score'];
      margin = {
        top: 10,
        right: 30,
        bottom: 150,
        left: 40
      };
      width = 900;
      height = 300;
      subHeight = 200;
      scale = d3.scale.linear().domain([0, 10]).range([0, width]);
      y = d3.scale.linear().range([height, 0]).domain([0, 10]);
      x = d3.scale.ordinal().rangeRoundBands([0, width], .1).domain(data.map(function(d) {
        return d.Country;
      }));
      svg = d3.select(element).append('svg').attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
      countries = svg.selectAll('g').data(data);
      countries.enter().append('g').attr('class', function(d) {
        return d.Country;
      }).attr('transform', function(d) {
        return "translate(" + (x(d.Country)) + ",0)";
      });
      countries.append('rect').attr('y', 0).attr('width', x.rangeBand()).attr('height', height).attr('class', classes[0]);
      score = countries.append('rect');
      score.attr('y', function(d) {
        return y(d[key]);
      }).attr('width', x.rangeBand()).attr('height', function(d, i) {
        return height - y(d[key]);
      }).attr('class', function(d, i) {
        return classes[1];
      });
      countries.append('text').text(function(d) {
        return d[key];
      }).attr('y', function(d) {
        return y(d[key]) - 10;
      }).attr('x', x.rangeBand() / 2).attr('text-anchor', 'middle');
      xAxis = d3.svg.axis().scale(x).orient("bottom");
      svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis).selectAll("text").attr("y", 0).attr("x", 9).attr("dy", ".30em").attr("transform", "rotate(90)").style("text-anchor", "start");
      if (key === 'Overall') {
        d3.select('.cdi-country-sub-index').append('h2').text('Germany');
        d3.select('.cdi-country-sub-index').append('svg');
        return subIndex(data);
      }
    });
  };

}).call(this);
