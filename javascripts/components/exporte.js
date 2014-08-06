(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Exporte = (function(_super) {
    __extends(Exporte, _super);

    function Exporte(data, options) {
      this.data = data;
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
    }

    Exporte.prototype.setDataKey = function(key) {
      if (key == null) {
        key = 'ruestung';
      }
      return this.dataKey = key;
    };

    Exporte.prototype.highlightTableForCountry = function(d) {
      return $("#exporte-2013 tr." + (formatCountry(d.Country))).addClass('active');
    };

    Exporte.prototype.unhighlightTableForCountry = function(d) {
      return $("#exporte-2013 tr." + (formatCountry(d.Country))).removeClass('active');
    };

    Exporte.prototype.draw = function(data) {
      var bars, graphGroup;
      graphGroup = this.svgSelection.selectAll('g.graphs').data(data);
      graphGroup.enter().append('g').attr('transform', (function(_this) {
        return function(d) {
          return "translate(" + (_this.xScale(d.Country)) + ",0)";
        };
      })(this)).attr('class', 'graphs');
      graphGroup.exit().remove();
      bars = graphGroup.selectAll('rect').data(function(d) {
        return [d];
      });
      bars.enter().append('rect');
      bars.exit().remove();
      bars.attr("y", (function(_this) {
        return function(d) {
          return _this.yScale(d[_this.dataKey]);
        };
      })(this)).attr("height", (function(_this) {
        return function(d) {
          return _this.options.height - _this.yScale(d[_this.dataKey]);
        };
      })(this)).attr("width", this.xScale.rangeBand()).on('mouseover', this.highlightTableForCountry).on('mouseout', this.unhighlightTableForCountry);
      return this.svgSelection.select('.axis.x').selectAll("text").attr("y", 0).attr("x", 9).attr("dy", ".35em").attr("transform", "rotate(90)").style("text-anchor", "start");
    };

    return Exporte;

  })(this.D3Graph);

}).call(this);
