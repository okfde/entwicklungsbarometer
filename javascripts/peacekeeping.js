(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Peacekeeping = (function(_super) {
    __extends(Peacekeeping, _super);

    function Peacekeeping(rawData, options) {
      this.rawData = rawData;
      this.options = options != null ? options : {};
      this.mouseover = __bind(this.mouseover, this);
      this.mouseout = __bind(this.mouseout, this);
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
          y: 7,
          x: 8
        }
      });
    }

    Peacekeeping.prototype.lineClassForElement = function(d) {
      return d[0].country.toLowerCase();
    };

    Peacekeeping.prototype.setScalesAndDomain = function(data) {
      this.setDataKey('per_capita');
      this.setDateKey('year');
      this.setYDomain([
        0, d3.max(data, (function(_this) {
          return function(d) {
            return Math.ceil(parseFloat(d[_this.dataKey]));
          };
        })(this))
      ]);
      this.setXDomain(d3.extent(data, (function(_this) {
        return function(d) {
          return _this.parseDateFromYear(d.year);
        };
      })(this)));
      return this;
    };

    Peacekeeping.prototype.dataFormat = function() {
      return d3.numberFormat(",.2f");
    };

    Peacekeeping.prototype.mouseout = function(d) {
      d3.select("." + (d.country.toLowerCase()) + " path").classed("country-hover", false);
      return this.focus.attr("transform", "translate(-100,-100)");
    };

    Peacekeeping.prototype.mouseover = function(d) {
      d3.select("." + (d.country.toLowerCase()) + " path").classed("country-hover", true);
      this.focus.attr("transform", "translate(" + (this.xScale(d[this.dateKey])) + "," + (this.yScale(d[this.dataKey])) + ")");
      return this.focus.select("text").text("" + d.country + ": $" + (this.dataFormat()(d[this.dataKey])) + " Mio");
    };

    Peacekeeping.prototype.drawSingle = function(countryName) {
      var data;
      data = _.filter(this.rawData, function(d) {
        return d.country === countryName;
      });
      data = _.sortBy(data, (function(_this) {
        return function(d) {
          return _this.parseDateFromYear(d.year);
        };
      })(this));
      this.data = [data];
      this.setScalesAndDomain(this.data[0]);
      return this.data.forEach((function(_this) {
        return function(d) {
          return d.forEach(function(d) {
            return d.year = _this.parseDateFromYear(d.year);
          });
        };
      })(this));
    };

    Peacekeeping.prototype.drawSpecific = function(countries) {
      if (countries == null) {
        countries = [];
      }
      this.data = _.filter(this.rawData, function(d) {
        return _.contains(countries, d.country);
      });
      this.data = _.groupBy(this.data, function(d) {
        return d.country;
      });
      this.data = _.map(this.data, (function(_this) {
        return function(data) {
          return _.sortBy(data, function(d) {
            return _this.parseDateFromYear(d.year);
          });
        };
      })(this));
      this.setScalesAndDomain(this.data[0]);
      return this.data.forEach((function(_this) {
        return function(d) {
          return d.forEach(function(d) {
            return d.year = _this.parseDateFromYear(d.year);
          });
        };
      })(this));
    };

    return Peacekeeping;

  })(this.D3Linechart);

  $(function() {
    var peacekeepingMeanPath, peacekeepingPath;
    if ($('#peacekeeping .contributions').length > 0) {
      peacekeepingPath = "" + rootPath + "/data/security/peacekeeping/peacekeeping_contributions.csv";
      peacekeepingMeanPath = "" + rootPath + "/data/security/peacekeeping/means.csv";
      return queue().defer(d3.csv, peacekeepingPath).defer(d3.csv, peacekeepingMeanPath).await(function(error, data, meanData) {
        var options, pk;
        options = {
          width: 800,
          height: 400,
          margin: {
            top: 20,
            left: 20,
            bottom: 20,
            right: 80
          }
        };
        pk = new Peacekeeping(data, options);
        pk.setMeanData(meanData);
        pk.drawSpecific(['Deutschland', '', 'Norwegen', 'Dänemark', 'Polen']);
        pk.setLineClass("countries");
        pk.setMeanLine();
        return pk.render('.contributions');
      });
    }
  });

}).call(this);
