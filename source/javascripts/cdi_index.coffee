@cdi_index = (element, key='overall') ->
  d3.json '/data/cdi.json', (err, data) ->
    gesamt = [10, data[key]]
    heights = [40,20]
    dx = [0,10]
    classes = ['max-score', 'score']
    width = 300
    height = 60
    scale = d3.scale.linear().domain([0, d3.max(gesamt)]).range([0, width])
    svg = d3.select(element).append('svg').attr('width', width).attr('height',height)
    bars = svg.selectAll('rect').data(gesamt)
    bars.enter().append('rect')
    bars.attr('x',0)
      .attr('y', (d,i) -> dx[i])
      .attr('width', (d) -> scale(d))
      .attr('height', (d,i) -> heights[i])
      .attr('class', (d,i) -> classes[i])
    svg.append('text').text(data[key]).attr('x', scale(data[key]) + 10).attr('y',25)
