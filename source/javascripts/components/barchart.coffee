class @Barchart extends @D3Graph
  constructor: (@data, @options = {}) ->
    @options = _.defaults(@options, { width: 800, height: 200, margin: {top: 40, right: 30, bottom: 120, left: 40}, ticks: { y: 5, x: 4 }, rotate: { x: true, y: false } })

  createYAxis: ->
    @svgSelection.append("g")
    .attr("class", "y axis")
    .attr("transform", "translate(0,0)")
    .call(@yAxis)

  setValueKey: (key='value') ->
    @valueKey = key

  setGroupKey: (key='group') ->
    @groupKey = key

  draw: (data) ->
    countries = @svgSelection.selectAll('g.countries').data(@data)
    countries
      .enter()
      .append('g')
      .attr('class', (d) => "countries #{d[@groupKey]}")
      .attr('transform', (d) => "translate(#{@xScale(d[@groupKey])},0)")

    values = countries.append('rect')
    values
      .attr('y', (d) => @yScale(d[@valueKey]))
      .attr('width', @xScale.rangeBand())
      .attr('height', (d,i) => @options.height - @yScale(d[@valueKey]))
    countries.append('text')
      .text((d) => d[@valueKey])
      .attr('y', (d) => @yScale(d[@valueKey]) - 10)
      .attr('x', @xScale.rangeBand()/2)
      .attr('text-anchor', 'middle')
      .attr('class', 'label')
    if @options.rotate.x
      @svgSelection.select('g.x.axis')
      .selectAll("text")
      .attr("y", 0)
      .attr("x", 9)
      .attr("dy", ".30em")
      .attr("transform", "rotate(90)")
      .style("text-anchor", "start")
