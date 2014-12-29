(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.AreaChart = (function(_super) {
    __extends(AreaChart, _super);

    function AreaChart(data, options) {
      this.data = data;
      this.options = options != null ? options : {};
      this.mouseover = __bind(this.mouseover, this);
      this.mouseout = __bind(this.mouseout, this);
      this.draw = __bind(this.draw, this);
      AreaChart.__super__.constructor.call(this, this.data, this.options);
    }

    AreaChart.prototype.stack = function() {
      return d3.layout.stack().values(function(d) {
        return d.values;
      });
    };

    AreaChart.prototype.area = function() {
      return d3.svg.area().x((function(_this) {
        return function(d) {
          return _this.xScale(d.date);
        };
      })(this)).y0((function(_this) {
        return function(d) {
          return _this.yScale(d.y0);
        };
      })(this)).y1((function(_this) {
        return function(d) {
          return _this.yScale(d.y0 + d.y);
        };
      })(this));
    };

    AreaChart.prototype.color = function() {
      return d3.scale.category20().domain(["civic", "military"]);
    };

    AreaChart.prototype.draw = function(data) {
      var zmf;
      zmf = this.svgSelection.selectAll(".zmf").data(this.stack()(this.data)).enter().append("g").attr("class", "zmf");
      return zmf.append("path").attr("class", "area").attr("d", (function(_this) {
        return function(d) {
          return _this.area()(d.values);
        };
      })(this)).style("fill", (function(_this) {
        return function(d) {
          return _this.color()(d.name);
        };
      })(this));
    };

    AreaChart.prototype.setVoronoi = function() {
      return this.voronoi = d3.geom.voronoi().x((function(_this) {
        return function(d) {
          return _this.xScale(d[_this.dateKey]);
        };
      })(this)).y((function(_this) {
        return function(d) {
          return _this.yScale(d.y0 + d.y);
        };
      })(this)).clipExtent([[-this.options.margin.left, -this.options.margin.top], [this.options.width + this.options.margin.right, this.options.height + this.options.margin.bottom]]);
    };

    AreaChart.prototype.setVoronoiData = function() {
      return this.voronoiData = _.flatten(this.data.map(function(d) {
        return d.values;
      }));
    };

    AreaChart.prototype.mouseout = function(d) {
      return this.focus.attr("transform", "translate(-100,-100)");
    };

    AreaChart.prototype.mouseover = function(d) {
      this.focus.attr("transform", "translate(" + (this.xScale(d[this.dateKey])) + "," + (this.yScale(d.y + d.y0)) + ")");
      return this.focus.select("text").text("$" + (Math.round(d[this.dataKey])) + " Mio").attr("text-anchor", "middle");
    };

    return AreaChart;

  })(this.D3Linechart);

}).call(this);
