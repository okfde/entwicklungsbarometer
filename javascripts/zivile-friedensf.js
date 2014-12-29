(function() {
  var ZivileFriedensfoerderung,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ZivileFriedensfoerderung = (function(_super) {
    __extends(ZivileFriedensfoerderung, _super);

    function ZivileFriedensfoerderung(rawData, options) {
      this.rawData = rawData;
      this.options = options != null ? options : {};
      this.mouseover = __bind(this.mouseover, this);
      this.mouseout = __bind(this.mouseout, this);
      this.options = _.defaults(this.options, {
        width: 800,
        height: 300,
        margin: {
          top: 40,
          right: 80,
          bottom: 40,
          left: 80
        },
        ticks: {
          y: 7,
          x: 8
        }
      });
    }

    ZivileFriedensfoerderung.prototype.lineClassForElement = function(d) {
      return d[0].Country.toLowerCase();
    };

    ZivileFriedensfoerderung.prototype.setScalesAndDomain = function(data) {
      this.setDataKey('value');
      this.setDateKey('year');
      this.setYDomain([
        0, d3.max(data, function(d) {
          return d3.max(d, function(d) {
            return parseInt(d.value);
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

    ZivileFriedensfoerderung.prototype.drawPersonal = function(countries) {
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
      this.setScalesAndDomain(this.data);
      return this.data.forEach((function(_this) {
        return function(d) {
          return d.forEach(function(d) {
            return d.year = _this.parseDateFromYear(d.year);
          });
        };
      })(this));
    };

    ZivileFriedensfoerderung.prototype.dataFormat = function() {
      return locale_de_DE.numberFormat(",.");
    };

    ZivileFriedensfoerderung.prototype.mouseout = function(d) {
      d3.select("." + (d.Country.toLowerCase()) + " path").classed("country-hover", false);
      return this.focus.attr("transform", "translate(-100,-100)");
    };

    ZivileFriedensfoerderung.prototype.mouseover = function(d) {
      d3.select("." + (d.Country.toLowerCase()) + " path").classed("country-hover", true);
      this.focus.attr("transform", "translate(" + (this.xScale(d[this.dateKey])) + "," + (this.yScale(d[this.dataKey])) + ")");
      return this.focus.select("text").text("" + d.Country + ": $" + (this.dataFormat()(d[this.dataKey])) + " Mio");
    };

    return ZivileFriedensfoerderung;

  })(this.D3Linechart);

  $(function() {
    var zivilePath;
    if ($('#friedensfoerderung .zivile').length > 0) {
      zivilePath = "" + rootPath + "/data/security/friedensfoerderung/zivile.csv";
      return d3.csv(zivilePath, function(data) {
        var countries, personal;
        countries = ['Österreich', 'USA', 'Deutschland', 'Vereinigtes Königreich', 'Norwegen'];
        personal = new ZivileFriedensfoerderung(data);
        personal.setLineClass('countries');
        personal.drawPersonal(countries);
        personal.setYAxisDescription('in Mio $');
        personal.setXAxisDescription('Jahr');
        return personal.render('#friedensfoerderung .zivile');
      });
    }
  });

}).call(this);
