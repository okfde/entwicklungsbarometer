(function() {
  this.D3Graph = (function() {
    function D3Graph(data, options) {
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

    D3Graph.prototype.createSvg = function() {
      return this.svgSelection || (this.svgSelection = d3.select(this.element).append('svg').attr('width', this.options.width + this.options.margin.left + this.options.margin.right).attr('height', this.options.height + this.options.margin.top + this.options.margin.bottom).append("g").attr("transform", "translate(" + this.options.margin.left + "," + this.options.margin.top + ")"));
    };

    D3Graph.prototype.createAxisAndScales = function(data) {
      this.yScale = d3.scale.linear().range([this.options.height, 0]).domain(this.yScaleDomain);
      this.xScale = d3.scale.ordinal().rangeRoundBands([0, this.options.width], .1).domain(this.xScaleDomain);
      this.xAxisScale = d3.scale.ordinal().rangeRoundBands([0, this.options.width], .1).domain(this.xScaleDomain);
      return this.xAxis = d3.svg.axis().scale(this.xAxisScale).orient("bottom");
    };

    D3Graph.prototype.appendAxis = function() {
      return this.svgSelection.append("g").attr("class", "x axis").attr("transform", "translate(0," + this.options.height + ")").call(this.xAxis);
    };

    D3Graph.prototype.setXDomain = function(domain) {
      return this.xScaleDomain = domain;
    };

    D3Graph.prototype.setYDomain = function(domain) {
      return this.yScaleDomain = domain;
    };

    D3Graph.prototype.draw = function(data) {
      var graphGroup;
      graphGroup = this.svgSelection.selectAll('g.graphs').data(data);
      graphGroup.enter().append('g').attr('transform', (function(_this) {
        return function(d, i) {
          return "translate(" + (_this.xScale(d)) + ",0)";
        };
      })(this)).attr('class', 'graphs');
      return graphGroup.exit().remove();
    };

    D3Graph.prototype.render = function(element) {
      this.element = element;
      this.createAxisAndScales(this.data);
      this.createSvg();
      this.appendAxis();
      return this.draw(this.data);
    };

    D3Graph.prototype.update = function(data) {
      this.data = data;
      this.createAxisAndScales(this.data);
      return this.draw(data);
    };

    return D3Graph;

  })();

}).call(this);
