(function() {
  var saferworlSubViz, showSaferworldViz,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Saferworld = (function(_super) {
    __extends(Saferworld, _super);

    function Saferworld(data, options) {
      this.data = data;
      this.options = options != null ? options : {};
      this.mouseover = __bind(this.mouseover, this);
      Saferworld.__super__.constructor.call(this, this.data, this.options);
      this.setValueKey('Average');
      this.setGroupKey('Country');
    }

    Saferworld.prototype.dataSetup = function() {
      _.map(this.data, function(d) {
        return d.Average = parseInt(d.Average);
      });
      this.data = _.sortBy(this.data, function(d) {
        return d.Average;
      });
      this.setXDomain(this.data.map(function(d) {
        return d.Country;
      }));
      return this.setYDomain([
        d3.min(this.data, function(d) {
          return d.Average;
        }), 100
      ]);
    };

    Saferworld.prototype.setSubscoreChart = function(chart) {
      return this.subViz = chart;
    };

    Saferworld.prototype.mouseover = function(d) {
      this.subViz.setValueKey(d.Country);
      return this.subViz.update(this.subViz.data);
    };

    return Saferworld;

  })(this.Barchart);

  this.SaferWorlSubViz = (function(_super) {
    __extends(SaferWorlSubViz, _super);

    function SaferWorlSubViz(data, options) {
      this.data = data;
      this.options = options != null ? options : {};
      SaferWorlSubViz.__super__.constructor.call(this, this.data, this.options);
    }

    SaferWorlSubViz.prototype.setup = function() {
      this.setValueKey('Deutschland');
      this.setGroupKey('Indikator');
      this.setYDomain(this.data.map(function(d) {
        return d.Indikator;
      }));
      return this.setXDomain([
        d3.min(this.data, function(d) {
          return d.Deutschland;
        }), 100
      ]);
    };

    SaferWorlSubViz.prototype.drawValueText = function() {
      this.countries.selectAll('text').remove();
      this.countries.append('text').text((function(_this) {
        return function(d) {
          return d[_this.valueKey];
        };
      })(this)).attr('x', (function(_this) {
        return function(d) {
          return _this.xScale(100) + 10;
        };
      })(this)).attr('y', this.yScale.rangeBand() / 2 + 2).attr('text-anchor', 'middle').attr('class', 'label');
      return this.countries.append('text').text((function(_this) {
        return function(d, i) {
          return _this.yScale.domain()[i];
        };
      })(this)).attr('y', this.yScale.rangeBand() / 2 + 4).attr('x', 5);
    };

    SaferWorlSubViz.prototype.mouseover = function(d) {
      return $('.saferworld-sub .description').html(d.Description);
    };

    return SaferWorlSubViz;

  })(this.VerticalBarchart);

  saferworlSubViz = function(data) {
    var options, subViz;
    options = {
      width: $('.saferworld-sub').width(),
      margin: {
        top: 50,
        bottom: 10,
        right: 20,
        left: 0
      },
      showExtent: true,
      rotate: {
        x: true
      }
    };
    subViz = new this.SaferWorlSubViz(data, options);
    subViz.setup();
    subViz.render('.saferworld-sub .barchart');
    return subViz;
  };

  showSaferworldViz = function() {
    var saferworldPath, saferworldSubPath;
    saferworldPath = "" + rootPath + "/data/security/transparenz/saferworld.csv";
    saferworldSubPath = "" + rootPath + "/data/security/transparenz/saferworld_by_indikator.csv";
    return queue().defer(d3.csv, saferworldPath).defer(d3.csv, saferworldSubPath).await(function(error, saferWorld, saferWorldByIndikator) {
      var options, saferworldChart;
      options = {
        showExtent: true,
        rotate: {
          x: true
        }
      };
      saferworlSubViz = saferworlSubViz(saferWorldByIndikator);
      saferworldChart = new this.Saferworld(saferWorld, options);
      saferworldChart.dataSetup();
      saferworldChart.setSubscoreChart(saferworlSubViz);
      return saferworldChart.render('.saferworld');
    });
  };

  $(function() {
    if ($('#transparenz .saferworld').length > 0) {
      return showSaferworldViz();
    }
  });

}).call(this);
