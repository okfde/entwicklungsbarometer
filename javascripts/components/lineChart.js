(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.D3Linechart = (function(_super) {
    __extends(D3Linechart, _super);

    function D3Linechart(data, options) {
      this.data = data;
      this.options = options != null ? options : {};
      this.mouseover = __bind(this.mouseover, this);
      this.mouseout = __bind(this.mouseout, this);
      this.options = _.defaults(this.options, {
        width: 800,
        height: 200,
        margin: {
          top: 40,
          right: 30,
          bottom: 150,
          left: 40
        },
        ticks: {
          y: 5,
          x: 4
        }
      });
    }

    D3Linechart.prototype.appendAxis = function() {
      this.svgSelection.append("g").attr("class", "x axis").attr("transform", "translate(0," + this.options.height + ")").call(this.xAxis);
      return this.svgSelection.append("g").attr("class", "y axis").attr("transform", "translate(0,0)").call(this.yAxis);
    };

    D3Linechart.prototype.appendAxisDescription = function() {
      this.svgSelection.append("text").attr('class', 'x description').attr("transform", "translate(" + (this.options.width / 2) + " ," + (this.options.height + this.options.margin.bottom) + ")").style("text-anchor", "middle").text(this.xAxisDescription);
      return this.svgSelection.append("text").attr('class', 'y description').attr("transform", "rotate(-90)").attr('y', 0 - this.options.margin.left).attr('x', 0 - (this.options.height / 2)).style("text-anchor", "middle").attr("dy", "1em").text(this.yAxisDescription);
    };

    D3Linechart.prototype.createMeanLine = function() {
      return this.meanLine = this.svgSelection.append("g").attr("class", "mean").append("path").datum(this.meanData).attr('d', this.meanLine).attr('class', 'line mean');
    };

    D3Linechart.prototype.setMeanData = function(data) {
      this.meanData = data;
      return this.meanData.forEach((function(_this) {
        return function(d) {
          return d.year = _this.parseDateFromYear(d.year);
        };
      })(this));
    };

    D3Linechart.prototype.setDataKey = function(key) {
      if (key == null) {
        key = 'value';
      }
      return this.dataKey = key;
    };

    D3Linechart.prototype.setDateKey = function(key) {
      if (key == null) {
        key = 'date';
      }
      return this.dateKey = key;
    };

    D3Linechart.prototype.setLineClass = function(key) {
      if (key == null) {
        key = 'lines';
      }
      return this.lineClass = key;
    };

    D3Linechart.prototype.setXAxisDescription = function(description) {
      if (description == null) {
        description = '';
      }
      return this.xAxisDescription = description;
    };

    D3Linechart.prototype.setYAxisDescription = function(description) {
      if (description == null) {
        description = '';
      }
      return this.yAxisDescription = description;
    };

    D3Linechart.prototype.lineClassForElement = function(d) {
      return d[this.dataKey];
    };

    D3Linechart.prototype.setLine = function() {
      return this.line = d3.svg.line().x((function(_this) {
        return function(d) {
          return _this.xScale(d[_this.dateKey]);
        };
      })(this)).y((function(_this) {
        return function(d) {
          return _this.yScale(d[_this.dataKey]);
        };
      })(this));
    };

    D3Linechart.prototype.setMeanLine = function() {
      return this.meanLine = d3.svg.line().x((function(_this) {
        return function(d) {
          return _this.xScale(d[_this.dateKey]);
        };
      })(this)).y((function(_this) {
        return function(d) {
          return _this.yScale(d.mean);
        };
      })(this));
    };

    D3Linechart.prototype.setVoronoi = function() {
      return this.voronoi = d3.geom.voronoi().x((function(_this) {
        return function(d) {
          return _this.xScale(d[_this.dateKey]);
        };
      })(this)).y((function(_this) {
        return function(d) {
          return _this.yScale(d[_this.dataKey]);
        };
      })(this)).clipExtent([[-this.options.margin.left, -this.options.margin.top], [this.options.width + this.options.margin.right, this.options.height + this.options.margin.bottom]]);
    };

    D3Linechart.prototype.setScales = function() {
      this.yScale = d3.scale.linear().range([this.options.height, 0]).domain(this.yScaleDomain);
      return this.xScale = d3.time.scale().range([0, this.options.width]).domain(this.xScaleDomain);
    };

    D3Linechart.prototype.setAxis = function() {
      this.yAxis = d3.svg.axis().scale(this.yScale).orient("left").ticks(this.options.ticks.y);
      return this.xAxis = d3.svg.axis().scale(this.xScale).orient("bottom").ticks(this.options.ticks.x);
    };

    D3Linechart.prototype.setGrid = function() {
      return this.yGrid = d3.svg.axis().scale(this.yScale).orient("left").ticks(this.options.ticks.y);
    };

    D3Linechart.prototype.setVoronoiData = function() {
      return this.voronoiData = _.flatten(this.data);
    };

    D3Linechart.prototype.createFocusElement = function() {
      this.focus = this.svgSelection.append("g").attr("class", "focus").attr("transform", "translate(-100,-100)");
      this.focus.append("circle").attr("r", 4.5);
      return this.focus.append("text").attr("y", -15);
    };

    D3Linechart.prototype.createOverlay = function() {
      this.voronoiGroup = this.svgSelection.append("g").attr("class", "voronoi");
      return this.voronoiGroup.selectAll("path").data(this.voronoi(this.voronoiData)).enter().append("path").attr("d", function(d) {
        if (d != null) {
          return "M" + (d.join("L")) + "Z";
        } else {
          return "";
        }
      }).datum(function(d) {
        if (d != null) {
          return d.point;
        }
      }).on("mouseover", this.mouseover).on("mouseout", this.mouseout);
    };

    D3Linechart.prototype.mouseout = function(d) {
      d3.select(this.lineClassForElement(d)).classed("hover", false);
      return this.focus.attr("transform", "translate(-100,-100)");
    };

    D3Linechart.prototype.mouseover = function(d) {
      d3.select(this.lineClassForElement(d)).classed("hover", true);
      this.focus.attr("transform", "translate(" + (this.xScale(d[this.dateKey])) + "," + (this.yScale(d[this.dataKey])) + ")");
      return this.focus.select("text").text("" + (Math.round(d[this.dataKey])));
    };

    D3Linechart.prototype.draw = function(data) {
      var graphGroup, graphs, line;
      graphGroup = this.svgSelection.selectAll("g." + this.lineClass).data(data);
      graphs = graphGroup.enter().append("g").attr('class', (function(_this) {
        return function(d) {
          return "" + _this.lineClass + " " + (_this.lineClassForElement(d));
        };
      })(this));
      line = graphs.append("path");
      return line.attr('class', 'line').attr("d", this.line);
    };

    D3Linechart.prototype.createAxisAndScales = function() {
      this.setLine();
      this.setVoronoi();
      this.setScales();
      this.setAxis();
      this.setGrid();
      return this.setVoronoiData();
    };

    D3Linechart.prototype.parseDateFromYear = function(year) {
      return new Date(year, 0, 1);
    };

    D3Linechart.prototype.render = function(element) {
      this.element = element;
      this.createAxisAndScales(this.data);
      this.createSvg();
      this.appendAxis();
      this.appendAxisDescription();
      this.createMeanLine();
      this.draw(this.data);
      this.createFocusElement();
      return this.createOverlay();
    };

    return D3Linechart;

  })(this.D3Graph);

}).call(this);
