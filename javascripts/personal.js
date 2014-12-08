(function() {
  var PeacekeepingPersonal,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PeacekeepingPersonal = (function(_super) {
    __extends(PeacekeepingPersonal, _super);

    function PeacekeepingPersonal(rawData, options) {
      this.rawData = rawData;
      this.options = options != null ? options : {};
      this.mouseover = __bind(this.mouseover, this);
      this.mouseout = __bind(this.mouseout, this);
      this.options = _.defaults(this.options, {
        width: 800,
        height: 300,
        margin: {
          top: 40,
          right: 30,
          bottom: 150,
          left: 80
        },
        ticks: {
          y: 7,
          x: 8
        }
      });
    }

    PeacekeepingPersonal.prototype.lineClassForElement = function(d) {
      return d[0].Country.toLowerCase();
    };

    PeacekeepingPersonal.prototype.setScalesAndDomain = function(data) {
      this.setDataKey('TotalPercent');
      this.setDateKey('year');
      this.setYDomain([
        0, d3.max(data, function(d) {
          return d3.max(d, function(d) {
            return d.TotalPercent;
          });
        })
      ]);
      this.setXDomain(d3.extent(data[0], (function(_this) {
        return function(d) {
          return _this.parseDateFromYear(d.year);
        };
      })(this)));
      return this;
    };

    PeacekeepingPersonal.prototype.drawPersonal = function(countries) {
      if (countries == null) {
        countries = [];
      }
      this.data = _.filter(this.rawData, function(d) {
        return _.contains(countries, d.Country);
      });
      this.data = _.groupBy(this.data, function(d) {
        return d.Country;
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
            return d.TotalPercent = parseFloat(d.TotalCost) * 100;
          });
        };
      })(this));
      this.setScalesAndDomain(this.data);
      return this.data.forEach((function(_this) {
        return function(d) {
          return d.forEach(function(d) {
            return d.year = _this.parseDateFromYear(d.year);
          });
        };
      })(this));
    };

    PeacekeepingPersonal.prototype.dataFormat = function() {
      return d3.numberFormat(",.3f");
    };

    PeacekeepingPersonal.prototype.mouseout = function(d) {
      d3.select("." + (d.Country.toLowerCase()) + " path").classed("country-hover", false);
      return this.focus.attr("transform", "translate(-100,-100)");
    };

    PeacekeepingPersonal.prototype.mouseover = function(d) {
      d3.select("." + (d.Country.toLowerCase()) + " path").classed("country-hover", true);
      this.focus.attr("transform", "translate(" + (this.xScale(d[this.dateKey])) + "," + (this.yScale(d[this.dataKey])) + ")");
      return this.focus.select("text").text("" + d.Country + ": " + (this.dataFormat()(d[this.dataKey])) + " % of GDP");
    };

    return PeacekeepingPersonal;

  })(this.D3Linechart);

  $(function() {
    var personalPath;
    if ($('#personal').length > 0) {
      personalPath = "" + rootPath + "/data/security/peacekeeping/peacekeepingPersonal.csv";
      return d3.csv(personalPath, function(data) {
        var countries, personal;
        countries = ['Austria', 'Finland', 'Germany', 'Luxembourg', 'EU', 'Slovakia'];
        personal = new PeacekeepingPersonal(data);
        personal.setLineClass('countries');
        personal.drawPersonal(countries);
        return personal.render('#personal');
      });
    }
  });

}).call(this);
