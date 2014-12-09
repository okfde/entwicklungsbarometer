(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  this.LargeMultiples = (function(_super) {
    __extends(LargeMultiples, _super);

    function LargeMultiples(data, options) {
      this.data = data;
      this.options = options != null ? options : {};
      this.valueClasss = __bind(this.valueClasss, this);
      this.options = _.defaults(this.options, {
        width: 900,
        height: 350,
        margin: {
          top: 40,
          right: 30,
          bottom: 10,
          left: 40
        },
        circles: {
          radius: 12,
          padding: 10
        }
      });
      this.value1Key = "key1";
      this.value2Key = "key2";
      this.valueClass1 = "value-1";
      this.valueClass2 = "value-2";
    }

    LargeMultiples.prototype.setValueKeys = function(value1, value2) {
      this.value1Key = value1;
      return this.value2Key = value2;
    };

    LargeMultiples.prototype.setValueClasses = function(valueClasses) {
      return this.valueClasses = valueClasses;
    };

    LargeMultiples.prototype.valueClasss = function(d, i) {
      var className, value, _i, _len, _ref;
      _ref = this.valueClasses;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        value = _ref[_i];
        if (__indexOf.call(value.range, i) >= 0) {
          className = value.className;
        }
      }
      return className;
    };

    LargeMultiples.prototype.draw = function(data) {
      var graphGroup, num, teiler;
      data = (function() {
        var _i, _ref, _results;
        _results = [];
        for (num = _i = _ref = data[0][this.value1Key]; _ref <= 1 ? _i <= 1 : _i >= 1; num = _ref <= 1 ? ++_i : --_i) {
          _results.push(data[0]);
        }
        return _results;
      }).call(this);
      teiler = Math.floor(this.options.width / (2 * this.options.circles.radius + this.options.circles.padding));
      graphGroup = this.svgSelection.selectAll('g.multiples').data(data);
      graphGroup.enter().append("g");
      graphGroup.attr("class", "multiples").attr("transform", (function(_this) {
        return function(d, i) {
          var translateX, translateY;
          translateX = (i % teiler) * (2 * _this.options.circles.radius + _this.options.circles.padding);
          translateY = _this.options.height - (Math.ceil((i + 1) / teiler) * (_this.options.circles.padding + 2 * _this.options.circles.radius));
          return "translate(" + translateX + "," + translateY + ")";
        };
      })(this));
      graphGroup.selectAll("circle").remove();
      graphGroup.append("circle").attr("r", this.options.circles.radius).attr("class", this.valueClasss);
      return graphGroup.exit().remove();
    };

    LargeMultiples.prototype.render = function(element) {
      this.element = element;
      this.createSvg();
      return this.draw(this.data);
    };

    LargeMultiples.prototype.update = function(data) {
      this.data = data;
      return this.draw(this.data);
    };

    return LargeMultiples;

  })(this.D3Graph);

}).call(this);
