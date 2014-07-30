(function() {
  this.cdi_index = function(element, key) {
    if (key == null) {
      key = 'overall';
    }
    return d3.json(rootPath + '/data/cdi.json', function(err, data) {
      var bars, classes, dx, gesamt, height, heights, scale, svg, width;
      gesamt = [10, data[key]];
      heights = [40, 20];
      dx = [0, 10];
      classes = ['max-score', 'score'];
      width = 300;
      height = 60;
      scale = d3.scale.linear().domain([0, d3.max(gesamt)]).range([0, width]);
      svg = d3.select(element).append('svg').attr('width', width).attr('height', height);
      bars = svg.selectAll('rect').data(gesamt);
      bars.enter().append('rect');
      bars.attr('x', 0).attr('y', function(d, i) {
        return dx[i];
      }).attr('width', function(d) {
        return scale(d);
      }).attr('height', function(d, i) {
        return heights[i];
      }).attr('class', function(d, i) {
        return classes[i];
      });
      return svg.append('text').text(data[key]).attr('x', scale(data[key]) + 10).attr('y', 25);
    });
  };

}).call(this);
