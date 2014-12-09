(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Barchart = (function(_super) {
    __extends(Barchart, _super);

    function Barchart(data, options) {
      this.data = data;
      this.options = options != null ? options : {};
      this.options = _.defaults(this.options, {
        width: 800,
        height: 200,
        margin: {
          top: 40,
          right: 30,
          bottom: 120,
          left: 40
        },
        ticks: {
          y: 5,
          x: 4
        },
        rotate: {
          x: true,
          y: false
        }
      });
    }

    Barchart.prototype.createYAxis = function() {
      return this.svgSelection.append("g").attr("class", "y axis").attr("transform", "translate(0,0)").call(this.yAxis);
    };

    Barchart.prototype.setValueKey = function(key) {
      if (key == null) {
        key = 'value';
      }
      return this.valueKey = key;
    };

    Barchart.prototype.setGroupKey = function(key) {
      if (key == null) {
        key = 'group';
      }
      return this.groupKey = key;
    };

    Barchart.prototype.draw = function(data) {
      var countries, values;
      countries = this.svgSelection.selectAll('g.countries').data(this.data);
      countries.enter().append('g').attr('class', (function(_this) {
        return function(d) {
          return "countries " + d[_this.groupKey];
        };
      })(this)).attr('transform', (function(_this) {
        return function(d) {
          return "translate(" + (_this.xScale(d[_this.groupKey])) + ",0)";
        };
      })(this));
      values = countries.append('rect');
      values.attr('y', (function(_this) {
        return function(d) {
          return _this.yScale(d[_this.valueKey]);
        };
      })(this)).attr('width', this.xScale.rangeBand()).attr('height', (function(_this) {
        return function(d, i) {
          return _this.options.height - _this.yScale(d[_this.valueKey]);
        };
      })(this));
      countries.append('text').text((function(_this) {
        return function(d) {
          return d[_this.valueKey];
        };
      })(this)).attr('y', (function(_this) {
        return function(d) {
          return _this.yScale(d[_this.valueKey]) - 10;
        };
      })(this)).attr('x', this.xScale.rangeBand() / 2).attr('text-anchor', 'middle').attr('class', 'label');
      if (this.options.rotate.x) {
        return this.svgSelection.select('g.x.axis').selectAll("text").attr("y", 0).attr("x", 9).attr("dy", ".30em").attr("transform", "rotate(90)").style("text-anchor", "start");
      }
    };

    return Barchart;

  })(this.D3Graph);

}).call(this);
