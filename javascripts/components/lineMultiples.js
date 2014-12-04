(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.LineMultiples = (function(_super) {
    __extends(LineMultiples, _super);

    function LineMultiples(data, options) {
      this.data = data;
      this.options = options != null ? options : {};
      this.options = _.defaults(this.options, {
        width: 200,
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

    LineMultiples.prototype.drawMultiples = function() {
      this.data = _.groupBy(this.rawData, function(d) {
        return d.country;
      });
      this.data = _.map(this.data, (function(_this) {
        return function(data) {
          return _.sortBy(data, function(d) {
            return _this.parseDateFromYear(d.year);
          });
        };
      })(this));
      this.data.forEach((function(_this) {
        return function(d) {
          return d.forEach(function(d) {
            return d.year = _this.parseDateFromYear(d.year);
          });
        };
      })(this));
      return this.setScalesAndDomain(this.data[0]);
    };

    LineMultiples.prototype.createSvg = function() {
      return this.countries = d3.select(this.element).selectAll('svg.countries').data(this.data);
    };

    LineMultiples.prototype.draw = function(data) {
      var groups;
      groups = this.countries.enter().append('svg').attr('class', function(d) {
        return "" + (d[0].country.toLowerCase()) + " countries";
      }).attr('width', this.options.width + this.options.margin.left + this.options.margin.right).attr('height', this.options.height + this.options.margin.top + this.options.margin.bottom).append("g").attr("transform", "translate(" + this.options.margin.left + "," + this.options.margin.top + ")");
      groups.append("g").attr("class", "x axis").attr("transform", "translate(0," + this.options.height + ")").call(this.xAxis);
      groups.append("g").attr("class", "grid").call(this.yGrid.tickSize(-this.options.height, 0, 0).tickFormat(""));
      groups.append("text").attr("class", "name").text(function(d) {
        return d[0].country;
      }).attr('transform', "translate(" + (this.options.width / 2) + ",5)").attr('text-anchor', 'middle');
      groups.append("g").attr("class", "y axis").attr("transform", "translate(0,0)").call(this.yAxis);
      groups.append("path").datum(function(d) {
        return d;
      }).attr('d', this.line).attr('class', 'line');
      return groups.append("path").datum(this.meanData).attr('d', this.meanLine).attr('class', 'line mean');
    };

    return LineMultiples;

  })(this.D3Linechart);

}).call(this);
