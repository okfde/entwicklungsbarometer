class @Barchart extends @D3Graph
  constructor: (@data, @options = {}) ->
    @options = _.defaults(@options, { width: 800, height: 200, margin: {top: 40, right: 30, bottom: 120, left: 40}, ticks: { y: 5, x: 4 }, rotate: { x: false, y: false }, showExtent: false })
    @extentClass = "extent"

  createYAxis: ->
    @svgSelection.append("g")
    .attr("class", "y axis")
    .attr("transform", "translate(0,0)")
    .call(@yAxis)

  setValueKey: (key='value') ->
    @valueKey = key

  setGroupKey: (key='group') ->
    @groupKey = key

  showExtent: ->
    @countries.append('rect')
      .attr('y',0).attr('width', @xScale.rangeBand())
      .attr('height', @options.height)
      .attr('class', @extentClass)

  rotateLabels: (axis) ->
    @svgSelection.select("g.#{axis}.axis")
    .selectAll("text")
    .attr("y", 0)
    .attr("x", 9)
    .attr("dy", ".30em")
    .attr("transform", "rotate(90)")
    .style("text-anchor", "start")

  mouseover: (d) ->
    @

  drawValues: ->
    values = @countries.append('rect')
    values
      .attr('y', (d) => @yScale(d[@valueKey]))
      .attr('width', @xScale.rangeBand())
      .attr('height', (d,i) => @options.height - @yScale(d[@valueKey]))
    values

  drawGroups: ->
    @countries
      .enter()
      .append('g')
      .attr('class', (d) => "countries #{d[@groupKey]}")
      .attr('transform', (d) => "translate(#{@xScale(d[@groupKey])},0)")
      .on("mouseover", @mouseover)

  drawValueText: ->
    @countries.append('text')
      .text((d) => d[@valueKey])
      .attr('y', (d) => @yScale(d[@valueKey]) - 10)
      .attr('x', @xScale.rangeBand()/2)
      .attr('text-anchor', 'middle')
      .attr('class', 'label')

  draw: (data) ->
    @countries = @svgSelection.selectAll('g.countries').data(@data)
    @drawGroups()
    if @options.showExtent
      @showExtent()
    @drawValues()
    @drawValueText()

  render: (@element) ->
    @createAxisAndScales(@data)
    @createSvg()
    @draw(@data)
    @appendAxis()
    if @options.rotate.x
      @rotateLabels("x")
