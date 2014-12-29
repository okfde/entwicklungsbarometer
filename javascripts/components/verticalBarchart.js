(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.VerticalBarchart = (function(_super) {
    __extends(VerticalBarchart, _super);

    function VerticalBarchart(data, options) {
      this.data = data;
      this.options = options != null ? options : {};
      VerticalBarchart.__super__.constructor.call(this, this.data, this.options);
    }

    VerticalBarchart.prototype.createAxisAndScales = function(data) {
      this.yScale = d3.scale.ordinal().rangeRoundBands([0, this.options.height], .1).domain(this.yScaleDomain);
      this.xScale = d3.scale.linear().range([0, this.options.width]).domain(this.xScaleDomain);
      this.xAxisScale = d3.scale.linear().range([0, this.options.width]).domain(this.xScaleDomain);
      this.yAxisScale = d3.scale.ordinal().rangeRoundBands([0, this.options.height], .1).domain(this.yScaleDomain);
      this.xAxis = d3.svg.axis().scale(this.xAxisScale).orient("bottom");
      return this.yAxis = d3.svg.axis().scale(this.yAxisScale).orient("left");
    };

    VerticalBarchart.prototype.appendAxis = function() {
      return this.createYAxis();
    };

    VerticalBarchart.prototype.showExtent = function() {
      return this.countries.append('rect').attr('x', 0).attr('height', this.yScale.rangeBand()).attr('width', this.options.width).attr('class', this.extentClass);
    };

    VerticalBarchart.prototype.drawValueText = function() {
      this.countries.selectAll('text').remove();
      return this.countries.append('text').text((function(_this) {
        return function(d) {
          return d[_this.valueKey];
        };
      })(this)).attr('x', (function(_this) {
        return function(d) {
          return _this.xScale(d[_this.valueKey]) + 10;
        };
      })(this)).attr('y', this.yScale.rangeBand() / 2 + 2).attr('text-anchor', 'middle').attr('class', 'label');
    };

    VerticalBarchart.prototype.drawGroups = function() {
      return this.countries.enter().append('g').attr('class', (function(_this) {
        return function(d) {
          return "countries " + d[_this.groupKey];
        };
      })(this)).attr('transform', (function(_this) {
        return function(d) {
          return "translate(0," + (_this.yScale(d[_this.groupKey])) + ")";
        };
      })(this)).on("mouseover", this.mouseover);
    };

    VerticalBarchart.prototype.drawValues = function() {
      var values;
      values = this.countries.append('rect');
      values.attr('y', (function(_this) {
        return function(d) {
          return _this.yScale(d[_this.valueKey]);
        };
      })(this)).attr('height', this.yScale.rangeBand()).attr('width', (function(_this) {
        return function(d, i) {
          return _this.xScale(d[_this.valueKey]);
        };
      })(this));
      return values;
    };

    return VerticalBarchart;

  })(this.Barchart);

}).call(this);
