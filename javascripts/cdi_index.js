(function() {
  this.CDISubIndex = (function() {
    function CDISubIndex(data, categories, options) {
      this.data = data;
      this.categories = categories;
      this.options = options != null ? options : {};
      this.options = _.defaults(this.options, {
        width: 900,
        height: 200,
        margin: {
          top: 40,
          right: 30,
          bottom: 150,
          left: 40
        }
      });
      this.classes = ['max-score', 'score'];
    }

    CDISubIndex.prototype.createSvg = function() {
      this.svgSelection || (this.svgSelection = d3.select(this.element).append('svg').attr('width', this.options.width + this.options.margin.left + this.options.margin.right).attr('height', this.options.height + this.options.margin.top + this.options.margin.bottom).append("g").attr("transform", "translate(" + this.options.margin.left + "," + this.options.margin.top + ")"));
      return this.svgSelection.append("g").attr("class", "x axis").attr("transform", "translate(0," + this.options.height + ")").call(this.xAxis);
    };

    CDISubIndex.prototype.createAxisAndScales = function(data) {
      var _i, _ref, _results;
      this.yScale = d3.scale.linear().range([this.options.height, 0]).domain([0, 13]);
      this.xScale = d3.scale.ordinal().rangeRoundBands([0, this.options.width], .1).domain((function() {
        _results = [];
        for (var _i = 0, _ref = this.categories.length; 0 <= _ref ? _i < _ref : _i > _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this));
      this.xAxisScale = d3.scale.ordinal().rangeRoundBands([0, this.options.width], .1).domain(this.categories);
      return this.xAxis = d3.svg.axis().scale(this.xAxisScale).orient("bottom");
    };

    CDISubIndex.prototype.draw = function(data) {
      var indicators, label, max, score;
      indicators = this.svgSelection.selectAll('g.graphs').data(data);
      indicators.enter().append('g').attr('transform', (function(_this) {
        return function(d, i) {
          return "translate(" + (_this.xScale(i)) + ",0)";
        };
      })(this)).attr('class', 'graphs');
      indicators.exit().remove();
      max = indicators.selectAll("rect." + this.classes[0]).data([1]);
      max.enter().append('rect');
      max.attr('y', 0).attr('width', this.xScale.rangeBand()).attr('height', this.options.height).attr('class', this.classes[0]);
      max.exit().remove();
      label = indicators.selectAll('text').data(function(d) {
        return [d];
      });
      label.enter().append('text');
      label.text(function(d) {
        return d;
      }).attr('y', (function(_this) {
        return function(d) {
          return _this.yScale(d) - 10;
        };
      })(this)).attr('x', this.xScale.rangeBand() / 2).attr("text-anchor", "middle");
      label.exit().remove();
      score = indicators.selectAll("rect." + this.classes[1]).data(function(d) {
        return [d];
      });
      score.exit().remove();
      score.enter().append('rect');
      return score.attr('y', (function(_this) {
        return function(d) {
          return _this.yScale(d);
        };
      })(this)).attr('width', this.xScale.rangeBand()).attr('height', (function(_this) {
        return function(d, i) {
          return _this.options.height - _this.yScale(d);
        };
      })(this)).attr('class', (function(_this) {
        return function(d, i) {
          return _this.classes[1];
        };
      })(this));
    };

    CDISubIndex.prototype.render = function(element) {
      this.element = element;
      this.createAxisAndScales(this.data);
      this.createSvg();
      return this.draw(this.data);
    };

    CDISubIndex.prototype.update = function(data) {
      this.data = data;
      return this.draw(data);
    };

    return CDISubIndex;

  })();

  this.updateSubIndex = function(data, countryName) {
    var country;
    if (countryName == null) {
      countryName = 'Germany';
    }
    if ($('.cdi-country-sub-index').length > 0) {
      country = _.rest(_.values(_.findWhere(data, {
        Country: countryName
      })));
      this.subIndex = $('.cdi-index-overall').data('cdi-sub');
      $('.cdi-country-sub-index h2').text(countryName);
      return this.subIndex.update(country);
    }
  };

  this.cdi_index = function(element, key) {
    if (key == null) {
      key = 'Overall';
    }
    return d3.csv(rootPath + '/data/cdi.csv', function(err, data) {
      var categories, classes, countries, country, dx, height, heights, margin, scale, score, subHeight, svg, width, x, xAxis, y;
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
      country = _.rest(_.values(_.findWhere(data, {
        Country: 'Germany'
      })));
      categories = _.rest(_.keys(_.findWhere(data, {
        Country: 'Germany'
      })));
      this.subIndex = new CDISubIndex(country, categories);
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
      }).on('mouseover', (function(_this) {
        return function(d) {
          return _this.updateSubIndex(data, d.Country);
        };
      })(this));
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
        this.subIndex.render('.cdi-country-sub-index .graph');
        return $('.cdi-index-overall').data('cdi-sub', this.subIndex);
      }
    });
  };

}).call(this);
